########################################### Stored_Procedures ##########################################
##1st Stored Procedure - Display vacant rooms
DROP PROCEDURE IF EXISTS display_vacant_rooms;

DELIMITER //

CREATE PROCEDURE display_vacant_rooms()
BEGIN
SELECT RoomID FROM Room_T WHERE OccupancyStatus = 'Available';
END//
DELIMITER ;

#Instance of SP to Display vacant rooms
CALL display_vacant_rooms();



## 2nd Stored Procedure to update the inventory requests in supply_requests table 
DROP PROCEDURE IF EXISTS update_inventory_request;

DELIMITER //

CREATE PROCEDURE update_inventory_request(
in_inventoryID INT,
in_employeeID INT,
statusDesc VARCHAR(512)
)
BEGIN
DECLARE statusID INT;
SELECT RequestStatusID INTO statusID FROM request_status_ref_t WHERE RequestStatusDescription = statusDesc;
UPDATE supply_request_t SET RequestStatusID = statusID WHERE InventoryID = in_inventoryID AND EmployeeID = in_employeeID;
END//

DELIMITER ;
#instance of update_inventory_request SP 
#update statusDescription as  'Approved' for inventory request with inventoryID = 2, employeeID = 2  
select * from supply_request_t;
call update_inventory_request(2,2,'Approved');
SELECT * FROM supply_request_t WHERE inventoryID = 2 AND employeeID = 2  ;


##3rd Stored Procedure - To reschedule appointment
DROP PROCEDURE IF EXISTS reschedule_appointment;

DELIMITER //

CREATE PROCEDURE reschedule_appointment(
newAppointmentDate DATE,
newAppointmentTime TIME,
pat_ID INT,
doc_ID INT
)
BEGIN
UPDATE appointment_t SET AppointmentDate = newAppointmentDate, AppointmentTime = newAppointmentTime
WHERE PatientID = pat_ID AND DoctorID = doc_ID;
END //
DELIMITER ;
#instance of reschedule_appointment SP
#Reschedule the appointment of patient with ID  = 1 with doctor having ID 1 to new 
#Appointment Date and Time '2023-08-01' and '11:00:00' respectively
call reschedule_appointment('2023-08-01','11:00:00',1,1);
SELECT * FROM Appointment_T WHERE PatientID = 1 AND DoctorID = 1;


#Stored Procedure - 4. A combination of Stored Procedure and Trigger - process_supply_request - for handling supply request

##############  REQUIREMENTS for this NEW PROCEDURE  #########
# RUN THE ALTER SCRIPT
alter table supply_request_t add requestFlagCod varchar(20);

#go to Edit > Preferences > SQL editor > scroll down > uncheck the safe option
#restart the mysql editor


#RUN THIS UPDATE
##simple update query to update flagcod in supply_request table based on statusID 

Update supply_request_t sup
join request_status_ref_t req
on sup.RequestStatusID = req.RequestStatusID
SET sup.requestFlagCod = req.RequestStatusDescription
where sup.requestFlagCod is null;


##CREATE INVENTORY LOG TABLE
CREATE TABLE `inventory_log_details` (
  `employeeID` int DEFAULT NULL,
  `shift_start_time` datetime DEFAULT NULL,
  `shift_end_time` datetime DEFAULT NULL
)

############### Continue to Create Procedure which is combined with a trigger in a single delimiter block ##############
DELIMITER //

CREATE PROCEDURE process_supply_request(in p_request_id INT, out p_result varchar(100))
BEGIN
  DECLARE v_inventory_id INT;
  DECLARE v_employee_id INT;
  DECLARE v_quantity_requested INT;
  DECLARE v_inventory_quantity INT;
  DECLARE v_inventory_cost DECIMAL(10, 2);
  DECLARE v_request_status VARCHAR(20);

  -- get the inventory ID, employee ID, quantity requested, and request status for the given request ID
  SELECT inventoryID, employeeID, quantityRequested, requestFlagCod
  INTO v_inventory_id, v_employee_id, v_quantity_requested, v_request_status
  FROM supply_request_t
  WHERE request_ID = p_request_id;

  -- if the request status is not "Pending", do nothing
  IF v_request_status <> 'Pending' THEN
	SET p_result = 'No Changes Made!!';
  END IF;

  -- get the current inventory quantity and cost for the given inventory ID
  SELECT quantity, cost INTO v_inventory_quantity, v_inventory_cost
  FROM inventory_t
  WHERE inventoryID = v_inventory_id;

  -- if there is not enough inventory, set the request status to "Denied" and return
  IF v_quantity_requested > v_inventory_quantity THEN
    UPDATE supply_request_t
    SET requestFlagCod = 'Denied'
    WHERE requestID = p_request_id;
     SET p_result = 'Status Denied updated!';
  END IF;

  -- update the inventory quantity and cost, and set the request status to "Approved"
  UPDATE inventory_t
  SET quantity = quantity - v_quantity_requested,
  cost = v_inventory_cost * (1 - v_quantity_requested / v_inventory_quantity)
  WHERE inventoryID = v_inventory_id;


  -- insert a new row into the shift table for the employee who requested the supply
  INSERT INTO inventory_log_details (employeeID, shift_start_time, shift_end_time)
  VALUES (v_employee_id, NOW(), NOW() + INTERVAL 8 HOUR);
  
  SET p_result = 'Inventory updated and shift added.';
  
END //
#drop trigger supply_request_after_update;
CREATE TRIGGER supply_request_after_update
AFTER UPDATE ON supply_request_t
FOR EACH ROW
BEGIN
  -- if the request status has been changed to "Approved", call the process_supply_request stored procedure
   IF OLD.requestFlagCod <> NEW.requestFlagCod THEN
    CALL process_supply_request(NEW.requestID);
  END IF;
END //

DELIMITER ;