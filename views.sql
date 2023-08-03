#A View to hide the personal details of patients when the data is being operated by users like Receptionists
CREATE VIEW patientView AS 
SELECT u.FirstName, u.LastName, p.Gender, p.Address, p.EmergencyContactInformation from patient_t p
inner join user_t u on u.UserId = p.UserId;

Select * from patientview;

#A View consisting of Total Amount Paid by Each Patient along with a Patient Name
CREATE VIEW TotalAmountPaidByEachPatient AS
select concat(u.FirstName,' ',u.LastName) as PatientName, sum(b.TotalCost) as TotalAmountPaid from billing_t b
inner join patient_t p on p.PatientID = b.PatientID
inner join user_t u on p.UserID = u.UserID
group by b.PatientID
order by TotalAmountPaid DESC;

Select * from TotalAmountPaidByEachPatient;