CREATE OR ALTER PROCEDURE CreateTable(
	@tableName VARCHAR(100),
	@tableInfo VARCHAR(MAX),
	@flag BIT = 1
)
AS
BEGIN
    DECLARE @sqlQuery AS VARCHAR(MAX)
    SET @sqlQuery = 'CREATE TABLE ' + @tableName + '(' + @tableInfo + ')'
    PRINT @sqlQuery
    EXEC (@sqlQuery)
	IF @flag = 1
		BEGIN
			INSERT INTO ProceduresTable(procedureName, tableName, tableInfo)
			VALUES ('CreateTable', @tableName, @tableInfo);

			IF EXISTS (SELECT * FROM CurrentVersionTable)
				UPDATE CurrentVersionTable
				SET versionID = (SELECT MAX(id) FROM ProceduresTable)
			ELSE		
				INSERT INTO CurrentVersionTable
				VALUES ((SELECT MAX(id) FROM ProceduresTable))
		END
END
GO

CREATE OR ALTER PROCEDURE RollbackCreateTable(
	@tableName VARCHAR(100)
)
AS
BEGIN
    IF OBJECT_ID(@tableName, 'U') IS NOT NULL
    BEGIN
        DECLARE @sqlQuery AS VARCHAR(MAX)
        SET @sqlQuery = 'DROP TABLE ' + @tableName
        PRINT @sqlQuery
        EXEC (@sqlQuery)
    END
END
GO

CREATE OR ALTER PROCEDURE AddForeignKeyConstraint(
    @tableName VARCHAR(100),
    @columnName VARCHAR(100),
    @referencedTable VARCHAR(100),
    @referencedColumn VARCHAR(100),
	@flag BIT = 1
)
AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @tableName + ' ADD CONSTRAINT FK_' + @tableName + '_' + @columnName +
               ' FOREIGN KEY (' + @columnName + ') REFERENCES ' + @referencedTable + '(' + @referencedColumn + ')'
    PRINT @sql;
    EXEC (@sql);
	IF @flag = 1
		BEGIN
		    INSERT INTO ProceduresTable(ProcedureName, tableName, columnName, referencedTable, referencedColumn)
			VALUES ('AddForeignKeyConstraint', @tableName, @columnName, @referencedTable, @referencedColumn);

			IF EXISTS (SELECT * FROM CurrentVersionTable)
				UPDATE CurrentVersionTable
				SET versionID = (SELECT MAX(id) FROM ProceduresTable)
			ELSE		
				INSERT INTO CurrentVersionTable
				VALUES ((SELECT MAX(id) FROM ProceduresTable))
		END;

END
GO

CREATE OR ALTER PROCEDURE RollbackAddForeignKeyConstraint(
    @tableName VARCHAR(100),
    @columnName VARCHAR(100)
)
AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @tableName + ' DROP CONSTRAINT FK_' + @tableName + '_' + @columnName
    PRINT @sql
    EXEC (@sql);
END
GO

CREATE OR ALTER PROCEDURE AddColumnToTable(
	@tableName VARCHAR(100),
	@columnName VARCHAR(100),
	@columnType VARCHAR(100),
	@flag BIT = 1
)
AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @tableName + ' ADD ' + @columnName + ' ' + @columnType
    PRINT @sql
    EXEC (@sql);
	IF @flag = 1
		BEGIN
			INSERT INTO ProceduresTable(ProcedureName, tableName, columnName, columnType)
			VALUES ('AddColumnToTable', @tableName, @columnName, @columnType);

			IF EXISTS (SELECT * FROM CurrentVersionTable)
				UPDATE CurrentVersionTable
				SET versionID = (SELECT MAX(id) FROM ProceduresTable)
			ELSE		
				INSERT INTO CurrentVersionTable
				VALUES ((SELECT MAX(id) FROM ProceduresTable))
		END;
END
GO

CREATE OR ALTER PROCEDURE RollbackAddColumnToTable(
	@tableName VARCHAR(100),
	@columnName VARCHAR(100)
)
AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @tableName + ' DROP COLUMN ' + @columnName
    PRINT @sql
    EXEC (@sql);
END
GO

CREATE OR ALTER PROCEDURE AddDefaultConstraint(
    @tableName VARCHAR(100),
    @columnName VARCHAR(100),
    @defaultConstraint VARCHAR(100),
	@flag BIT = 1
)
AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @tableName + ' ADD CONSTRAINT DF_' +
               @tableName + '_' + @columnName + ' DEFAULT ' + @defaultConstraint + ' FOR ' + @columnName
    PRINT @sql
    EXEC (@sql)
	IF @flag = 1
		BEGIN
			INSERT INTO ProceduresTable(ProcedureName, tableName, columnName, defaultConstraint)
			VALUES ('AddDefaultConstraint', @tableName, @columnName, @defaultConstraint);

			IF EXISTS (SELECT * FROM CurrentVersionTable)
				UPDATE CurrentVersionTable
				SET versionID = (SELECT MAX(id) FROM ProceduresTable)
			ELSE		
				INSERT INTO CurrentVersionTable
				VALUES ((SELECT MAX(id) FROM ProceduresTable))
		END;
