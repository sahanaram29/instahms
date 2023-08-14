/*************** CREATING TABLES **********************/
DROP SCHEMA IF EXISTS instahms;
CREATE SCHEMA IF NOT EXISTS instahms;
USE instahms;

--
-- Table structure for table `Appointment_T`
--

DROP TABLE IF EXISTS Appointment_T;

CREATE TABLE Appointment_T (
  AppointmentID int NOT NULL,
  PatientID int DEFAULT NULL,
  DoctorID int DEFAULT NULL,
  AppointmentDate date DEFAULT NULL,
  AppointmentTime time DEFAULT NULL,
  ReasonForVisit varchar(255) DEFAULT NULL,
  AppointmentStatus varchar(20) DEFAULT NULL,
  PRIMARY KEY (AppointmentID)
) ;

--
-- Table structure for table `Billing_T`
--

DROP TABLE IF EXISTS Billing_T;
CREATE TABLE Billing_T (
  BillingID int NOT NULL AUTO_INCREMENT,
  PatientID int DEFAULT NULL,
  RecordID int DEFAULT NULL,
  TotalCost int DEFAULT NULL,
  BillingDate date DEFAULT NULL,
  PaymentInformation varchar(24) DEFAULT NULL,
  PRIMARY KEY (BillingID)
) ;


--
-- Table structure for table `Department_REF_T`
--

DROP TABLE IF EXISTS Department_REF_T;

CREATE TABLE Department_REF_T (
  DepartmentID int NOT NULL AUTO_INCREMENT,
  DepartmentName varchar(50) DEFAULT NULL,
  DepartmentDescription varchar(150) DEFAULT NULL,
  PRIMARY KEY (DepartmentID)
) ;


--
-- Table structure for table `Doctor_T`
--

DROP TABLE IF EXISTS Doctor_T;

CREATE TABLE Doctor_T (
  DoctorID int NOT NULL AUTO_INCREMENT,
  UserID int DEFAULT NULL,
  Specialization varchar(54) DEFAULT NULL,
  LicenseInformation varchar(24) DEFAULT NULL,
  AppointmentSchedule varchar(54) DEFAULT NULL,
  PRIMARY KEY (DoctorID)
) ;

--
-- Table structure for table `Employee_T`
--

DROP TABLE IF EXISTS Employee_T;

CREATE TABLE Employee_T (
  EmployeeID int NOT NULL AUTO_INCREMENT,
  UserID int DEFAULT NULL,
  DepartmentID int DEFAULT NULL,
  EmployeePosition varchar(40) DEFAULT NULL,
  Salary int DEFAULT NULL,
  HireDate date DEFAULT NULL,
  PRIMARY KEY (EmployeeID)
) ;


--
-- Table structure for table `Imaging_T`
--

DROP TABLE IF EXISTS Imaging_T;

CREATE TABLE Imaging_T (
  ImagingID int NOT NULL AUTO_INCREMENT,
  PatientID int DEFAULT NULL,
  DoctorID int DEFAULT NULL,
  ImagingType varchar(54) DEFAULT NULL,
  ImagingDate date DEFAULT NULL,
  ImagingResults varchar(512) DEFAULT NULL,
  ImagingCenter varchar(100) DEFAULT NULL,
  PRIMARY KEY (ImagingID)
) ;



--
-- Table structure for table `Insurance_T`
--

DROP TABLE IF EXISTS Insurance_T;

CREATE TABLE Insurance_T (
  InsuranceID int NOT NULL AUTO_INCREMENT,
  PatientID int DEFAULT NULL,
  PolicyNumber varchar(16) DEFAULT NULL,
  ProviderName varchar(50) DEFAULT NULL,
  PolicyStartDate date DEFAULT NULL,
  PolicyEndDate date DEFAULT NULL,
  PRIMARY KEY (InsuranceID)
) ;


--
-- Table structure for table `Inventory_T`
--

DROP TABLE IF EXISTS Inventory_T;

CREATE TABLE Inventory_T (
  InventoryID int NOT NULL AUTO_INCREMENT,
  ItemName varchar(100) NOT NULL,
  ItemDescription varchar(512) DEFAULT NULL,
  Quantity int NOT NULL,
  Cost decimal(7,2) NOT NULL,
  SupplierInformation varchar(512) DEFAULT NULL,
  PRIMARY KEY (InventoryID)
) ;


--
-- Table structure for table `LabResult_T`
--

DROP TABLE IF EXISTS LabResult_T;

CREATE TABLE LabResult_T (
  ResultID int NOT NULL AUTO_INCREMENT,
  TestID int NOT NULL,
  ResultDate date DEFAULT NULL,
  ResultValue varchar(56) DEFAULT NULL,
  PRIMARY KEY (ResultID)
) ;


--
-- Table structure for table `LabTest_T`
--

DROP TABLE IF EXISTS LabTest_T;

CREATE TABLE LabTest_T (
  TestID int NOT NULL AUTO_INCREMENT,
  PatientID int DEFAULT NULL,
  DoctorID int DEFAULT NULL,
  TestName varchar(56) DEFAULT NULL,
  TestDate date DEFAULT NULL,
  TestResults varchar(512) DEFAULT NULL,
  LabName varchar(104) DEFAULT NULL,
  PRIMARY KEY (TestID)
) ;


--
-- Table structure for table `MedicalRecord_T`
--

DROP TABLE IF EXISTS MedicalRecord_T;

CREATE TABLE MedicalRecord_T (
  RecordID int NOT NULL AUTO_INCREMENT,
  PatientID int NOT NULL,
  DoctorID int NOT NULL,
  RecordDate date NOT NULL,
  Diagnosis varchar(512) NOT NULL,
  TreatmentPlan varchar(512) NOT NULL,
  MedicationInformation varchar(512) NOT NULL,
  PRIMARY KEY (RecordID)
) ;




