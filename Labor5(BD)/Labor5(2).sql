
-- Labor 5 Part 2
-- a)

--Übersicht über die Indizes für Ta

-- Method 1

EXEC sp_helpindex 'Ta';

-- Method 2
SELECT 
    i.name AS IndexName,
    i.index_id AS IndexID,
    i.type_desc AS IndexType,
    c.name AS ColumnName
FROM 
    sys.indexes i
INNER JOIN 
    sys.tables t ON i.object_id = t.object_id
INNER JOIN 
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN 
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE 
    t.name = 'Ta';

-- Clustered Index Scan
SELECT * FROM Ta WHERE a3 % 5 = 0;

-- Clustered Index Seek
SELECT * FROM Ta WHERE idA = 1000;

-- Nonclustered Index Scan
SELECT a2 FROM Ta WHERE a2 % 2 = 0;

-- Nonclustered Index Seek
SELECT a2 FROM Ta WHERE a2 = 1000;

--b)
-- NonClustered Index Seek,Key Lookup
SELECT a3 FROM Ta WHERE a2 = 1000;

--c)
-- NonClustered Index Seek (Index_b2),Key Lookup
CREATE NONCLUSTERED INDEX Index_b2 ON Tb(b2);
DROP INDEX Index_b2 ON Tb;  
EXEC sp_helpindex 'Tb';

SELECT * FROM Tb WHERE b2 = 1000;
-- Estimated Subtree Cost without nonclustered index: 0.0117672
-- Estimated Subtree Cost with nonclustered index:0.0065704

--d)

CREATE NONCLUSTERED INDEX Index_idA ON Tc(idA);
DROP INDEX Index_idA ON Tc;  

CREATE NONCLUSTERED INDEX Index_idB ON Tc(idB);
DROP INDEX Index_idB ON Tc;  

EXEC sp_helpindex 'Tc';

SELECT a2, c2 
FROM Ta
INNER JOIN Tc On Tc.idA = Ta.idA
WHERE Ta.idA = 10;
-- Estimated Subtree Cost without nonclustered index: 0.122125
-- Estimated Subtree Cost with nonclustered index:0.0132278

SELECT b2, c2 
FROM Tb
INNER JOIN Tc On Tc.idB = Tb.idB
WHERE Tb.idB = 1;
-- Estimated Subtree Cost without nonclustered index:0.122134
-- Estimated Subtree Cost with nonclustered index:0.0197027