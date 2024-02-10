CREATE OR ALTER FUNCTION CheckDoctorsAge (@BirthDate date)
RETURNS BIT AS
	BEGIN
		DECLARE @isValid BIT

		IF DATEDIFF(YEAR, @BirthDate, GETDATE()) >= 35
			SET @isValid = 1
		ELSE
			SET @isValid = 0

		RETURN @isValid
	END
GO
CREATE OR ALTER FUNCTION CheckActiveMedicalLicense (@medicalLicense bit)
RETURNS BIT AS
	BEGIN
		DECLARE @isValid BIT

		IF @medicalLicense = 1
			SET @isValid = 1
		ELSE
			SET @isValid = 0

		RETURN @isValid
	END
GO
CREATE OR ALTER FUNCTION CheckEmail (@Email NVARCHAR (100)) RETURNS BIT AS
	BEGIN
		DECLARE @IsValid BIT = 0;

		IF @Email LIKE '%@%.%'
			SET @IsValid = 1;

		RETURN @IsValid;
	END
GO
CREATE OR ALTER PROCEDURE InsertIntoDoctors
    @doctorID INT,
    @firstName NVARCHAR(50),
    @lastName NVARCHAR(50),
    @birthDate DATE,
	@contact NVARCHAR(50),
    @activeMedicalLicense BIT,
	@email NVARCHAR(50)
AS
BEGIN
    DECLARE @IsOver35 BIT
    DECLARE @IsMedicalLicenseActive BIT
	DECLARE @IsValidEmail BIT

    SET @IsOver35 = dbo.CheckDoctorsAge(@BirthDate)
    SET @IsMedicalLicenseActive = dbo.CheckActiveMedicalLicense(@activeMedicalLicense)
	SET @IsValidEmail = dbo.CheckEmail(@email)
    IF @IsOver35 = 1 AND @IsMedicalLicenseActive = 1 AND @IsValidEmail = 1
    BEGIN
        INSERT INTO Doctors(doctorID, firstName,lastName,birthDate,contact,activeMedicalLicense,email)
        VALUES (@doctorID,@firstName,@lastName ,@birthDate,@contact ,@activeMedicalLicense,@email)
        PRINT 'Data inserted successfully.'
    END
    ELSE
    BEGIN
        PRINT 'Validation failed. Data not inserted.'
    END
END
GO
SELECT COUNT(*) FROM Doctors
EXEC InsertIntoDoctors '30','Sarah', 'Doe', '1980-01-01','123-456-7890' ,'1','user@gmail.com';
EXEC InsertIntoDoctors '31','Sarah', 'Doe', '1980-01-01','123-456-7890' ,'0','user@gmail.com';
EXEC InsertIntoDoctors '32','Sarah', 'Doe', '2003-01-01','123-456-7890' ,'1','user@gmail.com';
EXEC InsertIntoDoctors '33','Sarah', 'Doe', '1979-01-01','123-456-7890' ,'1','usergmail.com';
EXEC InsertIntoDoctors '33','Sarah', 'Doe', '1979-01-01','123-456-7890' ,'1','user@gmailcom';


CREATE OR ALTER FUNCTION GetAvailableDoctorsForVacation(@StartDate DATE, @EndDate DATE)
RETURNS TABLE
AS
RETURN
(
    SELECT E.enrolledDocID AS EnrolledDocID
	FROM EnrolledDoc E
	WHERE E.doctorID NOT IN (SELECT E1.doctorID
							FROM Appointments A
							INNER JOIN EnrolledDoc E1 ON E1.enrolledDocID = A.enrolledDocID
							WHERE A.date BETWEEN @StartDate AND @EndDate)
);
GO

SELECT * FROM GetAvailableDoctorsForVacation('2024-01-02', '2024-01-20');

CREATE OR ALTER VIEW V_AvailableDoctorsForVacation AS
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

SELECT DISTINCT
    V.DoctorID,
    V.DoctorFirstName,
    V.DoctorLastName
FROM 
    V_AvailableDoctorsForVacation V
JOIN 
    GetAvailableDoctorsForVacation('2024-01-02', '2024-01-20') T ON V.EnrolledDocID = T.EnrolledDocID;