END
GO

CREATE OR ALTER PROCEDURE RollbackAddDefaultConstraint(
	@tableName VARCHAR(100),
	@columnName VARCHAR(100)
)
AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @tableName + ' DROP CONSTRAINT DF_' + @tableName + '_' + @columnName
    PRINT @sql
    EXEC (@sql);
END
GO

CREATE OR ALTER PROCEDURE ChangeColumnType (
    @tableName VARCHAR(100),
    @columnName VARCHAR(100),
    @columnType VARCHAR(100),
	@flag BIT = 1
)
AS
BEGIN
	DECLARE @oldColumnType as varchar(100)
	SET @oldColumnType = (SELECT T.DATA_TYPE 
						  FROM INFORMATION_SCHEMA.COLUMNS T 
						  WHERE TABLE_NAME = @tableName  AND COLUMN_NAME = @columnName)
	DECLARE @length as varchar(100)
	SET @length = (SELECT T.CHARACTER_MAXIMUM_LENGTH 
				   FROM INFORMATION_SCHEMA.COLUMNS T 
				   WHERE TABLE_NAME = @tableName  AND COLUMN_NAME = @columnName)
	IF @length IS NOT NULL
		SET @oldColumnType = @oldColumnType + '(' + @length + ')'	
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @tableName + ' ALTER COLUMN ' + @columnName + ' ' + @columnType
	PRINT(@sql);
    EXEC (@sql);
	IF @flag = 1
		BEGIN
			INSERT INTO ProceduresTable(ProcedureName, tableName, columnName, columnType, oldColumnType)
			VALUES ('ChangeColumnType', @tableName, @columnName, @columnType, @oldColumnType);			
			IF EXISTS (SELECT * FROM CurrentVersionTable)
				UPDATE CurrentVersionTable
				SET versionID = (SELECT MAX(id) FROM ProceduresTable)
			ELSE		
				INSERT INTO CurrentVersionTable
				VALUES ((SELECT MAX(id) FROM ProceduresTable))
		END;
END
GO

CREATE OR ALTER PROCEDURE RollBackChangeColumnType(
    @tableName VARCHAR(100),
    @columnName VARCHAR(100),
    @originalDataType VARCHAR(100)
)
AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @tableName + ' ALTER COLUMN ' + @columnName + ' ' + @originalDataType
	PRINT(@sql)
    EXEC (@sql);
END
GO
CREATE OR ALTER PROCEDURE CreateTables
AS
BEGIN
	CREATE TABLE CurrentVersionTable(versionID INT PRIMARY KEY);
	INSERT INTO CurrentVersionTable (versionID) VALUES (0);
	CREATE TABLE ProceduresTable(
		id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		ProcedureName VARCHAR(50),
		tableName VARCHAR(100),
		tableInfo VARCHAR(MAX),
		columnName VARCHAR(100),
		columnType VARCHAR(100),
		defaultConstraint VARCHAR(100),
		oldColumnType VARCHAR(100),
		referencedTable VARCHAR(100),
		referencedColumn VARCHAR(100)
	);
	PRINT('Version Table and Procedures Table created....');
END
GO
CREATE OR ALTER PROCEDURE DropTables
AS
BEGIN
	DROP TABLE CurrentVersionTable;
	DROP TABLE ProceduresTable;
	PRINT('Version Table and Procedures Table dropped....');
