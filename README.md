# InstaHMS

The InstaHMS project addresses the daily operations of a hospital via effective queries in MySQL. 
This project covers all the steps right from: 
* Schema creation
* Defining constraints
* Data insertion
* Optimized queries to retrieve results quicker
* Inbuilt stored functions and procedures to store the repetitive actions
* Triggers to handle the incoming insertion, updation, and deletion of data

## Schema
![instahms-schema](https://github.com/sai-hari98/instahms/assets/30078806/a8a7a93c-860a-41e6-9c35-c3ba198b9abf)

## Queries
Some sample queries of this project are
1. Display the Medication details of a patient along with the diagnosis and the prescriber info
![image](https://github.com/sai-hari98/instahms/assets/30078806/adb6b6e8-47a7-4d81-8b07-2049efeadf24)

2. To find the possible rooms that can be allocated for a patient who’s going to undergo surgery
![image](https://github.com/sai-hari98/instahms/assets/30078806/c20cc636-9155-48aa-bfd0-e196da609447)

## Stored Functions
1. Function to find the patient id using DOB and mobile number
![image](https://github.com/sai-hari98/instahms/assets/30078806/a7d6db70-0090-486e-9aa4-4086d3a39f44)

2. Function to get the appointment details using patient id
![image](https://github.com/sai-hari98/instahms/assets/30078806/fe0ad30a-d7b2-4ea9-845c-d7fe7b4f901d)

## Stored Procedures
1. Stored Procedure to reschedule an appointment
![image](https://github.com/sai-hari98/instahms/assets/30078806/0d994ab7-963a-486b-8e67-314dd3391948)

2. Stored Procedure to update an inventory request
![image](https://github.com/sai-hari98/instahms/assets/30078806/4cdec712-f837-456c-b627-41910f286d72)

## Triggers
1. Trigger to assign 'Patient' as default 'UserRole' if not specified while a new user
registers into the system. This trigger also encrypts the password using MD5.
![image](https://github.com/sai-hari98/instahms/assets/30078806/bb49e44d-85d1-4b23-aecf-3c626c16a5fa)

2. Trigger to log the patient details in the backup transaction table before updating the patient info
![image](https://github.com/sai-hari98/instahms/assets/30078806/e0e077d9-5fc2-44c2-b4b9-8d6d0ec18d24)


