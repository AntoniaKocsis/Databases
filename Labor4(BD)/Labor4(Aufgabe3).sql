CREATE TABLE PatientsLogs (
		datum DATETIME NOT NULL,
		typ varchar(20) NOT NULL,
		tableName varchar(20) NOT NULL,
		num int NOT NULL);
GO

CREATE OR ALTER TRIGGER PatientsTrigger ON Patients
AFTER INSERT, DELETE, UPDATE
AS
BEGIN;
	SET NOCOUNT ON;

	DECLARE @typ varchar(20),
			@num int;

	IF NOT EXISTS (SELECT * FROM inserted)
	BEGIN;
		SET @typ = 'D';
		SET	@num = (SELECT COUNT(*) FROM deleted);
	END;
	ELSE
	BEGIN;
		IF EXISTS (SELECT * FROM deleted)
			SET @typ = 'U'
		ELSE
			SET @typ = 'I'

		SET	@num = (SELECT COUNT(*) FROM inserted);
	END;
	PRINT(@typ)
	INSERT INTO PatientsLogs
	VALUES (GETDATE(), @typ, 'Patients', @num);
END
GO

SELECT * from Patients;
SELECT * FROM PatientsLogs;

INSERT INTO Patients (patientID, firstName, lastName, dateOfBirth)
VALUES
    (101, 'John', 'Doe', '1990-01-15'),
    (201, 'Jane', 'Smith', '1985-05-22'),
    (301, 'Michael', 'Johnson', '1978-11-10');
INSERT INTO Patients (patientID, firstName, lastName, dateOfBirth)
VALUES
    (102, 'John', 'Doe', '1990-01-15'),
    (202, 'Jane', 'Smith', '1985-05-22'),
    (302, 'Michael', 'Johnson', '1978-11-10');

DELETE FROM Patients
WHERE patientID = 102 OR patientID = 202


UPDATE Patients
SET firstName = 'Antonia'
WHERE  patientID = 201
