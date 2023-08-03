################################################# All_Trigger #################################################
#drop trigger before_insert_user
#1# A 'Before Insert Trigger' to assign 'UserRole' as 'Patient' if 'UserRole' is not given
Delimiter //
CREATE TRIGGER before_insert_user
BEFORE INSERT ON user_t
FOR EACH ROW
BEGIN
  -- Generate a new unique ID for the user
  SET NEW.userID = FLOOR(RAND() * 1000000);

  -- Check if the user role is valid, default to 'Patient' if not specified
  IF NEW.UserRole NOT IN ('Patient', 'Nurse', 'Doctor', 'Admin') THEN
    SET NEW.UserRole = 'Patient';
  END IF;

  -- Encrypt the user password before inserting
  SET NEW.userPassword = MD5(NEW.userPassword);
END //
Delimiter ;
ALTER TABLE user_t MODIFY COLUMN userPassword VARCHAR(100);
#testing trigger
INSERT INTO user_t (username, userPassword, Firstname, Lastname, email, phonenumber, UserRole)
VALUES ('sahanar', 'r', 'Sahana',
 'Ram', 'sr29@gmail.com', '000-000-022', 'Patient');
select * from user_t where username='sahanar';

#2. Trigger to automatically update a patient's EmergencyContactInformation when their EmergencyContactInformation is changed:
DELIMITER //
CREATE TRIGGER update_emergency_contact
AFTER UPDATE ON Patient_T
FOR EACH ROW
BEGIN
    IF NEW.EmergencyContactInformation <> OLD.EmergencyContactInformation THEN
        UPDATE Patient_T
        SET EmergencyContactInformation = NEW.EmergencyContactInformation
        WHERE PatientID = NEW.PatientID;
    END IF;
END; //
DELIMITER ;
#Testing:
INSERT INTO Patient_T (PatientID, UserID, EmergencyContactInformation)
VALUES (100, 1, 'John Smith - 555-1234');
#updating emergency contact
UPDATE Patient_T
SET EmergencyContactInformation = 'Jane Doe - 555-5678'
WHERE PatientID = 100;
#updated result
SELECT EmergencyContactInformation FROM Patient_T WHERE PatientID = 100;


#3. write a trigger to store the patient details before updating them
DELIMITER //
CREATE TRIGGER store_patient_details
BEFORE UPDATE ON Patient_T
FOR EACH ROW
BEGIN
    INSERT INTO Patient_Details_Backup (PatientID, UserID, DateofBirth, Gender, Address, EmergencyContactInformation)
    VALUES (OLD.PatientID, OLD.UserID, OLD.DateofBirth, OLD.Gender, OLD.Address, OLD.EmergencyContactInformation);
END; //
DELIMITER ;