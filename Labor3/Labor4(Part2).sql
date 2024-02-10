CREATE TABLE Users (
		id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
		username varchar(20),
		pwd varchar(20));

GO

CREATE TABLE UsersLogs (
		datum DATETIME NOT NULL,
		typ varchar(20) NOT NULL,
		tableName varchar(20) NOT NULL,
		num int NOT NULL);
GO


CREATE TABLE usersNotes (
		id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
		username varchar(20),
		note varchar(MAX));
GO

DROP TABLE users, UsersLogs, usersNotes
GO

CREATE OR ALTER TRIGGER UsersTrigger ON Users
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
	INSERT INTO UsersLogs
	VALUES (GETDATE(), @typ, 'Users', @num);
END
GO

CREATE OR ALTER PROCEDURE InsertNotes(@username varchar(20), @notes varchar(MAX))
AS
BEGIN;

	DECLARE @noteTable TABLE (note varchar(MAX));
	DECLARE	@noteValue VARCHAR(MAX);

	INSERT INTO @noteTable (note)
	SELECT VALUE FROM string_split(@notes, ',');

	DECLARE NoteCursor CURSOR FOR
	SELECT note FROM @noteTable

	OPEN NoteCursor
	FETCH NEXT FROM NoteCursor INTO @noteValue;

	WHILE @@FETCH_STATUS = 0
	BEGIN;
		INSERT INTO usersNotes(username, note)
		VALUES(@username, @noteValue);

		FETCH NEXT FROM NoteCursor INTO @noteValue;
	END;

	CLOSE NoteCursor;
	DEALLOCATE NoteCursor;

END;
GO


SELECT * from users;
SELECT * FROM usersLogs;

INSERT INTO users 
VALUES('username', '1234'),('username1', '1234'),('username2', '1234');
INSERT INTO users 
VALUES('username3', '1234'),('username4', '1234'),('username5', '1234');

DELETE FROM users
WHERE id = 3

UPDATE users
SET username = 'asda'
WHERE id = 4


EXEC InsertNotes 'username1', 'Hey!,How are you?'
EXEC InsertNotes 'username2', 'Hey!,Fine,Thanks?'

SELECT * FROM usersNotes;
