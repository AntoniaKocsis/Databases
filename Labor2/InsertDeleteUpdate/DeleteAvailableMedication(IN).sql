DELETE FROM AvailableMedications
WHERE medicationID IN (SELECT M.medicationID FROM Medications M WHERE M.name IN ('Debridat','Claritin'))
GO

DELETE FROM Prescriptions
WHERE enrolledDocID IN (SELECT D.doctorID FROM Doctors D WHERE D.lastName LIKE 'Pop%')
GO

DELETE FROM Prescriptions
WHERE prescriptionID IN (SELECT P.prescriptionID FROM PrescriptionItems P WHERE P.medicationID IN  (SELECT M.medicationID
																									FROM Medications M
																									LEFT JOIN AvailableMedications A ON M.medicationID = A.medicationID
																									WHERE A.phdID IS NULL)
						)
GO

