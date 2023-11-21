DROP DATABASE IF EXISTS `progsys_db`;
CREATE DATABASE IF NOT EXISTS `progsys_db`;
use `progsys_db`;


DROP TABLE IF EXISTS `colleges`;
CREATE TABLE IF NOT EXISTS `colleges`(
collegeID INT AUTO_INCREMENT NOT NULL,
name VARCHAR(255) NOT NULL,
PRIMARY KEY(collegeID)
);

DROP TABLE IF EXISTS `curriculum`;
CREATE TABLE IF NOT EXISTS `curriculum`(
currID INT AUTO_INCREMENT NOT NULL,
name VARCHAR(255) NOT NULL,
description CHAR NOT NULL,
PRIMARY KEY(currID)
);

DROP TABLE IF EXISTS `departments`;
CREATE TABLE IF NOT EXISTS `departments`(
departmentID INT AUTO_INCREMENT NOT NULL,
name VARCHAR(255) NOT NULL,
collegeID INT NOT NULL,
currID INT NOT NULL,
PRIMARY KEY(departmentID),
FOREIGN KEY(collegeID) REFERENCES colleges(collegeID),
FOREIGN KEY(currID) REFERENCES curriculum(currID)
);

DROP TABLE IF EXISTS `learning_outcomes`;
CREATE TABLE IF NOT EXISTS `learning_outcomes`(
learnOutID INT AUTO_INCREMENT NOT NULL,
title VARCHAR(255) NOT NULL,
description CHAR NOT NULL,
currID INT NOT NULL,
PRIMARY KEY(learnOutID),
FOREIGN KEY(currID) REFERENCES curriculum(currID)
);

DROP TABLE IF EXISTS `assessments`;
CREATE TABLE IF NOT EXISTS `assessments`(
assessID INT AUTO_INCREMENT NOT NULL,
name VARCHAR(255) NOT NULL,
score INT NOT NULL,
totalScore INT NOT NULL,
PRIMARY KEY(assessID)
);

DROP TABLE IF EXISTS `student_outcomes`;
CREATE TABLE IF NOT EXISTS `student_outcomes`(
stuOutID INT AUTO_INCREMENT NOT NULL,
name VARCHAR(255) NOT NULL,
description CHAR NOT NULL,
assessID INT NOT NULL,
PRIMARY KEY(stuOutID),
FOREIGN KEY(assessID) REFERENCES assessments(assessID)
);

DROP TABLE IF EXISTS `student_learning_objectives`;
CREATE TABLE IF NOT EXISTS `student_learning_objectives`(
stuLearnObjID INT AUTO_INCREMENT NOT NULL,
learnOutID INT NOT NULL,
stuOutID INT NOT NULL,
PRIMARY KEY(stuLearnObjID),
FOREIGN KEY(learnOutID) REFERENCES learning_outcomes(learnOutID),
FOREIGN KEY(stuOutID) REFERENCES student_outcomes(stuOutID)
);

DROP TABLE IF EXISTS `courses`;
CREATE TABLE IF NOT EXISTS `courses`(
courseID INT AUTO_INCREMENT NOT NULL,
name VARCHAR(255) NOT NULL,
description CHAR NOT NULL,
departmentID INT NOT NULL,
PRIMARY KEY(courseID),
FOREIGN KEY(departmentID) REFERENCES departments(departmentID)
);

DROP TABLE IF EXISTS `chairperson`;
CREATE TABLE IF NOT EXISTS `chairperson`(
chairID INT AUTO_INCREMENT NOT NULL,
firstname VARCHAR(255) NOT NULL,
lastname VARCHAR(255) NOT NULL,
PRIMARY KEY(chairID)
);

DROP TABLE IF EXISTS `faculty`;
CREATE TABLE IF NOT EXISTS `faculty`(
facultyID VARCHAR (9) NOT NULL,
firstname VARCHAR(255) NOT NULL,
lastname VARCHAR(255) NOT NULL,
email VARCHAR(255) NOT NULL,
PRIMARY KEY(facultyID)
);

DROP TABLE IF EXISTS `students`;
CREATE TABLE IF NOT EXISTS `students`(
studentID INT AUTO_INCREMENT NOT NULL,
firstname VARCHAR(255) NOT NULL,
lastname VARCHAR(255) NOT NULL,
courseID INT NOT NULL,
gmail VARCHAR(255) NOT NULL,
PRIMARY KEY(studentID),
FOREIGN KEY(courseID) REFERENCES courses(courseID)
);

DROP TABLE IF EXISTS `section`;
CREATE TABLE IF NOT EXISTS `section`(
sectionCode VARCHAR(255) PRIMARY KEY
);

