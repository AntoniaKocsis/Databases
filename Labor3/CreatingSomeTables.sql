CREATE TABLE Hospitals(
hospitalID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
hospitalName varchar(50) NOT NULL,
hospitalAddress varchar(50) NOT NULL,
hospitalContact varchar(50) NOT NULL
)
CREATE TABLE Doctors(
doctorID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
doctorFirstName varchar(50) NOT NULL,
doctorLastName varchar(50) NOT NULL,
doctorContact varchar(50) NOT NULL
)

CREATE TABLE Departments(
departmentID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
departmentName varchar(50) NOT NULL,
hospitalID INT NOT NULL,
FOREIGN KEY (hospitalID) REFERENCES Hospitals(hospitalID)
)
CREATE TABLE EnrolledDocs(
enrolledDocID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
departmentID INT NOT NULL,
doctorID INT NOT NULL,
FOREIGN KEY (departmentID) REFERENCES Departments(departmentID),
FOREIGN KEY (doctorID) REFERENCES Doctors(doctorID)
)
-- Insert values into the Hospitals table with real hospital names
INSERT INTO Hospitals (hospitalName, hospitalAddress, hospitalContact)
VALUES
  ('Mount Sinai Hospital', 'One Gustave L. Levy Place, New York, NY', '212-241-6500'),
  ('Cleveland Clinic', '9500 Euclid Ave, Cleveland, OH', '216-444-2200'),
  ('Mayo Clinic', '200 First St SW, Rochester, MN', '507-284-2511'),
  ('Johns Hopkins Hospital', '1800 Orleans St, Baltimore, MD', '410-955-5000'),
  ('Massachusetts General Hospital', '55 Fruit St, Boston, MA', '617-726-2000'),
  ('Stanford Health Care', '300 Pasteur Dr, Stanford, CA', '650-723-4000'),
  ('Brigham and Women''s Hospital', '75 Francis St, Boston, MA', '617-732-5500'),
  ('NewYork-Presbyterian Hospital', '525 East 68th St, New York, NY', '212-746-5454'),
  ('MD Anderson Cancer Center', '1515 Holcombe Blvd, Houston, TX', '713-792-6161'),
  ('Mayo Clinic Hospital in Arizona', '5777 E Mayo Blvd, Phoenix, AZ', '480-515-6296'),
  ('Cedars-Sinai Medical Center', '8700 Beverly Blvd, Los Angeles, CA', '310-423-5000'),
  ('Duke University Hospital', '2301 Erwin Rd, Durham, NC', '919-684-8111'),
  ('Vanderbilt University Medical Center', '1211 Medical Center Dr, Nashville, TN', '615-322-5000');

  -- Insert values into the Doctors table with real doctor names
INSERT INTO Doctors (doctorFirstName, doctorLastName, doctorContact)
VALUES
  ('Dr. Emily', 'Anderson', '555-111-2222'),
  ('Dr. Michael', 'Smith', '444-333-2222'),
  ('Dr. Sarah', 'Johnson', '666-555-4444'),
  ('Dr. William', 'Wilson', '333-777-1111'),
  ('Dr. Laura', 'Brown', '888-666-5555'),
  ('Dr. David', 'Davis', '777-555-8888'),
  ('Dr. Linda', 'Martin', '222-333-1111'),
  ('Dr. Robert', 'Thompson', '111-666-8888'),
  ('Dr. Mary', 'Harris', '444-777-3333'),
  ('Dr. James', 'Lee', '555-444-8888'),
  ('Dr. Jennifer', 'Clark', '777-333-5555'),
  ('Dr. Richard', 'Adams', '888-111-4444');


  -- Departments for Hospital 1
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Cardiology', 1),
  ('Orthopedics', 1),
  ('Neurology', 1);

-- Departments for Hospital 2
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Pediatrics', 2),
  ('Oncology', 2),
  ('Dermatology', 2);

-- Departments for Hospital 3
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Emergency Medicine', 3),
  ('Gastroenterology', 3),
  ('Internal Medicine', 3);

-- Departments for Hospital 4
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Cardiology', 4),
  ('Orthopedics', 4),
  ('Obstetrics and Gynecology', 4);

-- Departments for Hospital 5
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Neurology', 5),
  ('Dermatology', 5),
  ('Gastroenterology', 5);

-- Departments for Hospital 6
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Orthopedics', 6),
  ('Emergency Medicine', 6),
  ('Internal Medicine', 6);

-- Departments for Hospital 7
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Pediatrics', 7),
  ('Obstetrics and Gynecology', 7),
  ('Oncology', 7);

-- Departments for Hospital 8
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Cardiology', 8),
  ('Orthopedics', 8),
  ('Neurology', 8);

-- Departments for Hospital 9
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Oncology', 9),
  ('Dermatology', 9),
  ('Gastroenterology', 9);

-- Departments for Hospital 10
INSERT INTO Departments (departmentName, hospitalID)
VALUES
  ('Emergency Medicine', 10),
  ('Internal Medicine', 10),
  ('Obstetrics and Gynecology', 10);
-- Enroll doctors in departments (at least 2 departments for each doctor)
-- Doctor 1
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (1, 1),  -- Doctor 1 in Cardiology
  (3, 1); -- Doctor 1 in Orthopedics

-- Doctor 2
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (2, 2),  -- Doctor 2 in Pediatrics
  (4, 2); -- Doctor 2 in Neurology

-- Doctor 3
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (5, 3),  -- Doctor 3 in Emergency Medicine
  (6, 3); -- Doctor 3 in Oncology

-- Doctor 4
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (7, 4),  -- Doctor 4 in Dermatology
  (8, 4); -- Doctor 4 in Gastroenterology

-- Doctor 5
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (9, 5),  -- Doctor 5 in Internal Medicine
  (10, 5); -- Doctor 5 in Obstetrics and Gynecology

-- Doctor 6
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (11, 6),  -- Doctor 6 in Cardiology
  (12, 6); -- Doctor 6 in Orthopedics

-- Doctor 7
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (13, 7),  -- Doctor 7 in Pediatrics
  (14, 7); -- Doctor 7 in Neurology

-- Doctor 8
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (15, 8),  -- Doctor 8 in Emergency Medicine
  (16, 8); -- Doctor 8 in Oncology

-- Doctor 9
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (17, 9),  -- Doctor 9 in Dermatology
  (18, 9); -- Doctor 9 in Gastroenterology

-- Doctor 10
INSERT INTO EnrolledDocs (departmentID, doctorID)
VALUES
  (19, 10),  -- Doctor 10 in Internal Medicine
  (20, 10); -- Doctor 10 in Obstetrics and Gynecology
