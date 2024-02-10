
-- 1. 
SELECT P.patientID ,P.firstName AS PatientFirstName,P.lastName AS PatientLastName
FROM Patients P
INNER JOIN Prescriptions PE ON PE.patientID = P.patientID
INNER JOIN EnrolledDoc E ON E.enrolledDocID = PE.enrolledDocID
INNER JOIN Departments DE ON E.departmentID = DE.departmentID
INNER JOIN Hospitals H ON H.hospitalID = DE.hospitalID
WHERE H.name = 'Opticon' AND PE.prescriptionID NOT IN (SELECT PI.prescriptionID
													FROM PrescriptionItems PI
													GROUP BY PI.prescriptionID
													HAVING COUNT(*)<2)
GO
-- 2. 
SELECT M.name, MIN(A.price) AS MinPrice
FROM AvailableMedications A
INNER JOIN Medications M ON M.medicationID = A.medicationID
INNER JOIN PrescriptionItems PI ON PI.medicationID = M.medicationID
INNER JOIN Prescriptions PE ON PI.prescriptionID = PE.prescriptionID
INNER JOIN Patients P ON P.patientID = PE.patientID
WHERE P.firstName = 'Krisztina' AND P.lastName = 'Kocsis' AND PE.date>= 
ALL(SELECT PE2.date FROM Prescriptions PE2 WHERE PE2.patientID = 2)
GROUP BY M.medicationID,M.name
ORDER BY MIN(A.price)
GO

-- 3. 
SELECT P.firstName,P.lastName,A.date,A.roomID,D.firstName,D.lastName,DE.name,H.name
FROM Appointments A
INNER JOIN Patients P ON A.patientID = P.patientID
INNER JOIN EnrolledDoc E ON A.enrolledDocID = E.enrolledDocID
INNER JOIN Doctors D ON E.doctorID = D.doctorID
INNER JOIN Departments DE ON DE.departmentID = E.departmentID
INNER JOIN Hospitals H ON H.hospitalID = DE.hospitalID
WHERE P.dateOfBirth >= ALL (SELECT P1.dateOfBirth FROM Patients P1 )

 
 -- 4.
SELECT D.doctorID,D.firstName,D.lastName,COUNT(*) AS NumberOfPatients
FROM Appointments A
INNER JOIN EnrolledDoc E ON A.enrolledDocID = E.enrolledDocID
INNER JOIN Doctors D ON E.doctorID = D.doctorID
WHERE A.date >= '2023-05-01'
GROUP BY D.doctorID,D.firstName,D.lastName
EXCEPT
SELECT D.doctorID,D.firstName,D.lastName,COUNT(*) AS NumberOfPatients
FROM Appointments A
INNER JOIN EnrolledDoc E ON A.enrolledDocID = E.enrolledDocID
INNER JOIN Doctors D ON E.doctorID = D.doctorID
WHERE A.date >= '2023-06-01' AND A.date <= '2023-07-01'
GROUP BY D.doctorID,D.firstName,D.lastName
GO

--5. 

SELECT D.doctorID,D.firstName,D.lastName,DE.name,H.name
FROM Doctors D
INNER JOIN EnrolledDoc E ON D.doctorID = E.doctorID
INNER JOIN Departments DE ON DE.departmentID = E.departmentID
INNER JOIN Hospitals H ON H.hospitalID = DE.hospitalID
WHERE H.hospitalID IN (SELECT TOP(1) H.hospitalID
						FROM Appointments A
						INNER JOIN EnrolledDoc E ON A.enrolledDocID = E.enrolledDocID
						INNER JOIN Departments DE ON DE.departmentID = E.departmentID
						INNER JOIN Hospitals H ON H.hospitalID = DE.hospitalID
						GROUP BY H.hospitalID
						HAVING COUNT(*)>=2
						ORDER BY COUNT(*) DESC)
INTERSECT
SELECT D1.doctorID,D1.firstName,D1.lastName,DE1.name,H1.name 
FROM Doctors D1
INNER JOIN EnrolledDoc E1 ON D1.doctorID = E1.doctorID
INNER JOIN Departments DE1 ON DE1.departmentID = E1.departmentID
INNER JOIN Hospitals H1 ON H1.hospitalID = DE1.hospitalID
WHERE DE1.name = 'Ortopedie'
GO
--6. 
SELECT M.name AS Medication,M.concentartion AS Concentartion,P.name AS PharmaDistributor,P.address AS Address,A.price AS Price
FROM PharmaDistributors P
INNER JOIN AvailableMedications A ON P.phdID = A.phdID
INNER JOIN Medications M ON A.medicationID = M.medicationID
WHERE M.name = 'Nurofen' AND M.concentartion = 400 AND A.price <= ALL(SELECT A1.price FROM AvailableMedications A1 INNER JOIN Medications M1 ON A1.medicationID = M1.medicationID WHERE M1.name = 'Nurofen' AND M1.concentartion = 400)
UNION
SELECT M1.name AS Medication,M1.concentartion AS Concentartion,P1.name AS PharmaDistributor,P1.address AS Address,A1.price AS Price
FROM PharmaDistributors P1
INNER JOIN AvailableMedications A1 ON P1.phdID = A1.phdID
INNER JOIN Medications M1 ON A1.medicationID = M1.medicationID
WHERE M1.name = 'Nurofen' AND M1.concentartion = 400 AND A1.price >= ALL(SELECT A2.price FROM AvailableMedications A2 INNER JOIN Medications M2 ON A2.medicationID = M2.medicationID WHERE M2.name = 'Nurofen' AND M2.concentartion = 400)
GO


