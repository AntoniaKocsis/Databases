CREATE TABLE Ta(
		idA int NOT NULL PRIMARY KEY,
		a2 int UNIQUE,
		a3 int);

CREATE TABLE Tb(
		idB int NOT NULL PRIMARY KEY,
		b2 int);

CREATE TABLE Tc(
		idC int IDENTITY(1,1) NOT NULL PRIMARY KEY,
		idA int NOT NULL FOREIGN KEY REFERENCES Ta(idA),
		idB int NOT NULL FOREIGN KEY REFERENCES Tb(idB),
		c2 int);


DROP TABLE Tc, Ta, Tb 
GO

CREATE OR ALTER PROCEDURE Populate
AS
BEGIN;
	SET NOCOUNT ON;
	DECLARE @cnt int,
			@a3 int,
			@idA int,
			@idB int;
	SET @cnt = 0;
	SET @a3 = 10000;
	SET @idA = 1;
	SET @idB = 1;

	WHILE (@cnt < 10000)
	BEGIN;
		INSERT INTO Ta
		VALUES(@idA, @cnt, @a3);
		IF (@cnt < 3000)
			INSERT INTO Tb
			VALUES(@idB, @cnt);	
		SET @cnt = @cnt + 1;
		SET @a3 = @a3 - 1;
		SET @idA = @idA + 1;
		SET @idB = @idB + 1;
	END;

	SET @idA = @idA - 1;
	SET @cnt = 0;

	WHILE (@idA > 0)
	BEGIN;
		SET @idB = 1;

		WHILE(@idB <= 3)
		BEGIN;
			INSERT INTO Tc
			VALUES(@idA, @idB, @cnt);
			SET @idB = @idB + 1;
		END;
		SET @cnt = @cnt + 1;
		SET @idA = @idA - 1;
	END;

END;
GO

SELECT * FROM Ta
SELECT * FROM Tb
SELECT * FROM Tc

EXEC Populate