CREATE TABLE Patients (
    patientID INT IDENTITY(1,1) PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    contact VARCHAR(50),
);
CREATE TABLE Appointments (
    appointmentID INT IDENTITY(1,1) PRIMARY KEY,
    patientID INT,
    enrolledDocID INT,
    appointmentDate DATE,
    FOREIGN KEY (patientID) REFERENCES Patients(patientID),
    FOREIGN KEY (enrolledDocID) REFERENCES EnrolledDocs(enrolledDocID)
);
-- Insert values into the Patients table
INSERT INTO Patients (firstName, lastName, contact)
VALUES
  ('John', 'Doe', '111-222-3333'),
  ('Jane', 'Smith', '444-555-6666'),
  ('David', 'Johnson', '666-777-8888'),
  ('Emily', 'Wilson', '333-777-1111'),
  ('Sarah', 'Brown', '888-666-5555'),
  ('Michael', 'Davis', '777-555-8888'),
  ('Linda', 'Martin', '222-333-1111'),
  ('Robert', 'Thompson', '111-666-8888'),
  ('Mary', 'Harris', '444-777-3333'),
  ('James', 'Lee', '555-444-8888');


  -- Appointments for Patient 1
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (1, 1, '2023-11-05'),
  (1, 2, '2023-11-08');

-- Appointments for Patient 2
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (2, 3, '2023-11-06'),
  (2, 4, '2023-11-09');

-- Appointments for Patient 3
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (3, 5, '2023-11-07'),
  (3, 6, '2023-11-10');

-- Appointments for Patient 4
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (4, 7, '2023-11-05'),
  (4, 8, '2023-11-08');

-- Appointments for Patient 5
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (5, 9, '2023-11-06'),
  (5, 10, '2023-11-09');

-- Appointments for Patient 6
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (6, 11, '2023-11-07'),
  (6, 12, '2023-11-10');

-- Appointments for Patient 7
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (7, 13, '2023-11-05'),
  (7, 14, '2023-11-08');

-- Appointments for Patient 8
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (8, 15, '2023-11-06'),
  (8, 16, '2023-11-09');

-- Appointments for Patient 9
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (9, 17, '2023-11-07'),
  (9, 18, '2023-11-10');

-- Appointments for Patient 10
INSERT INTO Appointments (patientID, enrolledDocID, appointmentDate)
VALUES
  (10, 19, '2023-11-05'),
  (10, 20, '2023-11-08');
