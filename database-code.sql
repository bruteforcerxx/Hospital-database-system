IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'GPHospital')
BEGIN
    CREATE DATABASE GPHospital;
END

-- Use the GP hospital database
USE GPHospital;
GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT * FROM Departments


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create Departments table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Departments')
BEGIN
    CREATE TABLE Departments (
        DepartmentID INT PRIMARY KEY IDENTITY (1, 1),
        DepartmentName VARCHAR(100) NOT NULL,
		CONSTRAINT Unique_Department UNIQUE (DepartmentName)
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create Doctors table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Doctors')
BEGIN
    CREATE TABLE Doctors (
        DoctorID INT PRIMARY KEY IDENTITY (1, 1),
		Title VARCHAR(100),
        FirstName VARCHAR(100) NOT NULL,
		MiddleName VARCHAR(100),
		LastName VARCHAR(100) NOT NULL,
        DepartmentID INT NOT NULL,
		Specialty VARCHAR(100),
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
		CONSTRAINT Unique_Doctor UNIQUE (FirstName, MiddleName, LastName, DepartmentID)
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++








--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create PatientsBioData table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PatientsBioData')
BEGIN
    CREATE TABLE PatientsBioData (
        PatientID INT PRIMARY KEY IDENTITY (1, 1),
        FirstName VARCHAR(100) NOT NULL,
		MiddleName VARCHAR(100),
		LastName VARCHAR(100) NOT NULL,
        Address VARCHAR(255) NOT NULL,
        DateOfBirth DATE NOT NULL,
		CONSTRAINT Unique_Patients UNIQUE (FirstName, MiddleName, LastName, Address, DateOfBirth)
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++








--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create PatientPortal table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PatientPortal')
BEGIN
    CREATE TABLE PatientPortal (
        PatientID INT PRIMARY KEY,
        EmailAddress NVARCHAR(100) ,
        PhoneNumber VARCHAR(20),
		InsuranceNumber VARCHAR(100) NOT NULL,
        Status VARCHAR(10) DEFAULT 'Active',
        Username VARCHAR(50) NOT NULL,
        HashedPassword VARCHAR(255),
		Salt VARCHAR(255),
		DateLeft DATE,
        CONSTRAINT CK_ValidEmailFormat CHECK (EmailAddress LIKE '%@%.%'),
		CONSTRAINT Unique_PatientsUsername UNIQUE (Username),
		CONSTRAINT Unique_PatientsID UNIQUE (PatientID),
		CONSTRAINT Unique_Insurance UNIQUE (InsuranceNumber),
		FOREIGN KEY (PatientID) REFERENCES PatientsBioData(PatientID)
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++









--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create Appointments table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Appointments')
BEGIN
    CREATE TABLE Appointments (
        AppointmentID INT PRIMARY KEY IDENTITY (1, 1),
        PatientID INT,
        DoctorID INT,
        AppointmentDate DATE NOT NULL,
        AppointmentTime TIME NOT NULL,
		AppointmentCompletedTime TIME,
        DepartmentID INT,
        Status VARCHAR(20) DEFAULT 'Pending',
        FOREIGN KEY (PatientID) REFERENCES PatientsBioData(PatientID),
        FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
		CONSTRAINT Unique_Appointments UNIQUE (DoctorID, AppointmentDate, AppointmentTime),
		CONSTRAINT CHK_AppointmentDate CHECK (AppointmentDate >= CONVERT(DATE, GETDATE()))
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create Appointments table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PastAppointments')
BEGIN
    CREATE TABLE PastAppointments (
        PastAppointmentID INT PRIMARY KEY IDENTITY (1, 1),
        PatientID INT,
        DoctorID INT,
        AppointmentDate DATE NOT NULL,
        AppointmentTime TIME NOT NULL,
		AppointmentCompletedTime TIME,
        DepartmentID INT,
        Status VARCHAR(20),
        Outcome VARCHAR(MAX),
        FollowUpInstructions VARCHAR(MAX),
        FOREIGN KEY (PatientID) REFERENCES PatientsBioData(PatientID),
        FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create Diagnosis table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Diagnosis')
BEGIN
    CREATE TABLE Diagnosis (
        DiagnosisID INT PRIMARY KEY IDENTITY (1, 1),
        PatientID INT,
        DoctorID INT,
        DiagnosisDate DATE,
        DiagnosisName VARCHAR(100) NOT NULL,
        FOREIGN KEY (PatientID) REFERENCES PatientsBioData(PatientID),
        FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
		CONSTRAINT Unique_Diagnosis UNIQUE (PatientID, DoctorID,  DiagnosisDate, DiagnosisName)
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create Medicines table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Medicines')
BEGIN
    CREATE TABLE Medicines (
        MedicineID INT PRIMARY KEY IDENTITY (1, 1),
        MedicineName VARCHAR(100) NOT NULL,
        Description VARCHAR(MAX),
        Manufacturer VARCHAR(100),
        ExpiryDate DATE,
        Price DECIMAL(10, 2),
        Quantity INT,
        IsActive BIT DEFAULT 1
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create Allergies table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Allergies')
BEGIN
    CREATE TABLE Allergies (
        AllergyID INT PRIMARY KEY IDENTITY (1, 1),
        PatientID INT,
        AllergyName VARCHAR(100) NOT NULL,
        AllergyDate DATE,
        FOREIGN KEY (PatientID) REFERENCES PatientsBioData(PatientID)
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create MedicinesPrescribed table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MedicinesPrescribed')
BEGIN
    CREATE TABLE MedicinesPrescribed (
        PrescriptionID INT PRIMARY KEY IDENTITY (1, 1),
        DiagnosisID INT,
        PatientID INT,
        DoctorID INT,
        MedicineID INT,
        Quantity INT,
        PrescriptionDate DATE,
        FOREIGN KEY (DiagnosisID) REFERENCES Diagnosis(DiagnosisID),
        FOREIGN KEY (PatientID) REFERENCES PatientsBioData(PatientID),
        FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
        FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID),
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create Reviews table if it does not exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Reviews')
BEGIN
    CREATE TABLE Reviews (
        ReviewID INT PRIMARY KEY IDENTITY (1, 1),
        PatientID INT,
        DoctorID INT,
        Rating INT,
        Feedback VARCHAR(MAX),
        FOREIGN KEY (PatientID) REFERENCES PatientsBioData(PatientID),
        FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    );
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Creating Users and priviledges for our sql server
CREATE LOGIN ADMINISTRATOR
WITH PASSWORD = 'Admin1234';

CREATE USER ADMINISTRATOR FOR LOGIN ADMINISTRATOR;
GO
GRANT SELECT, INSERT, DELETE, UPDATE ON Departments TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON Doctors TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON PatientsBioData TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON PatientPortal TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON Appointments TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON PastAppointments TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON Diagnosis TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON Medicines TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON Allergies TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON MedicinesPrescribed TO ADMINISTRATOR WITH GRANT OPTION;
GRANT SELECT, INSERT, DELETE, UPDATE ON Reviews TO ADMINISTRATOR WITH GRANT OPTION;
GRANT BACKUP DATABASE TO ADMINISTRATOR;
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- PATIENT REGISTERATION
CREATE PROCEDURE RegisterPatient
    @FirstName VARCHAR(100),
    @MiddleName VARCHAR(100),
    @LastName VARCHAR(100),
    @Address VARCHAR(255),
    @DateOfBirth DATE,
    @InsuranceNumber VARCHAR(100),
    @EmailAddress NVARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @Username VARCHAR(50),
    @PlainPassword VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @Salt VARCHAR(255);
        DECLARE @HashedPassword VARCHAR(255);
        DECLARE @PatientID INT;

        -- Insert patient data into PatientsBioData table
        INSERT INTO PatientsBioData (FirstName, MiddleName, LastName, Address, DateOfBirth)
        VALUES (@FirstName, @MiddleName, @LastName, @Address, @DateOfBirth);

        -- Get the newly generated PatientID
        SET @PatientID = SCOPE_IDENTITY();
		
        -- Generate salt and hash password
        SET @Salt = CAST(CRYPT_GEN_RANDOM(32) AS NVARCHAR(64));
        SET @HashedPassword = HASHBYTES('SHA2_512', @PlainPassword + @Salt);

        -- Insert patient portal data
        INSERT INTO PatientPortal (PatientID, EmailAddress, PhoneNumber, Username,  InsuranceNumber, HashedPassword, Salt)
        VALUES (@PatientID, @EmailAddress, @PhoneNumber, @Username, @InsuranceNumber, @HashedPassword, @Salt);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        -- Raise an error or handle the exception as needed
        THROW;
    END CATCH;
END;

EXEC RegisterPatient @FirstName = 'John', @MiddleName = 'Doe', @LastName = 'Smith', @Address = '123 Main St', @DateOfBirth = '1990-05-15', @InsuranceNumber = '123456789', @EmailAddress = 'john@example.com', @PhoneNumber = '123-456-7890', @Username = 'johnsmith1', @PlainPassword = 'MySecretPassword1';

EXEC RegisterPatient @FirstName = 'Jane', @MiddleName = 'Doe', @LastName = 'Smith', @Address = '456 Elm St', @DateOfBirth = '1988-09-20', @InsuranceNumber = '987654321', @EmailAddress = 'jane@example.com', @PhoneNumber = '987-654-3210', @Username = 'janesmith1', @PlainPassword = 'MySecretPassword2';

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- STORED PROCEDURE TO BOOK AN APPOINTMENT
CREATE PROCEDURE BookAppointment
    @PatientID INT,
    @DoctorID INT,
    @DepartmentID INT,
    @AppointmentDate DATE,
    @AppointmentTime TIME
AS
BEGIN
    DECLARE @LastPendingAppointmentTime TIME

    -- Begin transaction to ensure atomicity
    BEGIN TRANSACTION

    -- Get the time of the doctor's last pending appointment with an exclusive lock
    SELECT TOP 1 @LastPendingAppointmentTime = AppointmentTime
    FROM Appointments WITH (UPDLOCK, HOLDLOCK)
    WHERE DoctorID = @DoctorID
        AND DepartmentID = @DepartmentID
        AND AppointmentDate = @AppointmentDate
        AND Status = 'Pending'
    ORDER BY AppointmentTime DESC

    -- Check if the last pending appointment time is within an hour of the requested appointment time
    IF @LastPendingAppointmentTime IS NULL OR DATEDIFF(MINUTE, @LastPendingAppointmentTime, @AppointmentTime) >= 60
    BEGIN
        -- Appointment time is at least an hour after the last pending appointment, so it can be booked
        INSERT INTO Appointments (PatientID, DoctorID, DepartmentID, AppointmentDate, AppointmentTime, Status)
        VALUES (@PatientID, @DoctorID, @DepartmentID, @AppointmentDate, @AppointmentTime, 'Pending')

        -- Commit the transaction if successful
        COMMIT TRANSACTION
    END
    ELSE
    BEGIN
        -- Rollback the transaction if unsuccessful
        ROLLBACK TRANSACTION
    END
END

-- Inserting 2 records into the Departments table
INSERT INTO Departments (DepartmentName)
VALUES 
    ('Cardiology'),
    ('Neurology');

-- Inserting 2 records into the Doctors table
INSERT INTO Doctors (Title, FirstName, MiddleName, LastName, DepartmentID, Specialty)
VALUES 
    ('Dr.', 'John', 'A.', 'Smith', 1, 'Cardiologist'),
    ('Dr.', 'Emily', '', 'Johnson', 2, 'Neurologist');

EXEC BookAppointment @PatientID = 1, @DoctorID = 1, @DepartmentID = 1, @AppointmentDate = '2024-04-20', @AppointmentTime = '10:00:00';
EXEC BookAppointment @PatientID = 2, @DoctorID = 2, @DepartmentID = 2, @AppointmentDate = '2024-04-20', @AppointmentTime = '11:00:00';
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--STORED PROCEDUURE TO CANCEL AN APPOINTMENT
CREATE PROCEDURE CancelAppointment
    @AppointmentID INT
AS
BEGIN
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Update the status of the appointment to 'Cancelled'
        UPDATE Appointments
        SET Status = 'Cancelled'
        WHERE AppointmentID = @AppointmentID;

        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if an error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH
END;
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--STORED PROCEDURE TO REBOOK AN APPOINTMENT
CREATE PROCEDURE RebookAppointment
    @AppointmentID INT,
    @NewAppointmentDate DATE,
    @NewAppointmentTime TIME
AS
BEGIN
    BEGIN TRY
        DECLARE @PatientID INT, @DoctorID INT, @DepartmentID INT, @Status VARCHAR(20);

        -- Retrieve appointment details
        SELECT @PatientID = PatientID,
               @DoctorID = DoctorID,
               @DepartmentID = DepartmentID
        FROM Appointments
        WHERE AppointmentID = @AppointmentID AND Status = 'Available';

        -- Start a transaction
        BEGIN TRANSACTION;

        -- Rebook the appointment
        INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, DepartmentID, Status)
        VALUES (@PatientID, @DoctorID, @NewAppointmentDate, @NewAppointmentTime, @DepartmentID, 'Pending');

        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if an error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH
END;
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


GO
EXEC CancelAppointment @AppointmentID = 8;
EXEC CancelAppointment @AppointmentID = 27;
EXEC CancelAppointment @AppointmentID = 31;

EXEC RebookAppointment @AppointmentID = 31, @NewAppointmentDate = '2024-04-30', @NewAppointmentTime = '10:00';
EXEC RebookAppointment @AppointmentID = 8, @NewAppointmentDate = '2024-04-30', @NewAppointmentTime = '12:00';
EXEC RebookAppointment @AppointmentID = 27, @NewAppointmentDate = '2024-04-30', @NewAppointmentTime = '12:00';

SELECT * FROM Appointments




GO
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--A view to check all pending appointments when a the reception view t
CREATE VIEW PendingAppointmentsView
AS
SELECT AppointmentID, PatientID, DoctorID, AppointmentDate, AppointmentTime, DepartmentID, Status
FROM Appointments
WHERE AppointmentDate = CONVERT(DATE, GETDATE()) AND Status = 'Pending'

EXEC BookAppointment @PatientID = 2, @DoctorID = 2, @DepartmentID = 2, @AppointmentDate = '2024-04-22', @AppointmentTime = '11:00:00';
EXEC BookAppointment @PatientID = 5, @DoctorID = 3, @DepartmentID = 3, @AppointmentDate = '2024-04-22', @AppointmentTime = '13:00:00';

Select * from PendingAppointmentsView
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++







GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--PROCEDURE FOR THE DOCTOR TO UPDATE NEW MEDICAL RECORD FOR APPOINTMENT
-- Create temporary table for diagnosed medicine
CREATE TYPE MedicineListType AS TABLE (
    MedicineID INT,
    Quantity INT
);
GO
CREATE PROCEDURE UpdateMedicalRecord
    @AppointmentID INT,
    @DiagnosisName VARCHAR(100),
    @MedicineList MedicineListType READONLY
AS
BEGIN
    -- Declare variables to store diagnosis ID and prescription ID
    DECLARE @DiagnosisID INT

    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION
        -- Insert diagnosis information
        INSERT INTO Diagnosis (PatientID, DoctorID, DiagnosisDate, DiagnosisName)
        SELECT PatientID, DoctorID, GETDATE(), @DiagnosisName
        FROM Appointments
        WHERE AppointmentID = @AppointmentID

        -- Get the ID of the inserted diagnosis
        SET @DiagnosisID = SCOPE_IDENTITY()

        -- Insert prescription information for each medicine in the list
        INSERT INTO MedicinesPrescribed (DiagnosisID, PatientID, DoctorID, MedicineID, Quantity, PrescriptionDate)
        SELECT @DiagnosisID, (SELECT PatientID FROM Appointments WHERE AppointmentID = @AppointmentID), 
               (SELECT DoctorID FROM Appointments WHERE AppointmentID = @AppointmentID), 
               m.MedicineID, m.Quantity, GETDATE()
        FROM @MedicineList m

		-- Update the Medicines table to reduce quantity by prescribed quantity for each prescribed medicine
		UPDATE m
        SET m.Quantity = m.Quantity - p.Quantity
        FROM Medicines m
        JOIN @MedicineList p ON m.MedicineID = p.MedicineID


        -- Commit the transaction
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if an error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH
END



-- Inserting some medicines for testing of the UpdateMedicalRecord stored procedure
INSERT INTO Medicines (MedicineName, Description, Manufacturer, ExpiryDate, Price, Quantity, IsActive)
VALUES
    ('Paracetamol', 'Pain reliever and fever reducer', 'Manufacturer A', '2024-12-31', 5.99, 100, 1),
    ('Ibuprofen', 'Nonsteroidal anti-inflammatory drug', 'Manufacturer B', '2024-11-30', 7.99, 150, 1);

-- Example insertion
-- Define and populate the table variable with the list of medicines
DECLARE @MedicineList AS MedicineListType;

INSERT INTO @MedicineList (MedicineID, Quantity)
VALUES
    (1, 2), -- Paracetamol with Quantity  of 2
    (2, 1); -- Ibuprofen 2 with Quantity of 1

-- Execute the stored procedure
EXEC UpdateMedicalRecord @AppointmentID = 7, @DiagnosisName = 'Headache', @MedicineList = @MedicineList;
EXEC UpdateMedicalRecord @AppointmentID = 8, @DiagnosisName = 'Sore Throat', @MedicineList = @MedicineList;

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--PATIENT SIGNS OUT OF APPOINTMENT AND LEAVES A REVIEW
CREATE PROCEDURE CompleteAppointmentAndLeaveReview
    @AppointmentID INT,
    @Rating INT,
    @Feedback VARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Update Appointment to completed
        UPDATE Appointments
        SET Status = 'Completed', AppointmentCompletedTime = GETDATE()
        WHERE AppointmentID = @AppointmentID;

		INSERT INTO PastAppointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, AppointmentCompletedTime, DepartmentID, Status, Outcome, FollowUpInstructions)
        SELECT PatientID, DoctorID, AppointmentDate, AppointmentTime, GETDATE(), DepartmentID, Status, NULL, NULL
        FROM Appointments
        WHERE Status = 'Completed';

        -- Insert Review/Feedback
        INSERT INTO Reviews (PatientID, DoctorID, Rating, Feedback)
        SELECT PA.PatientID, PA.DoctorID, @Rating, @Feedback
        FROM Appointments PA
        WHERE PA.AppointmentID = @AppointmentID;

        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- If an error occurs, roll back the transaction
        ROLLBACK TRANSACTION;
        
        -- Raise an error or handle it as needed
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END
EXEC CompleteAppointmentAndLeaveReview @AppointmentID = 7, @Rating = 5, @Feedback = 'Something to say'

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


EXEC CompleteAppointmentAndLeaveReview @AppointmentID = 23, @Rating = 5, @Feedback = 'Something to say'
EXEC CompleteAppointmentAndLeaveReview @AppointmentID = 24, @Rating = 5, @Feedback = 'Something to say'
EXEC CompleteAppointmentAndLeaveReview @AppointmentID = 25, @Rating = 5, @Feedback = 'Something to say'



GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- USER DEFINED FUNCTION TO GET A PATIENTS MEDICAL RECORDS USING THE PATIENT ID
CREATE FUNCTION GetPatientMedicalRecord (@PatientID INT)
RETURNS TABLE
AS
RETURN
( 
SELECT PB.PatientID,
           PB.FirstName,
           PB.MiddleName,
           PB.LastName,
           PB.DateOfBirth,
		   DG.DiagnosisName,
		   DG.DiagnosisDate,
		   M.MedicineName,
		   MP.Quantity AS MedicineQuantity,
           M.Description AS MedicineDescription,
           M.Manufacturer AS MedicineManufacturer,
           M.ExpiryDate AS MedicineExpiryDate,
           M.Price AS MedicinePrice,
           A.AllergyID,
           A.AllergyName,
           A.AllergyDate,
           D.Title AS DoctorTitle,
           D.FirstName AS DoctorFirstName,
           D.MiddleName AS DoctorMiddleName,
           D.LastName AS DoctorLastName,
           D.Specialty AS DoctorSpecialty,
           PA.AppointmentDate,
           PA.AppointmentTime,
           PA.Status AS AppointmentStatus,
           PA.AppointmentCompletedTime,
           PA.Outcome AS AppointmentOutcome,
           PA.FollowUpInstructions AS AppointmentFollowUpInstructions
    FROM PastAppointments PA
    JOIN PatientsBioData PB ON PA.PatientID = PB.PatientID
    LEFT JOIN Doctors D ON PA.DoctorID = D.DoctorID
    LEFT JOIN Departments DPT ON D.DepartmentID = DPT.DepartmentID
    LEFT JOIN Diagnosis DG ON PB.PatientID = DG.PatientID
    LEFT JOIN MedicinesPrescribed MP ON MP.PatientID = PB.PatientID
    LEFT JOIN Medicines M ON MP.MedicineID = M.MedicineID
    LEFT JOIN Allergies A ON PB.PatientID = A.PatientID
    WHERE PA.PatientID = @PatientID
);

SELECT * FROM GetPatientMedicalRecord(1)
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Stored procedure to deregister a patient
CREATE PROCEDURE DeregisterPatient
    @PatientID INT
AS
BEGIN
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION
        
        -- Update the status of the patient in the PatientsPortal table to 'Inactive'
        UPDATE PatientPortal
        SET Status = 'InActive'
        WHERE PatientID = @PatientID;

        -- Commit the transaction
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if an error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH
END
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Trigger to update the date a patient left when they are deregistered
CREATE TRIGGER UpdateDateLeftOnInactive
ON PatientPortal
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Status)
    BEGIN
        UPDATE PatientPortal
        SET DateLeft = GETDATE()
        FROM inserted
        WHERE PatientPortal.PatientID = inserted.PatientID
            AND PatientPortal.Status = 'Inactive'
            AND inserted.Status = 'Inactive'
            AND inserted.DateLeft IS NULL;
    END
END;
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
EXEC DeregisterPatient @PatientID = 7
EXEC DeregisterPatient @PatientID = 18
Select * from PatientPortal



GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Inserting 9 records into the  Departments table
INSERT INTO Departments (DepartmentName)
VALUES 
    ('Orthopedics'),
    ('Pediatrics'),
	('Gastroenterology'),
    ('Oncology'),
    ('Gynecology'),
    ('Dermatology'),
    ('Urology'),
    ('ENT (Ear, Nose, Throat)'),
    ('Psychiatry');

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Inserting 15 records into the Doctors table
INSERT INTO Doctors (Title, FirstName, MiddleName, LastName, DepartmentID, Specialty)
VALUES 
    ('Dr.', 'Michael', 'B.', 'Williams', 3, 'Orthopedist'),
    ('Dr.', 'Jessica', '', 'Davis', 4, 'Pediatrician'),
    ('Dr.', 'Robert', 'C.', 'Wilson', 5, 'Gastroenterologist'),
    ('Dr.', 'Sarah', '', 'Martinez', 5, 'Gastroenterologist'),
    ('Dr.', 'David', 'E.', 'Taylor', 5, 'Gastroenterologist'),
    ('Dr.', 'Jennifer', 'F.', 'Anderson', 5, 'Gastroenterologist'),
    ('Dr.', 'Daniel', '', 'Brown', 6, 'Oncologist'),
    ('Dr.', 'Lisa', '', 'Garcia', 7, 'Gynecologist'),
    ('Dr.', 'Kevin', 'G.', 'Lee', 8, 'Dermatologist'),
    ('Dr.', 'Michelle', '', 'Clark', 9, 'Urologist'),
    ('Dr.', 'Brian', 'H.', 'Moore', 10, 'ENT Specialist'),
    ('Dr.', 'Amanda', '', 'Perez', 11, 'Psychiatrist'),
    ('Dr.', 'James', 'I.', 'King', 11, 'Psychiatrist');

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Insert 20 medicine entries
INSERT INTO Medicines (MedicineName, Description, Manufacturer, ExpiryDate, Price, Quantity, IsActive)
VALUES
    ('Amoxicillin', 'Antibiotic', 'Manufacturer C', '2025-03-31', 9.99, 80, 1),
    ('Aspirin', 'Pain reliever and blood thinner', 'Manufacturer D', '2024-10-31', 4.99, 120, 1),
    ('Lisinopril', 'ACE inhibitor for high blood pressure', 'Manufacturer E', '2025-05-31', 11.99, 90, 1),
    ('Atorvastatin', 'Statins for lowering cholesterol', 'Manufacturer F', '2024-09-30', 15.99, 70, 1),
    ('Metformin', 'Antidiabetic medication', 'Manufacturer G', '2025-02-28', 8.99, 110, 1),
    ('Omeprazole', 'Proton-pump inhibitor for acid reflux', 'Manufacturer H', '2024-08-31', 12.99, 100, 1),
    ('Losartan', 'ARB for high blood pressure', 'Manufacturer I', '2024-07-31', 10.99, 130, 1),
    ('Simvastatin', 'Statins for lowering cholesterol', 'Manufacturer J', '2024-06-30', 13.99, 100, 1),
    ('Ciprofloxacin', 'Antibiotic', 'Manufacturer K', '2025-01-31', 14.99, 90, 1),
    ('Hydrochlorothiazide', 'Diuretic for high blood pressure', 'Manufacturer L', '2024-05-31', 9.99, 120, 1),
    ('Metoprolol', 'Beta blocker for high blood pressure', 'Manufacturer M', '2024-04-30', 10.99, 100, 1),
    ('Amlodipine', 'Calcium channel blocker for high blood pressure', 'Manufacturer N', '2025-06-30', 12.99, 80, 1),
    ('Metronidazole', 'Antibiotic and antiprotozoal medication', 'Manufacturer O', '2024-03-31', 8.99, 110, 1),
    ('Albuterol', 'Bronchodilator for asthma', 'Manufacturer P', '2024-02-29', 6.99, 150, 1),
    ('Fluoxetine', 'SSRI antidepressant', 'Manufacturer Q', '2025-07-31', 14.99, 70, 1),
    ('Warfarin', 'Anticoagulant', 'Manufacturer R', '2024-01-31', 7.99, 100, 1),
    ('Doxycycline', 'Antibiotic', 'Manufacturer S', '2023-12-31', 11.99, 90, 1),
    ('Prednisone', 'Corticosteroid', 'Manufacturer T', '2023-11-30', 9.99, 120, 1);


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Inserting 8 records into the  PatientBioData and PatientPortal tables
EXEC RegisterPatient @FirstName = 'Alice', @MiddleName = 'Maria', @LastName = 'Brown', @Address = '789 Oak St', @DateOfBirth = '1975-03-28', @InsuranceNumber = '456789123', @EmailAddress = 'alice@example.com', @PhoneNumber = '456-789-1234', @Username = 'alicebrown1', @PlainPassword = 'MySecretPassword3';
EXEC RegisterPatient @FirstName = 'Robert', @MiddleName = 'William', @LastName = 'Johnson', @Address = '101 Pine St', @DateOfBirth = '1970-07-12', @InsuranceNumber = '369258147', @EmailAddress = 'robert@example.com', @PhoneNumber = '789-123-4567', @Username = 'robertjohnson1', @PlainPassword = 'MySecretPassword4';
EXEC RegisterPatient @FirstName = 'Elizabeth', @MiddleName = 'Grace', @LastName = 'Wilson', @Address = '246 Maple St', @DateOfBirth = '1965-11-03', @InsuranceNumber = '852963741', @EmailAddress = 'elizabeth@example.com', @PhoneNumber = '147-258-3698', @Username = 'elizabethwilson1', @PlainPassword = 'MySecretPassword5';
EXEC RegisterPatient @FirstName = 'David', @MiddleName = 'Robert', @LastName = 'Brown', @Address = '246 Maple St', @DateOfBirth = '1985-05-15', @InsuranceNumber = '456789124', @EmailAddress = 'david@example.com', @PhoneNumber = '123-456-7890', @Username = 'davidbrown1', @PlainPassword = 'MySecretPassword6';
EXEC RegisterPatient @FirstName = 'Mary', @MiddleName = 'Ann', @LastName = 'Johnson', @Address = '789 Oak St', @DateOfBirth = '1990-09-20', @InsuranceNumber = '987654323', @EmailAddress = 'mary@example.com', @PhoneNumber = '987-654-3210', @Username = 'maryjohnson1', @PlainPassword = 'MySecretPassword7';
EXEC RegisterPatient @FirstName = 'Dave', @MiddleName = 'Rowland', @LastName = 'Johnson', @Address = '789 Oak St', @DateOfBirth = '2015-09-20', @InsuranceNumber = '987654325', @EmailAddress = 'mary@example.com', @PhoneNumber = '987-654-3210', @Username = 'davwrowland1', @PlainPassword = 'MySecretPassword7';
EXEC RegisterPatient @FirstName = 'Sarah', @MiddleName = 'banks', @LastName = 'Johnson', @Address = '789 Oak St', @DateOfBirth = '1950-09-20', @InsuranceNumber = '987654326', @EmailAddress = 'mary@example.com', @PhoneNumber = '987-654-3210', @Username = 'sarahrowland1', @PlainPassword = 'MySecretPassword7';
EXEC RegisterPatient @FirstName = 'Sam', @MiddleName = 'John', @LastName = 'Johnson', @Address = '789 Oak St', @DateOfBirth = '1955-09-20', @InsuranceNumber = '987654327', @EmailAddress = 'mary@example.com', @PhoneNumber = '987-654-3210', @Username = 'samland1', @PlainPassword = 'MySecretPassword7';

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Inserting 9 records into the  Appointment table
EXEC BookAppointment @PatientID = 3, @DoctorID = 3, @DepartmentID = 3, @AppointmentDate = '2024-10-10', @AppointmentTime = '12:00:00';
EXEC BookAppointment @PatientID = 4, @DoctorID = 4, @DepartmentID = 4, @AppointmentDate = '2024-10-10', @AppointmentTime = '13:00:00';
EXEC BookAppointment @PatientID = 5, @DoctorID = 5, @DepartmentID = 5, @AppointmentDate = '2024-08-10', @AppointmentTime = '14:00:00';
EXEC BookAppointment @PatientID = 6, @DoctorID = 6, @DepartmentID = 6, @AppointmentDate = '2024-08-10', @AppointmentTime = '15:00:00';
EXEC BookAppointment @PatientID = 7, @DoctorID = 7, @DepartmentID = 7, @AppointmentDate = '2024-07-10', @AppointmentTime = '16:00:00';
EXEC BookAppointment @PatientID = 12, @DoctorID = 8, @DepartmentID = 8, @AppointmentDate = '2024-08-10', @AppointmentTime = '17:00:00';
EXEC BookAppointment @PatientID = 15, @DoctorID = 9, @DepartmentID = 9, @AppointmentDate = '2024-09-10', @AppointmentTime = '18:00:00';
EXEC BookAppointment @PatientID = 17, @DoctorID = 10, @DepartmentID = 10, @AppointmentDate = '2024-09-10', @AppointmentTime = '19:00:00';
DECLARE @today DATE;
SET @today = GETDATE();
EXEC BookAppointment @PatientID = 2, @DoctorID = 2, @DepartmentID = 10, @AppointmentDate =  @today, @AppointmentTime = '19:00:00';


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Inserting 7 records into the  PatientBioData and PatientPortal tables
DECLARE @MedicineList AS MedicineListType;
INSERT INTO @MedicineList (MedicineID, Quantity)
VALUES
    (1, 2), (3, 2) ; 
EXEC UpdateMedicalRecord @AppointmentID = 8, @DiagnosisName = 'Viral Pharyngitis', @MedicineList = @MedicineList;
EXEC UpdateMedicalRecord @AppointmentID = 21, @DiagnosisName = 'Breast Cancer', @MedicineList = @MedicineList;
EXEC UpdateMedicalRecord @AppointmentID = 22, @DiagnosisName = 'Strep Throat', @MedicineList = @MedicineList;
EXEC UpdateMedicalRecord @AppointmentID = 23, @DiagnosisName = 'Skin Cancer', @MedicineList = @MedicineList;
EXEC UpdateMedicalRecord @AppointmentID = 24, @DiagnosisName = 'Acute Bronchitis', @MedicineList = @MedicineList;
EXEC UpdateMedicalRecord @AppointmentID = 25, @DiagnosisName = 'Gastroesophageal Reflux Disease (GERD)', @MedicineList = @MedicineList;
EXEC UpdateMedicalRecord @AppointmentID = 26, @DiagnosisName = 'Brain Cancer', @MedicineList = @MedicineList;



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Inserting 8 records into the  PatientBioData and PatientPortal tables
EXEC CompleteAppointmentAndLeaveReview @AppointmentID = 21, @Rating = 5, @Feedback = 'Something to say'
EXEC CompleteAppointmentAndLeaveReview @AppointmentID = 22, @Rating = 5, @Feedback = 'Something to say'
EXEC CompleteAppointmentAndLeaveReview @AppointmentID = 26, @Rating = 5, @Feedback = 'Something to say'


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Inserting 8 records into the  PatientBioData and PatientPortal tables
INSERT INTO Allergies (PatientID, AllergyName, AllergyDate) VALUES
(1, 'Peanuts', '2024-04-17'),
(2, 'Shellfish', '2024-04-16'),
(2, 'Chocolate', '2024-04-16'),
(3, 'Pollen', '2024-04-15'),
(4, 'Dust', '2024-04-14'),
(5, 'Milk', '2024-04-13'),
(6, 'Eggs', '2024-04-12'),
(2, 'Penicillin', '2024-04-18'),
(7, 'Penicillin', '2024-04-11');
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++







--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--part 2, Q2: Add the constraint to check that the appointment date is not in the past. 
-- This Constraint is already appllied to the table 
-- ALTER TABLE Appointments
-- ADD CONSTRAINT CHK_AppointmentDate CHECK (AppointmentDate >= CONVERT(DATE, GETDATE()));
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--part 2, Q3:  List all the patients with older than 40 and have Cancer in diagnosis.
SELECT pb.*, pb.DateOfBirth, d.DiagnosisID, d.DiagnosisDate, d.DiagnosisName
FROM PatientsBioData pb
INNER JOIN Diagnosis d ON pb.PatientID = d.PatientID
WHERE pb.DateOfBirth <= DATEADD(YEAR, -40, GETDATE()) -- Older than 40
AND d.DiagnosisName Like '%Cancer%';
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- part 2, Q4a: Search the database of the hospital for matching character strings by name of medicine. Results should be sorted with most recent medicine prescribed date first.
CREATE PROCEDURE SearchMedicineByName
    @MedicineName VARCHAR(100)
AS
BEGIN
    SELECT MP.PatientID, MP.PrescriptionDate, MP.Quantity Dosage, M.MedicineName, M.Description, M.Manufacturer, M.ExpiryDate, M.Price, M.Quantity InventryQuantity
    FROM MedicinesPrescribed MP
    FULL JOIN Medicines M  ON MP.MedicineID = M.MedicineID
    WHERE M.MedicineName LIKE '%' + @MedicineName + '%'
    ORDER BY MP.PrescriptionDate DESC;
END;

EXEC SearchMedicineByName @MedicineName = 'Amoxicillin'
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- part 2, Q4b: get Return a full list of diagnosis and allergies for a specific patient who has an appointment today
CREATE FUNCTION GetDiagnosisAndAllergiesForPatient(@PatientID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT PatientID, DiagnosisID [Record ID], 'Diagnosis' [Record Type], DiagnosisName [Diagnosis Or Allergy Name], DiagnosisDate [Date of Record]
    FROM Diagnosis
    WHERE PatientID IN (SELECT PatientID FROM Appointments WHERE CONVERT(DATE, AppointmentDate) = CONVERT(DATE, GETDATE())) AND PatientID = @PatientID
    UNION ALL
    SELECT PatientID, AllergyID [Record ID], 'Allergy' [Record Type],  AllergyName [Diagnosis Or Allergy Name], AllergyDate [Date of Record]
    FROM Allergies
    WHERE PatientID IN (SELECT PatientID FROM Appointments WHERE CONVERT(DATE, AppointmentDate) = CONVERT(DATE, GETDATE())) AND PatientID = @PatientID
);

SELECT * FROM GetDiagnosisAndAllergiesForPatient(2) 
ORDER BY [Date of Record] DESC
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- part 2, Q4c: Update the details for an existing doctor
CREATE PROCEDURE UpdateDoctorDetails
    @DoctorID INT,
	@FirstName VARCHAR(100),
	@MiddleName VARCHAR(100),
	@LastName VARCHAR(100),
    @NewDepartmentID INT,
	@NewSpecialty VARCHAR(100)
AS
BEGIN
    UPDATE Doctors
    SET FirstName = @FirstName, MiddleName = @MiddleName, LastName = @LastName, Specialty = @NewSpecialty, DepartmentID = @NewDepartmentID
    WHERE DoctorID = @DoctorID;
END;

EXEC UpdateDoctorDetails  @DoctorID = 5, @FirstName =John, @MiddleName = A , @LastName = S, @NewDepartmentID = 2, @NewSpecialty  = 'Pediatrician';
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- part 2, Q4D: Delete the appointment who status is already completed.
CREATE PROCEDURE DeleteCompletedAppointments
AS
BEGIN
    -- Delete completed appointments from Appointments table
    DELETE FROM Appointments
    WHERE Status = 'Completed';
END;


SELECT * FROM Appointments
EXEC DeleteAndMoveCompletedAppointments
SELECT * FROM Appointments
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++







GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- part 2, Q5: The hospitals wants to view the appointment date and time, showing all previous and current appointments for all doctors, and including details of the department (the doctor is associated with), doctor’s specialty and any associate review/feedback given for a doctor. You should create a view containing all the required information.
CREATE VIEW AllAppointmentsView AS
SELECT 'Future' AS AppointmentType, A.AppointmentID, A.AppointmentDate, A.AppointmentTime, A.AppointmentCompletedTime, A.Status,
       D.Title + ' ' +  D.FirstName + ' ' + D.MiddleName + ' ' +  D.LastName AS DoctorName, D.DepartmentID, D.Specialty,
       DD.DepartmentName AS Department,
       R.Rating, R.Feedback
FROM Appointments A
JOIN Doctors D ON A.DoctorID = D.DoctorID
JOIN Departments DD ON D.DepartmentID = DD.DepartmentID
LEFT JOIN Reviews R ON A.PatientID = R.PatientID AND A.DoctorID = R.DoctorID AND A.DoctorID = R.DoctorID

UNION ALL

SELECT 'Past' AS AppointmentType, A.PastAppointmentID AS AppointmentID , A.AppointmentDate, A.AppointmentTime, A.AppointmentCompletedTime, A.Status,
       D.Title + ' ' +  D.FirstName + ' ' + D.MiddleName + ' ' +  D.LastName AS DoctorName, D.DepartmentID, D.Specialty,
       DD.DepartmentName AS Department,
       R.Rating, R.Feedback
FROM PastAppointments A
JOIN Doctors D ON A.DoctorID = D.DoctorID
JOIN Departments DD ON D.DepartmentID = DD.DepartmentID
LEFT JOIN Reviews R ON A.PatientID = R.PatientID AND A.DoctorID = R.DoctorID AND A.DoctorID = R.DoctorID;

SELECT * FROM AllAppointmentsView
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






GO
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- part 2, Q6: Create a trigger so that the current state of an appointment can be changed toavailable when it is cancelled
CREATE TRIGGER UpdateAppointmentStateOnCancellation
ON Appointments
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Status) -- Check if the Status column was updated
    BEGIN
        DECLARE @CancelledStatus VARCHAR(20) = 'Cancelled';
        DECLARE @AvailableStatus VARCHAR(20) = 'Available';
        
        UPDATE Appointments
        SET Status = @AvailableStatus
        FROM inserted i
        WHERE Appointments.AppointmentID = i.AppointmentID
        AND i.Status = @CancelledStatus;
    END
END;


UPDATE Appointments
SET Status = 'Cancelled'
WHERE AppointmentID = 8;

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Q 7 Write a select query which allows the hospital to identify the number of completed appointments with the specialty of doctors as ‘Gastroenterologists
SELECT COUNT(*) AS NumCompletedAppointments
FROM PastAppointments A
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE D.Specialty = 'Gastroenterologist'
AND A.Status = 'Completed';
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

















SELECT 
    t.NAME AS TableName,
    p.rows AS RowCounts
FROM 
    GPHospital.sys.tables t
INNER JOIN      
    GPHospital.sys.partitions p ON t.object_id = p.OBJECT_ID
WHERE 
    t.NAME NOT LIKE 'dt%'
    AND t.is_ms_shipped = 0
    AND p.index_id IN (0,1)
ORDER BY 
    RowCounts DESC;