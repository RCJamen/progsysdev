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

DROP TABLE IF EXISTS `sections`;
CREATE TABLE IF NOT EXISTS `sections`(
sectionCode VARCHAR(255) PRIMARY KEY,
subjectCode VARCHAR(255),
handlerID VARCHAR(9),
FOREIGN KEY (handlerID) REFERENCES faculty(facultyID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `subjectList`;
CREATE TABLE IF NOT EXISTS `subjectList`(
subjectCode VARCHAR(255) PRIMARY KEY NOT NULL UNIQUE,
section VARCHAR(255),
description VARCHAR(255) NOT NULL,
credits INT,
handlerName VARCHAR(255) DEFAULT 'NOT ASSIGNED',
semester INT NOT NULL,
FOREIGN KEY(section) REFERENCES sections(sectionCode)
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
FOREIGN KEY(subjectCode) REFERENCES subjectList(subjectCode),
FOREIGN KEY(assessID) REFERENCES assessments(assessID)
);

INSERT INTO `faculty` (facultyID, firstname, lastname, email)
VALUES ('2023-0001', 'Fulgent', 'Travesores', 'fulgent.travesores@g.msuiit.edu.ph'),
('2023-0002', 'Alrick', 'Gicole', 'alrick.gicole@g.msuiit.edu.ph'),
('2023-0003', 'Janella', 'Balantac', 'janella.balantac@g.msuiit.edu.ph'),
('2023-0004', 'Ramel Cary', 'Jamen', 'ramelcary.jamen@g.msuiit.edu.ph');

INSERT INTO subjectList (subjectCode, description, credits, semester)
VALUES 
('CCC181', 'Application Development', 3, 1),
('CSC181', 'Software Engineering', 3, 2);

INSERT INTO sections (sectionCode, subjectCode, handlerID)
VALUES
('CS3A', 'CCC181', '2023-0001'),
('CS3B', 'CCC181', '2023-0002'),
('CS4', 'CSC181', '2023-0004');