DROP TABLE IF EXISTS `subject`;
CREATE TABLE IF NOT EXISTS `subject`(
subjectCode VARCHAR(255) PRIMARY KEY NOT NULL UNIQUE,
description VARCHAR(255) NOT NULL,
credits INT
);

DROP TABLE IF EXISTS `subject_section`;
CREATE TABLE IF NOT EXISTS `subject_section`(
subjectID VARCHAR(9),
sectionID VARCHAR(255),
PRIMARY KEY (subjectID, sectionID),
FOREIGN KEY (subjectID) REFERENCES subject(subjectCode),
FOREIGN KEY (sectionID) REFERENCES section(sectionCode)
);

DROP TABLE IF EXISTS `assignFaculty`;
CREATE TABLE IF NOT EXISTS `assignFaculty`(
facultyID VARCHAR(9),
subjectID VARCHAR(255),
sectionID VARCHAR(255),
PRIMARY KEY (subjectID, sectionID),  -- Change the primary key
FOREIGN KEY (facultyID) REFERENCES faculty(facultyID) ON DELETE SET NULL,
FOREIGN KEY (subjectID) REFERENCES subject(subjectCode) ON DELETE CASCADE,
FOREIGN KEY (sectionID) REFERENCES section(sectionCode) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `class_records`;
CREATE TABLE IF NOT EXISTS `class_records`(
classRecordID INT AUTO_INCREMENT NOT NULL,
studentID INT NOT NULL,
subjectCode VARCHAR(255) NOT NULL,
assessID INT NOT NULL,
totalGrade INT NOT NULL,
PRIMARY KEY(classRecordID),
FOREIGN KEY(studentID) REFERENCES students(studentID),
FOREIGN KEY(subjectCode) REFERENCES subject(subjectCode),
FOREIGN KEY(assessID) REFERENCES assessments(assessID)
);

INSERT INTO `faculty` (facultyID, firstname, lastname, email)
VALUES ('2023-0001', 'Fulgent', 'Lavesores', 'fulgent.lavesores@g.msuiit.edu.ph'),
('2023-0002', 'Alrick', 'Gicole', 'alrick.gicole@g.msuiit.edu.ph'),
('2023-0003', 'Janella', 'Balantac', 'janella.balantac@g.msuiit.edu.ph'),
('2023-0004', 'Ramel Cary', 'Jamen', 'ramelcary.jamen@g.msuiit.edu.ph');

INSERT INTO subject (subjectCode, description, credits)
VALUES 
('CCC100', 'Fundamentals of Computing', 3),
('CCC101', 'Computer Programming 1', 3),
('CCC102', 'Computer Programming 2', 3),
('CCC121', 'Data Structures and Algorithm', 3),
('CCC151', 'Information Management', 3),
('CSC112', 'Computer Organization and Architecture', 3),
('CSC124', 'Design and Analysis of Algorithms', 3),
('CSC186', 'Human-Computer Interaction', 3),
('CCC181', 'Applications Development and
Emerging Technologies', 3),
('CSC145', 'Programming Languages', 3),
('CSC171', 'Introduction to Artificial Intelligence', 3),
('CSC181', 'Software Engineering', 4),
('CSC113', 'Computer Networks and Data Communications', 3),
('CSC133', 'Modeling and Simulation', 3),
('CSC161', 'Computer Systems Security', 3),
('CSC175', 'Parallel and Distributed Computing', 3),
('CSC194', 'Computer Science Seminar', 1),
('CSC197', 'Practicum', 0),
('CSC193', 'Special Topics in Computer Science', 3),
('CSC198', 'Research Methods', 3),
('CSC109', 'Social, Ethical, and Professional Issues', 3),
('CSC199', 'Undergraduate Thesis', 3);

INSERT INTO section (sectionCode)
VALUES
('CS1A'),
('CS1B'),
('CS1C'),
('CS2A'),
('CS2B'),
('CS2C'),
('CS3A'),
('CS3B'),
('CS3C'),
('CS4A'),
('CS4B'),
('CS4C');

INSERT INTO subject_section (subjectID, sectionID)
VALUES
('CCC101', 'CS2A'),
('CCC102', 'CS2A'),
('CCC181', 'CS3A'),
('CCC181', 'CS3B'),
('CSC181', 'CS3A'),
('CSC181', 'CS3B');


INSERT INTO assignFaculty (facultyID, subjectID, sectionID)
VALUES
('2023-0001', 'CSC181', 'CS3A'),
('2023-0001', 'CCC181', 'CS3A'),
('2023-0002', 'CSC181', 'CS3B'),
('2023-0002', 'CCC181', 'CS3B'),
('2023-0004', 'CCC102', 'CS2A');