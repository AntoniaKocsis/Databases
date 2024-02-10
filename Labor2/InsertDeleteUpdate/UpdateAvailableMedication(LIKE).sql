UPDATE AvailableMedications
SET price = price - 5
WHERE medicationID IN (SELECT M.medicationID
						FROM Medications M
						WHERE M.name LIKE 'Nurofen%' AND M.concentartion = 200)
GO

SELECT M.name AS MedicationName,M.concentartion,P.name,A.price
FROM AvailableMedications A
INNER JOIN Medications M ON M.medicationID = A.medicationID
INNER JOIN PharmaDistributors P ON A.phdID = P.phdID
GO

