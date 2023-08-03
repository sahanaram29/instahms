########################################### Stored_Functions ###########################################

#1.Function to find the patient id using DOB and mobile number
drop function IF EXISTS find_patient_id;

delimiter //
create function find_patient_id(
phone_number varchar(16),
dob date
)
returns int
READS SQL DATA
DETERMINISTIC
begin
declare patient_id int;
select p.PatientID into patient_id from patient_t p
inner join user_t u on u.UserID = p.UserID
where u.PhoneNumber = phone_number and p.DateOfBirth=dob;
return (patient_id);
end//

delimiter ;
#Example instancing SF find_patient_id
SELECT find_patient_id('+1 123-456-7890', '1980-01-01') AS PatientID; #1 "John", "Doe"
SELECT find_patient_id('+1 456-789-0123', '1988-08-08') AS PatientID; #4 "Jane", "Parker"


#2. Function for insurances that are expiring within the next 30 days from the current date.
DROP FUNCTION insurance_expiring_soon;
DELIMITER //
CREATE FUNCTION insurance_expiring_soon(date_param DATE) 
RETURNS INT
Deterministic
BEGIN
DECLARE current_date_var DATE;
SET current_date_var = COALESCE(date_param, CURDATE());
    RETURN (
        SELECT 
            PatientID
        FROM 
            insurance_t
        WHERE 
            PolicyEndDate >= current_date_var
            AND PolicyEndDate <= DATE_ADD(current_date_var, INTERVAL 30 DAY)
    );
END//
DELIMITER ;
#Check for insurance expiring in 30 days on '2023-04-29'
SELECT insurance_expiring_soon('2023-04-29');

#3. Function retrieves the appointment details for a specific patient

DELIMITER //
CREATE FUNCTION get_appointment_details_for_patient(p_patient_id INT)
RETURNS varchar(512)
Deterministic
BEGIN
DECLARE AppointmentTiming_var VARCHAR(512);
SELECT CONCAT(AppointmentDate, ' ', AppointmentTime) INTO AppointmentTiming_var
        FROM Appointment_T
        WHERE PatientID = p_patient_id
        ORDER BY AppointmentDate DESC, AppointmentTime DESC
        LIMIT 1;
    RETURN  AppointmentTiming_var;
END//

DELIMITER ;
#Get the appointment timing for patient with ID 1
SELECT get_appointment_details_for_patient(1);


#4. update_or_insert_inventory_item - To update or insert 
#inventory after checking if that item is existing or not, returns the InventoryID 
DELIMITER //
CREATE FUNCTION update_or_insert_inventory_item(
  p_item_name VARCHAR(50),
  p_item_description VARCHAR(255),
  p_quantity INT,
  p_cost DECIMAL(10, 2),
  p_supplier_information VARCHAR(255)
) RETURNS INT
Reads SQL DATA
deterministic
BEGIN
  DECLARE v_inventory_id INT;
  
  -- check if the item already exists in the inventory table
  SELECT inventoryID INTO v_inventory_id
  FROM inventory_t
  WHERE itemName = p_item_name AND itemDescription = p_item_description;
  
  -- if the item exists, update its quantity and cost
  IF v_inventory_id IS NOT NULL THEN
    UPDATE inventory_t
    SET quantity = quantity + p_quantity, cost = p_cost
    WHERE inventoryID = v_inventory_id;
  -- if the item doesn't exist, insert a new row
  ELSE
    INSERT INTO inventory_t (itemName, itemDescription, quantity, cost, supplierInformation)
    VALUES (p_item_name, p_item_description, p_quantity, p_cost, p_supplier_information);
    SET v_inventory_id = LAST_INSERT_ID();
  END IF;
  
  RETURN v_inventory_id;
END//
DELIMITER ;

#Testing Stored func update_or_insert_inventory_item
SELECT inventoryID
  FROM inventory_t
  WHERE itemName = 'Syringes' AND itemDescription = '5ml, sterile, disposable';
select * from inventory_t;
SELECT update_or_insert_inventory_item('Syringes', '5ml, sterile, disposable',
	1000, 0.25, 'ABC Medical Supplies, 123 Main St, Denver USA');
#OLD RECORD
#1	Syringes	5ml, sterile, disposable	500	0.25	ABC Medical Supplies, 123 Main St, Anytown USA



#5. update_inventory_item - check if the item already exists in the inventory table 
# and returns the update status
#drop function update_inventory_item
DELIMITER //
CREATE FUNCTION update_inventory_item(
  p_inventory_id INT,
  p_quantity INT,
  p_cost DECIMAL(10, 2),
  p_supplier_information VARCHAR(255)
) RETURNS varchar(250)
Reads SQL DATA
deterministic
BEGIN
  -- check if the item already exists in the inventory table
  SELECT COUNT(*) INTO @exists
  FROM inventory_t
  WHERE inventoryID = p_inventory_id;
  
  -- if the item exists, update its quantity, cost, and supplier information
  IF @exists THEN
    UPDATE inventory_t
    SET quantity = p_quantity, cost = p_cost, supplierInformation = p_supplier_information
    WHERE inventoryID = p_inventory_id;
    RETURN 'Updated successfully';
  -- if the item doesn't exist, return 0 to indicate failure
  ELSE
    RETURN 'Update Failed!';
  END IF;
END//
DELIMITER ;

#Testing:
SELECT update_inventory_item(1, 1000, 0.30, 'ABC Medical Supplies, 123 Main St, Denver USA'); #'Updated successfully'
SELECT update_inventory_item(71, 1000, 0.30, 'ABC Medical Supplies, 123 Main St, Denver USA'); #'Update Failed!'