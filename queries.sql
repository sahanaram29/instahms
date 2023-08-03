##################################################### All_Queries ###########################################

#Query - 1. Display the average age of the patients
SELECT AVG(TIMESTAMPDIFF(Year, DateofBirth, NOW())) AS AveragePatientAge FROM Patient_T;

#Query - 2. Test Details whose analysed results are yet to arrive
SELECT * FROM LabResult_T
RIGHT JOIN LabTest_T
USING (TestID)
WHERE ResultID IS NULL
ORDER BY TestID;

#Subquery -3. Find all the surgeries that were performed in a specific department:
SELECT * FROM surgery_t
WHERE DoctorID IN (
    SELECT EmployeeID FROM employee_t
    WHERE DepartmentID = (
        SELECT DepartmentID FROM department_ref_t
        WHERE DepartmentName = 'Cardiology'
    )
);

#SubQuery - 4. Aggregate Fn Used - 4. Find all the employees who make more than the average salary in their department:
SELECT * FROM employee_t
WHERE Salary > (
    SELECT AVG(Salary) FROM employee_t e
    WHERE DepartmentID = e.DepartmentID
);

#SubQuery - 5. Find the number of surgeries performed by each doctor in the Neurology department:
select * from surgery_t;
SELECT DoctorID, COUNT(*) AS num_surgeries
FROM surgery_t
WHERE DoctorID IN (
    SELECT EmployeeID FROM employee_t
    WHERE DepartmentID = (
        SELECT DepartmentID FROM department_ref_t
        WHERE DepartmentName = 'Neurology'
    )
)
GROUP BY DoctorID;




#6 Inner Join Queries
#Query using inner join - Total Amount paid by each customer to the hospital
select concat(u.FirstName,' ',u.LastName) as PatientName, sum(b.TotalCost) as TotalAmountPaid from billing_t b
inner join patient_t p on p.PatientID = b.PatientID
inner join user_t u on p.UserID = u.UserID
group by b.PatientID
order by TotalAmountPaid DESC;

#Query using inner join - medication for the patients with condition
#REQUIRES find_patient_id which is a User Defined Stored Function to find the patient id using DOB and mobile number
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

#Query to get medication summary for any patient
select p.MedicationName, p.DosageInstructions, concat(u.FirstName,' ',u.LastName) as PrescriberName, mr.Diagnosis
from prescription_t p
inner join medicalrecord_t mr on p.RecordID = mr.RecordID
inner join doctor_t d on d.DoctorID = p.DoctorID
inner join user_t u on u.UserID = d.UserID
where mr.PatientID = find_patient_id('+1 678-901-2345','2067-09-10');

#Query using inner join  - Display the inventory requests yet to be approved orderd by requested date
SELECT RequestID, InventoryID, QuantityRequested FROM supply_request_t
INNER JOIN Request_Status_REF_T
WHERE  RequestStatusDescription = 'Pending'
ORDER BY DateRequested;

#Query using inner join - Check if the bill generated date for the patients is within the policy coverage dates.
SELECT DISTINCT p.PatientID,i.PolicyStartDate,i.PolicyEndDate
FROM patient_t p
INNER JOIN insurance_t i ON p.PatientID = i.InsuranceID
INNER JOIN billing_t b ON p.PatientID = b.PatientID
WHERE b.BillingDate BETWEEN '2020-01-01' AND '2022-12-31'
AND b.TotalCost > 0
AND i.PolicyStartDate <= b.BillingDate
AND i.PolicyEndDate >= b.BillingDate;

#Query - Using Inner Join - find past lab results for a patient
select lt.TestName, concat(u.FirstName,' ',u.LastName) as DoctorName, lt.TestDate, lr.ResultValue from labresult_t lr
inner join labtest_t lt on lr.TestID = lt.TestID
inner join doctor_t d on lt.DoctorID = d.DoctorID
inner join user_t u on u.UserID = d.UserID
where lt.PatientID = find_patient_id('123-456-7890','1980-01-01')
order by lt.TestDate desc;

#Displays all imaging records for a patient
select i.ImagingType, i.ImagingDate, i.ImagingResults, concat(u.FirstName,' ',u.LastName) as DoctorName from imaging_t i
inner join doctor_t d on i.DoctorID = d.DoctorID
inner join user_t u on u.UserID = d.UserID
where i.PatientID = find_patient_id('123-456-7890','1980-01-01');

## Stored Function 'find_patient_id' is required to execute this
select concat(u.FirstName, ' ', u.LastName) as PatientName, i.ProviderName, i.PolicyNumber, b.TotalCost, b.BillingDate,
case
	when b.BillingDate > i.PolicyEndDate or b.BillingDate < i.PolicyStartDate
		then 'N'
	else 'Y' end as Covered,
    b.PaymentInformation, i.PolicyStartDate,i.PolicyEndDate
from billing_t b
inner join patient_t p on b.PatientID = p.PatientID
inner join user_t u on u.UserID = p.UserID
inner join insurance_t i on i.PatientID = b.PatientID
where b.PatientID = find_patient_id('+1 678-901-2345','2067-09-10');

#Query - Using Left Join - To see all the patients who have been prescribed medication but have not been billed yet:
SELECT *
FROM prescription_t
LEFT JOIN billing_t
ON prescription_t.RecordID = billing_t.RecordID
WHERE billing_t.RecordID IS NULL;

#Query - Using Left Join - Find all doctors who have not performed any surgeries:
SELECT *
FROM doctor_t d
LEFT OUTER JOIN surgery_t s ON d.doctorID = s.doctorID WHERE s.doctorID IS NULL;

#Query - Using Right Join - To see all the surgeries scheduled, including any that do not have a room assigned yet:
SELECT *
FROM surgery_t
RIGHT OUTER JOIN room_t ON surgery_t.SurgeryID = room_t.RoomID;

#Query - Using Right Join - Test Details whose analysed results are yet to arrive
SELECT * FROM LabResult_T
RIGHT JOIN LabTest_T
USING (TestID)
WHERE ResultID IS NULL
ORDER BY TestID;

#Query - Cross Join to find the possible rooms that can be allocated for a patient who’s going to undergo surgery
select distinct r.RoomID, r.RoomNumber, s.PatientID, s.SurgeryDate from room_t r
cross join surgery_T s
where r.PatientID IS NULL and s.PatientID = find_patient_id('+1 678-901-2345','2067-09-10')
AND OccupancyStatus = 'Available';