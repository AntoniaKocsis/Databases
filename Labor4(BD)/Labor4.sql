CREATE OR ALTER FUNCTION CheckDoctorAge(@BirthDate date)
RETURNS bit AS
BEGIN
    DECLARE @isValid bit
    IF DATEDIFF(YEAR, @BirthDate, GETDATE()) >= 35
			SET @isValid = 1
		ELSE
			SET @isValid = 0

		RETURN @isValid
END
GO
CREATE OR ALTER FUNCTION CheckMedicalLicense(@ActiveMedicalLicense bit)
RETURNS bit AS
BEGIN
    DECLARE @isValid bit
  
    IF @ActiveMedicalLicense = 1
        SET @isValid = 1; 
    ELSE
        SET @isValid = 0;

    RETURN @isValid
END
GO
CREATE OR ALTER PROCEDURE InsertIntoDoctor
	@doctorID INT,
	@firstName NVARCHAR(50),
	@lastName NVARCHAR(50),
	@contact NVARCHAR(50),
	@birthDate date,
	@activeMedicalLicense bit

AS
BEGIN
    DECLARE @IsOver35 BIT
    DECLARE @IsActiveLicense BIT

    SET @IsOver35 = dbo.CheckDoctorAge(@birthDate)
    SET @IsActiveLicense = dbo.CheckMedicalLicense(@activeMedicalLicense)
    IF @IsOver35 = 1 AND @IsActiveLicense = 1
    BEGIN
        INSERT INTO Doctors(doctorID, firstName, lastName, contact, birthDate,activeMedicalLicense)
        VALUES (@doctorID,@firstName,@lastName,@contact,@birthDate,@activeMedicalLicense)
        PRINT 'Data inserted successfully.'
    END
    ELSE
    BEGIN
        PRINT 'Validation failed. Data not inserted.'
    END
END
GO


EXEC InsertIntoDoctor 1, 'John', 'Doe', '123-456-7890', '1980-01-01', 1;
EXEC InsertIntoDoctor 2, 'Jane', 'Doe', '123-456-7890', '1980-01-01', 1;
EXEC InsertIntoDoctor 3, 'Jane', 'Bass', '123-456-7890', '1980-01-01', 0;
SELECT * FROM Doctors;

CREATE OR ALTER FUNCTION GetAppointmentsByEnrolledDoctor(@EDocID int)
RETURNS TABLE
AS
RETURN
(
    SELECT A.appointmentID AS AppointmentID,A.date AS AppointmentDate,P.patientID,P.firstName AS PatientFirstName, P.lastName AS PatientLastName,A.enrolledDocID AS EnrolledDocID
    FROM Appointments A
    JOIN Patients P ON A.patientID = P.patientID
	WHERE A.enrolledDocID = @EDocID
);
GO
SELECT * FROM GetAppointmentsByEnrolledDoctor(1);
SELECT * FROM GetAppointmentsByEnrolledDoctor(2);

CREATE OR ALTER VIEW V_DoctorsAndPatients AS
SELECT 
    D.doctorID AS DoctorID,
    D.firstName AS DoctorFirstName,
    D.lastName AS DoctorLastName,
    E.enrolledDocID AS EnrolledDocID
FROM 
    Doctors D
JOIN 
    EnrolledDoc E ON D.doctorID = E.doctorID
GO

-- Query using View and Table-valued Function
SELECT 
    V.DoctorID,
    V.DoctorFirstName,
    V.DoctorLastName,
    T.PatientID,
    T.PatientFirstName,
    T.PatientLastName,
    T.AppointmentDate
FROM 
    V_DoctorsAndPatients V
JOIN 
    GetAppointmentsByEnrolledDoctor(2) T ON V.EnrolledDocID = T.EnrolledDocID;
