
-- Check for appointments with no examination Room in them -> get the id of the doctor

/*SELECT A.enrolledDocID
FROM Appointments A
WHERE A.roomID IS NULL*/

-- Get the hospital id

/*SELECT H.hospitalID
FROM EnrolledDoc E
INNER JOIN Departments DE ON E.departmentID = DE.departmentID
INNER JOIN Hospitals H ON DE.hospitalID = H.hospitalID
WHERE E.enrolledDocID IN (SELECT A.enrolledDocID
						  FROM Appointments A
						  WHERE A.roomID IS NULL)*/


-- Get the roomID that might be available for a specific appointment
/*SELECT TOP(1) E.roomID
FROM ExaminationRooms E
WHERE E.hospitalID IN (SELECT TOP(1) H.hospitalID
					   FROM EnrolledDoc E1
					   INNER JOIN Departments DE ON E1.departmentID = DE.departmentID
					   INNER JOIN Hospitals H ON DE.hospitalID = H.hospitalID
					   WHERE E1.enrolledDocID  = 15
					   ORDER BY H.hospitalID) 
				   AND E.roomID NOT IN (SELECT A.roomID 
										FROM Appointments A
										WHERE A.date = '2023-08-01' AND A.roomID IS NOT NULL)
ORDER BY E.roomID*/

UPDATE Appointments
SET roomID = (SELECT TOP(1) E.roomID
			  FROM ExaminationRooms E
			  WHERE E.hospitalID IN (SELECT TOP(1) H.hospitalID
								     FROM EnrolledDoc E1
								     INNER JOIN Departments DE ON E1.departmentID = DE.departmentID
  								     INNER JOIN Hospitals H ON DE.hospitalID = H.hospitalID
								     WHERE E1.enrolledDocID  = Appointments.enrolledDocID
								     ORDER BY H.hospitalID) 
			  AND E.roomID NOT IN (SELECT A.roomID 
								   FROM Appointments A
								   WHERE A.date = Appointments.date AND A.roomID IS NOT NULL)) 
WHERE roomID IS NULL	
