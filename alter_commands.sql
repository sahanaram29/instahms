#================================================= ADDING FOREIGN KEYS =============================================#


	#================================================  Employee_T  =========================================================
	
	ALTER TABLE Employee_T ADD CONSTRAINT UserID_User_FK FOREIGN KEY(UserID) REFERENCES User_T(UserID);
	ALTER TABLE Employee_T ADD CONSTRAINT DepartmentID_User_FK FOREIGN KEY(DepartmentID) REFERENCES Department_REF_T(DepartmentID);


	#==========================================   Department_REF_T   =========================================================

	#================================================  Surgery  =========================================================
		
		ALTER TABLE Surgery_T 
		ADD CONSTRAINT DoctorID_Surgery_FK FOREIGN KEY(DoctorID) REFERENCES Doctor_T(DoctorID);
		ALTER TABLE Surgery_T 
		ADD CONSTRAINT PatientID_Surgery_FK FOREIGN KEY(PatientID) REFERENCES Patient_T(PatientID);
		
        
	#=================================================   Room   ============================================================#------------------------------------------------------Room_T----------------------------------------------------------------------------
		
        ALTER TABLE Room_T
		ADD CONSTRAINT PatientID_Room_FK FOREIGN KEY (PatientID) REFERENCES Patient_T(PatientID);


	#=============================================  Inventory_T   ============================================================
	# ==================================================Shift timing =========================================================

		ALTER TABLE Shift_Timings_T
		ADD CONSTRAINT EmployeeID_Shift_Timings_FK FOREIGN KEY (EmployeeID) REFERENCES Employee_T(EmployeeID);

	#=====================================================Supply Request=========================================================

		ALTER TABLE Supply_Request_T
		ADD CONSTRAINT InventoryID_Supply_Request_FK FOREIGN KEY (InventoryID) REFERENCES Inventory_T(InventoryID);
		ALTER TABLE Supply_Request_T
		ADD CONSTRAINT EmployeeID_Supply_Request_FK FOREIGN KEY (EmployeeID) REFERENCES Employee_T(EmployeeID);
		ALTER TABLE Supply_Request_T
		ADD CONSTRAINT RequestStatusID_Supply_Request_FK FOREIGN KEY (RequestStatusID) REFERENCES Request_Status_REF_T(RequestStatusID);

	#==================================================Request Status=========================================================

	#================================================== Billing_T =============================================================

		ALTER TABLE Billing_T
		ADD CONSTRAINT Patient_Billing_FK FOREIGN KEY (PatientID) REFERENCES Patient_T(PatientID);
		#Run only after adding data to MedicalRecord_T
		ALTER TABLE Billing_T
		ADD CONSTRAINT Record_Billing_FK FOREIGN KEY (RecordID) REFERENCES MedicalRecord_T(RecordID);
		
	#==================================================  Insurance  ===========================================================
		
		ALTER TABLE Insurance_T
		ADD CONSTRAINT PatientID_Insurance_T FOREIGN KEY(PatientID) REFERENCES Patient_T (PatientID);

	#================================================  Prescription_T  =======================================================
		
		ALTER TABLE Prescription_T
		ADD CONSTRAINT Doctor_Prescription_FK FOREIGN KEY (DoctorID) REFERENCES Doctor_T(DoctorID);
		#Run only after adding data to MedicalRecord_T
		ALTER TABLE Prescription_T
		ADD CONSTRAINT Record_Prescription_FK FOREIGN KEY (RecordID) REFERENCES MedicalRecord_T(RecordID);

	#========================================================  User  =============================================================

	#=====================================================  Patient_T  ==========================================================

		ALTER TABLE Patient_T
		ADD CONSTRAINT UserID_Patient_FK FOREIGN KEY (UserID) REFERENCES User_T(UserID);
		
	#------------------------------------------------------Doctor_T------------------------------------------------------------

		ALTER TABLE Doctor_T 
		ADD CONSTRAINT UserID_Doctor_FK FOREIGN KEY (UserID) REFERENCES User_T(UserID);
		
	#======================================================= LabTest_T ==========================================================
		
		ALTER TABLE LabTest_T 
		ADD CONSTRAINT PatientID_LabTest_FK FOREIGN KEY (PatientID) REFERENCES Patient_T(PatientID);
		ALTER TABLE LabTest_T
		ADD CONSTRAINT DoctorID_LabTest_FK FOREIGN KEY(DoctorID) REFERENCES Doctor_T(DoctorID);

	#====================================================== lab_results_t ======================================================

		ALTER TABLE LabResult_T
		ADD CONSTRAINT TestID_LabResult_FK FOREIGN KEY (TestID) REFERENCES LabTest_T (TestID);

	#======================================================= Imaging_T  =======================================================
		
		ALTER TABLE Imaging_T
		ADD CONSTRAINT PatientID_Imaging_FK FOREIGN KEY (PatientID) REFERENCES Patient_T(PatientID);
		ALTER TABLE Imaging_T
		ADD CONSTRAINT DoctorID_Imaging_FK FOREIGN KEY(DoctorID) REFERENCES Doctor_T(DoctorID);

	#======================================================= Nurse_T  =======================================================

		ALTER TABLE Nurse_T
		ADD CONSTRAINT UserID_Nurse_FK FOREIGN KEY (UserID) REFERENCES User_T(UserID);
		ALTER TABLE Nurse_T
		ADD CONSTRAINT DepartmentID_Nurse_FK FOREIGN KEY (DepartmentID) REFERENCES Department_REF_T(DepartmentID);

	#======================================================= Appointment_T =======================================================

		ALTER TABLE Appointment_T
		ADD CONSTRAINT PatientID_Appointment_FK FOREIGN KEY (PatientID) REFERENCES Patient_T(PatientID);
		ALTER TABLE Appointment_T
		ADD CONSTRAINT DoctorID_Appointment_FK FOREIGN KEY (DoctorID) REFERENCES Doctor_T(DoctorID);


	#======================================================= MedicalRecord_T  =======================================================

		ALTER TABLE MedicalRecord_T
		ADD CONSTRAINT PatientID_MedicalRecord_FK FOREIGN KEY (PatientID) REFERENCES Patient_T(PatientID);
		ALTER TABLE MedicalRecord_T
		ADD CONSTRAINT DoctorID_MedicalRecord_FK FOREIGN KEY (DoctorID) REFERENCES Doctor_T(DoctorID);