--
-- Table structure for table `Nurse_T`
--

DROP TABLE IF EXISTS Nurse_T;

CREATE TABLE Nurse_T (
  NurseID int NOT NULL,
  UserID int NOT NULL,
  DepartmentID int DEFAULT NULL,
  ShiftDescription varchar(50) DEFAULT NULL,
  MondayShift varchar(20) DEFAULT NULL,
  TuesdayShift varchar(20) DEFAULT NULL,
  WednesdayShift varchar(20) DEFAULT NULL,
  ThursdayShift varchar(20) DEFAULT NULL,
  FridayShift varchar(20) DEFAULT NULL,
  SaturdayShift varchar(20) DEFAULT NULL,
  SundayShift varchar(20) DEFAULT NULL,
  PRIMARY KEY (NurseID)
) ;


--
-- Table structure for table `Patient_T`
--

DROP TABLE IF EXISTS Patient_T;

CREATE TABLE Patient_T (
  PatientID int NOT NULL AUTO_INCREMENT,
  UserID int NOT NULL,
  DateofBirth date DEFAULT NULL,
  Gender varchar(12) DEFAULT NULL,
  Address varchar(100) DEFAULT NULL,
  EmergencyContactInformation varchar(100) DEFAULT NULL,
  PRIMARY KEY (PatientID)
) ;


--
-- Table structure for table `Prescription_T`
--

DROP TABLE IF EXISTS Prescription_T;

CREATE TABLE Prescription_T (
  PrescriptionID int NOT NULL AUTO_INCREMENT,
  RecordID int NOT NULL,
  DoctorID int DEFAULT NULL,
  MedicationName varchar(100) DEFAULT NULL,
  DosageInstructions varchar(100) DEFAULT NULL,
  PharmacyInformation varchar(100) DEFAULT NULL,
  PRIMARY KEY (PrescriptionID)
) ;


--
-- Table structure for table `Request_Status_REF_T`
--

DROP TABLE IF EXISTS Request_Status_REF_T;

CREATE TABLE Request_Status_REF_T (
  RequestStatusID int NOT NULL,
  RequestStatusDescription varchar(512) DEFAULT NULL,
  PRIMARY KEY (RequestStatusID)
) ;


--
-- Table structure for table `Room_T`
--

DROP TABLE IF EXISTS Room_T;

CREATE TABLE Room_T (
  RoomID INT NOT NULL AUTO_INCREMENT,
  RoomNumber INT DEFAULT NULL,
  RoomType VARCHAR(12) DEFAULT NULL,
  RoomDescription VARCHAR(60) DEFAULT NULL,
  OccupancyStatus VARCHAR(16) DEFAULT NULL,
  PatientID INT DEFAULT NULL,
  PRIMARY KEY (RoomID)
) ;



--
-- Table structure for table `Shift_Timings_T`
--

DROP TABLE IF EXISTS Shift_Timings_T;

CREATE TABLE Shift_Timings_T (
  ShiftID int NOT NULL AUTO_INCREMENT,
  EmployeeID int NOT NULL,
  StartTime time NOT NULL,
  EndTime time NOT NULL,
  DayOfTheWeek int NOT NULL,
  PRIMARY KEY (ShiftID)
) ;


--
-- Table structure for table `Supply_Request_T`
--

DROP TABLE IF EXISTS Supply_Request_T;

CREATE TABLE Supply_Request_T (
  RequestID int NOT NULL AUTO_INCREMENT,
  InventoryID int NOT NULL,
  EmployeeID int NOT NULL,
  QuantityRequested int NOT NULL,
  DateRequested date NOT NULL,
  RequestStatusID int NOT NULL,
  PRIMARY KEY (RequestID)
) ;


--
-- Table structure for table `Surgery_T`
--

DROP TABLE IF EXISTS Surgery_T;

CREATE TABLE Surgery_T (
  SurgeryID int NOT NULL AUTO_INCREMENT,
  PatientID int NOT NULL,
  DoctorID int DEFAULT NULL,
  SurgeryType varchar(50) DEFAULT NULL,
  SurgeryDate date DEFAULT NULL,
  AnesthesiaInformation varchar(20) DEFAULT NULL,
  PostOpCareInstructions varchar(100) DEFAULT NULL,
  PRIMARY KEY (SurgeryID)
);


--
-- Table structure for table `User_T`
--

DROP TABLE IF EXISTS User_T;

CREATE TABLE User_T (
  UserID int NOT NULL AUTO_INCREMENT,
  Username varchar(24) DEFAULT NULL,
  UserPassword varchar(100) DEFAULT NULL,
  FirstName varchar(54) DEFAULT NULL,
  LastName varchar(54) DEFAULT NULL,
  Email varchar(54) DEFAULT NULL,
  PhoneNumber varchar(16) DEFAULT NULL,
  UserRole varchar(24) DEFAULT NULL,
  PRIMARY KEY (UserID)
) ;

--
-- Table structure for table `Patient_Details_Backup_T`
--

DROP TABLE IF EXISTS Patient_Details_Backup_T;
CREATE TABLE Patient_Details_Backup_T(
TxnID int not null auto_increment,
PatientID int not null, 
UserID int not null, 
DateofBirth DATE not null,
Gender VARCHAR(12) NOT NULL, 
Address VARCHAR(100) NOT NULL, 
EmergencyContactInformation VARCHAR(100) NOT NULL,
PRIMARY KEY (TxnID),
FOREIGN KEY (PatientID) REFERENCES patient_t(PatientID),
FOREIGN KEY (UserID) REFERENCES user_t(UserID)
);