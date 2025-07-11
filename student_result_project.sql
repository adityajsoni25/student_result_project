
-- Create Database
CREATE DATABASE student_result_db;
USE student_result_db;

-- Students table
CREATE TABLE students (
  student_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);

-- Subjects table
CREATE TABLE subjects (
  subject_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Marks table (normalized)
CREATE TABLE marks (
  student_id INT,
  subject_id INT,
  marks INT CHECK (marks BETWEEN 0 AND 100),
  PRIMARY KEY (student_id, subject_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Users table (admin, faculty)
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  role ENUM('admin', 'faculty') NOT NULL
);

-- Create roles (MySQL 8+)
CREATE ROLE 'admin_role';
CREATE ROLE 'faculty_role';

-- Assign privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON student_result_db.* TO 'faculty_role';
GRANT ALL PRIVILEGES ON student_result_db.* TO 'admin_role';

-- Create users and assign roles
CREATE USER 'admin1'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'faculty1'@'localhost' IDENTIFIED BY 'fac123';

GRANT 'admin_role' TO 'admin1'@'localhost';
GRANT 'faculty_role' TO 'faculty1'@'localhost';

-- Insert students
INSERT INTO students VALUES (1, 'Aditya Soni', 'aditya@example.com');
INSERT INTO students VALUES (2, 'Yash Vishwakarma', 'yash@example.com');
INSERT INTO students VALUES (3, 'Faizal Saiyad', 'faizal@example.com');
INSERT INTO students VALUES (4, 'Tirth Patel', 'tirth@example.com');
INSERT INTO students VALUES (5, 'Mihir Patel', 'mihir@example.com');

-- Insert subjects
INSERT INTO subjects VALUES (101, 'Maths');
INSERT INTO subjects VALUES (102, 'Science');

-- Insert users
INSERT INTO users VALUES (1, 'admin1', 'admin');
INSERT INTO users VALUES (2, 'faculty1', 'faculty');

-- Insert marks
INSERT INTO marks VALUES (1, 101, 85);
INSERT INTO marks VALUES (1, 102, 78);
INSERT INTO marks VALUES (2, 101, 90);
INSERT INTO marks VALUES (3, 101, 82);
INSERT INTO marks VALUES (3, 102, 76);
INSERT INTO marks VALUES (4, 101, 88);
INSERT INTO marks VALUES (5, 102, 80);

-- Create view
CREATE VIEW student_result_view AS
SELECT s.student_id, s.name AS subject, m.marks
FROM students s
JOIN marks m ON s.student_id = m.student_id
JOIN subjects sb ON sb.subject_id = m.subject_id;

-- Create procedure
DELIMITER //
CREATE PROCEDURE upsert_marks (
  IN p_student_id INT,
  IN p_subject_id INT,
  IN p_marks INT
)
BEGIN
  DECLARE row_count INT;
  SELECT COUNT(*) INTO row_count
  FROM marks
  WHERE student_id = p_student_id AND subject_id = p_subject_id;

  IF row_count > 0 THEN
    UPDATE marks
    SET marks = p_marks
    WHERE student_id = p_student_id AND subject_id = p_subject_id;
  ELSE
    INSERT INTO marks(student_id, subject_id, marks)
    VALUES(p_student_id, p_subject_id, p_marks);
  END IF;
END;
//
DELIMITER ;

-- Create audit table
CREATE TABLE marks_audit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT,
  subject_id INT,
  old_marks INT,
  new_marks INT,
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger
DELIMITER //
CREATE TRIGGER trg_marks_update
BEFORE UPDATE ON marks
FOR EACH ROW
BEGIN
  INSERT INTO marks_audit(student_id, subject_id, old_marks, new_marks)
  VALUES (OLD.student_id, OLD.subject_id, OLD.marks, NEW.marks);
END;
//
DELIMITER ;