--7. 
SELECT PE2.prescriptionID, PE2.date,M1.name AS UnavailableMed
FROM Medications M1
INNER JOIN PrescriptionItems PI ON PI.medicationID = M1.medicationID
INNER JOIN Prescriptions PE2 ON PI.prescriptionID = PE2.prescriptionID
WHERE PI.prescriptionID IN (SELECT PE.prescriptionID 
							FROM Prescriptions PE INNER JOIN Patients P ON PE.patientID = P.patientID 
							WHERE P.firstName = 'Sergiu' AND P.lastName = 'Marian' 
							AND PE.date >= ALL 
							(SELECT PE1.date 
							FROM Prescriptions PE1 
							INNER JOIN Patients P1 ON PE.patientID = P1.patientID 
							WHERE P1.firstName = 'Sergiu' AND P1.lastName = 'Marian'))
						  AND M1.medicationID IN (SELECT M.medicationID
						  FROM Medications M
						  LEFT JOIN AvailableMedications A ON M.medicationID = A.medicationID
						  WHERE A.phdID IS NULL)
GO
--8. 

/*SELECT AVG(A.price) AS AveragePrice
FROM AvailableMedications A
INNER JOIN Medications M1 ON A.medicationID = M1.medicationID
WHERE A.medicationID IN (SELECT TOP(1) M.medicationID
						FROM PrescriptionItems PI
						INNER JOIN Medications M ON PI.medicationID = M.medicationID
						GROUP BY M.medicationID
						ORDER BY COUNT(*) DESC)*/

SELECT P.phdID,P.name,P.address,P.contact,A1.medicationID,A1.price
FROM PharmaDistributors P 
JOIN AvailableMedications A1 ON A1.phdID = P.phdID
WHERE A1.medicationID IN (SELECT TOP(1) M.medicationID
						FROM PrescriptionItems PI
						INNER JOIN Medications M ON PI.medicationID = M.medicationID
						GROUP BY M.medicationID
						ORDER BY COUNT(*) DESC)
INTERSECT
SELECT P1.phdID,P1.name,P1.address,P1.contact,A2.medicationID,A2.price
FROM PharmaDistributors P1
JOIN AvailableMedications A2 ON A2.phdID = P1.phdID
WHERE A2.price + 2 <= (SELECT AVG(A.price) AS AveragePrice
					FROM AvailableMedications A
					INNER JOIN Medications M1 ON A.medicationID = M1.medicationID
					WHERE A.medicationID IN (SELECT TOP(1) M.medicationID
											FROM PrescriptionItems PI
											INNER JOIN Medications M ON PI.medicationID = M.medicationID
											GROUP BY M.medicationID
											ORDER BY COUNT(*) DESC))
		OR A2.price - 2 <= (SELECT AVG(A.price) AS AveragePrice
					FROM AvailableMedications A
					INNER JOIN Medications M1 ON A.medicationID = M1.medicationID
					WHERE A.medicationID IN (SELECT TOP(1) M.medicationID
											FROM PrescriptionItems PI
											INNER JOIN Medications M ON PI.medicationID = M.medicationID
											GROUP BY M.medicationID
											ORDER BY COUNT(*) DESC))
GO
-- 9.


SELECT H.name AS Hopsital,H.address AS Address,D.firstName AS DoctorFirstName,D.lastName AS DoctorLastName
FROM Doctors D
INNER JOIN EnrolledDoc E ON D.doctorID = E.doctorID
INNER JOIN Departments DE ON DE.departmentID = E.departmentID
INNER JOIN Hospitals H ON H.hospitalID = DE.hospitalID
WHERE H.hospitalID IN (SELECT H.hospitalID
						FROM Hospitals H
						INNER JOIN AvailableMedicalDevices A ON H.hospitalID = A.hospitalID
						INNER JOIN MedicalDevices M ON M.medicalDevicesID = A.medicalDevicesID
						WHERE M.name = 'X-ray Machine')

				AND D.doctorID IN ((SELECT D.doctorID
					FROM Appointments A
					INNER JOIN EnrolledDoc E ON A.enrolledDocID = E.enrolledDocID
					INNER JOIN Doctors D ON E.doctorID = D.doctorID
					WHERE A.date >= '2023-06-01' AND A.date <= '2023-08-01'
					GROUP BY D.doctorID
					HAVING COUNT(*)<3))

-- 10.
SELECT DISTINCT P.patientID,P.firstName,P.lastName
FROM Patients P
INNER JOIN Prescriptions PE ON P.patientID = PE.patientID
INNER JOIN PrescriptionItems PI ON PI.prescriptionID = PE.prescriptionID
INNER JOIN Medications M ON M.medicationID = PI.medicationID
WHERE M.medicationID = ANY(SELECT A.medicationID
						 FROM AvailableMedications A
					   	 GROUP BY A.medicationID
						 HAVING MIN(A.price)>(SELECT AVG(A1.price) FROM AvailableMedications A1))



--Calculate the Bill
/*SELECT SUM(MinPrice) AS Bill
FROM (SELECT M.name, MIN(A.price) AS MinPrice
	FROM AvailableMedications A
	INNER JOIN Medications M ON M.medicationID = A.medicationID
	INNER JOIN PrescriptionItems PI ON PI.medicationID = M.medicationID
	WHERE PI.prescriptionID = 12
	GROUP BY M.medicationID,M.name) 
AS Subquery;*/