END
GO
CREATE OR ALTER PROCEDURE GoToVersion(@version int)
AS

	BEGIN
	DECLARE @procedureName VARCHAR(100);
	DECLARE @tableName VARCHAR(100);
	DECLARE @tableInfo VARCHAR(MAX);
	DECLARE @columnName VARCHAR(100);
	DECLARE @columnType VARCHAR(100);
	DECLARE @defaultConstraint VARCHAR(100);
	DECLARE @oldColumnType VARCHAR(100);
	DECLARE @referencedTable VARCHAR(100);
	DECLARE @referencedColumn VARCHAR(100);
	DECLARE @currentVersion INT;
	SELECT @currentVersion = (SELECT TOP 1 versionID FROM CurrentVersionTable);

    IF @version >= 0 AND @version < @currentVersion
	BEGIN
			WHILE @currentVersion > @version
			BEGIN
				DECLARE @nameRollback AS varchar(MAX)
				SELECT @nameRollback = (SELECT CONCAT('Rollback',(SELECT procedureName FROM ProceduresTable WHERE id = @currentVersion)))
				SELECT @tableName = (SELECT tableName FROM ProceduresTable WHERE id = @currentVersion)
				SELECT @columnName = (SELECT columnName FROM ProceduresTable WHERE id = @currentVersion)
				SELECT @oldColumnType = (SELECT oldColumnType FROM ProceduresTable WHERE  id = @currentVersion)
				IF @nameRollback = 'RollbackCreateTable'
				BEGIN
					EXEC @nameRollback @tableName
				END
				ELSE IF @nameRollback = 'RollbackAddColumnToTable'
				BEGIN
					EXEC @nameRollback @tableName,@columnName
				END
				ELSE IF @nameRollback = 'RollBackChangeColumnType'
				BEGIN
					EXEC @nameRollback @tableName,@columnName,@oldColumnType
				END
				ELSE IF (@nameRollback = 'RollbackAddForeignKeyConstraint' OR @nameRollback = 'RollbackAddDefaultConstraint')
				BEGIN
				EXEC @nameRollback @tableName, @columnName
				END
				SET @currentVersion = @currentVersion - 1;
				UPDATE CurrentVersionTable
				SET versionID = versionID - 1
			END
	END
	ELSE IF @version > @currentVersion AND @version <= (SELECT MAX(id) FROM ProceduresTable)
	BEGIN
			WHILE @currentVersion < @version
			BEGIN
			SET @currentVersion = @currentVersion + 1;
			UPDATE CurrentVersionTable
			SET versionID = versionID + 1
            SELECT @procedureName = (SELECT procedureName FROM ProceduresTable WHERE id = @currentVersion)
			SELECT @tableName = (SELECT tableName FROM ProceduresTable WHERE id = @currentVersion)
			SELECT @tableInfo = (SELECT tableInfo FROM ProceduresTable WHERE id = @currentVersion)
			SELECT @columnName = (SELECT columnName FROM ProceduresTable WHERE id = @currentVersion)
			SELECT @columnType = (SELECT columnType FROM ProceduresTable WHERE id = @currentVersion)
			SELECT @referencedTable = (SELECT referencedTable FROM ProceduresTable WHERE id = @currentVersion)
			SELECT @referencedColumn = (SELECT referencedColumn FROM ProceduresTable WHERE id = @currentVersion)
			SELECT @defaultConstraint = (SELECT defaultConstraint FROM ProceduresTable WHERE id = @currentVersion)

			IF @procedureName = 'CreateTable'
				BEGIN
					EXEC @procedureName @tableName, @tableInfo, 0;
				END
			ELSE IF @procedureName = 'AddForeignKeyConstraint'
				BEGIN
					EXEC @procedureName @tableName, @columnName, @referencedTable, @referencedColumn, 0;
				END
			ELSE IF @procedureName = 'AddColumnToTable'
				BEGIN
					EXEC @procedureName @tableName, @columnName, @columnType, 0;
				END
			ELSE IF @procedureName = 'AddDefaultConstraint'
				BEGIN
					EXEC @procedureName @tableName, @columnName, @defaultConstraint, 0;
				END
			ELSE IF @procedureName = 'ChangeColumnType'
				BEGIN
					PRINT @columnType;
					EXEC @procedureName @tableName, @columnName, @columnType, 0;
				END
			
			END
	END
	END
GO

EXEC CreateTables;
EXEC CreateTable 'Hospitals',
    'hospitalID INT PRIMARY KEY NOT NULL,
    hospitalName NVARCHAR(50) NOT NULL,
    hospitalAddress NVARCHAR(50) NOT NULL,
    hospitalContact NVARCHAR(50) NOT NULL';

EXEC CreateTable 'Doctors',
    'doctorID INT PRIMARY KEY NOT NULL,
    doctorFirstName NVARCHAR(50) NOT NULL,
    doctorLastName NVARCHAR(50) NOT NULL,
    doctorContact NVARCHAR(50) NOT NULL';

EXEC CreateTable 'Departments',
    'departmentID INT PRIMARY KEY NOT NULL,
    departmentName NVARCHAR(50) NOT NULL,
    hospitalID INT NOT NULL';
EXEC AddForeignKeyConstraint 'Departments','hospitalID','Hospitals','hospitalID';
EXEC AddColumnToTable 'Doctors','address','NVARCHAR(50)';
EXEC AddDefaultConstraint 'Doctors','address','''Adresa''';
EXEC CreateTable 'Patients',
	'patientID INT PRIMARY KEY NOT NULL,
	patientFirstName NVARCHAR(50) NOT NULL,
    patientLastName NVARCHAR(50) NOT NULL,
	patientAge INT NOT NULL,
    patientContact NVARCHAR(50) NOT NULL';
EXEC ChangeColumnType 'Patients','patientAge','VARCHAR(5)';
SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
PRINT('GO TO VERSION 2');
EXEC GoToVersion 2;
PRINT('GO TO VERSION 5');
EXEC GoToVersion 5;
PRINT('GO TO VERSION 6');
EXEC GoToVersion 6;
PRINT('GO TO VERSION 0');
EXEC GoToVersion 0;
PRINT('GO TO VERSION 8');
EXEC GoToVersion 8;
PRINT('GO TO VERSION 0');
EXEC GoToVersion 0;
EXEC DropTables;