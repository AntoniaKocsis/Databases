SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
EXEC CreateTable 'Hospitals',
    'hospitalID INT PRIMARY KEY NOT NULL,
    hospitalName NVARCHAR(50) NOT NULL,
    hospitalAddress NVARCHAR(50) NOT NULL';
SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
EXEC AddColumnToTable 'Hospitals','hospitalContact','NVARCHAR(50)';
SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
EXEC AddColumnToTable 'Hospitals','rating','INT';
SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
EXEC ChangeColumnType 'Hospitals','hospitalContact','CHAR(100)';
SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
EXEC AddDefaultConstraint 'Hospitals','hospitalAddress','''Adresa''';
SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
EXEC AddDefaultConstraint 'Hospitals','rating','0';
SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
EXEC CreateTable 'Departments',
    'departmentID INT PRIMARY KEY NOT NULL,
    departmentName NVARCHAR(50) NOT NULL';
SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
EXEC AddColumnToTable 'Departments','hospitalID','INT NOT NULL';
EXEC AddForeignKeyConstraint 'Departments','hospitalID','Hospitals','hospitalID';
SELECT * FROM CurrentVersionTable;
SELECT * FROM ProceduresTable;
PRINT('GO TO VERSION 3');
EXEC GoToVersion 3;
PRINT('GO TO VERSION 5');
EXEC GoToVersion 5;
PRINT('GO TO VERSION 6');
EXEC GoToVersion 6;
PRINT('GO TO VERSION 0');
EXEC GoToVersion 0;
PRINT('GO TO VERSION 9');
EXEC GoToVersion 9;
PRINT('GO TO VERSION 0');
EXEC GoToVersion 0;
