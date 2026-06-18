-- =========================================
-- HANDS-ON 1 : TASK 1
-- Schema Design & Core SQL
-- Student Course Registration System
-- =========================================

--LOGIN FIRST
--psql -U postgres

-- Create Database
CREATE DATABASE college_db;
-- =========================================
-- TABLE 1 : departments
-- =========================================

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);


-- =========================================
-- TABLE 2 : students
-- =========================================

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT,

    CONSTRAINT fk_student_department
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);


-- =========================================
-- TABLE 3 : courses
-- =========================================

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,

    CONSTRAINT fk_course_department
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);


-- =========================================
-- TABLE 4 : enrollments
-- =========================================

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),

    CONSTRAINT fk_enrollment_student
    FOREIGN KEY (student_id)
    REFERENCES students(student_id),

    CONSTRAINT fk_enrollment_course
    FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
);


-- =========================================
-- TABLE 5 : professors
-- =========================================

CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),

    CONSTRAINT fk_professor_department
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);


-- =========================================
-- HANDS-ON 1 : TASK 2
-- NORMALIZATION ANALYSIS
-- =========================================

-- 1NF (First Normal Form)
-- All tables contain atomic values.
-- Each column stores a single value only.
-- Example: students table stores one email per column.
-- A violation of 1NF would occur if multiple phone numbers
-- were stored in a single column separated by commas.

-- 2NF (Second Normal Form)
-- All non-key attributes depend on the whole primary key.
-- In enrollments, enrollment_date and grade depend on the
-- student-course enrollment record and not on only one part.
-- Therefore partial dependency does not exist.

-- 3NF (Third Normal Form)
-- No transitive dependencies are present.
-- Department information is stored in departments table.
-- Students reference departments using department_id.
-- Storing dept_name directly in students would violate 3NF
-- because dept_name depends on department_id, not student_id.

-- Enrollments Table 3NF Analysis
-- Primary Key: enrollment_id
-- grade depends directly on enrollment_id.
-- enrollment_date depends directly on enrollment_id.
-- No non-key attribute depends on another non-key attribute.
-- Therefore enrollments table satisfies 3NF.


-- =========================================
-- HANDS-ON 1 : TASK 3
-- ALTER TABLE OPERATIONS
-- =========================================

-- Step 10: Add phone_number column
ALTER TABLE students ADD COLUMN phone_number VARCHAR(15);

-- Verify
\d students

-- Step 11: Add max_seats column
ALTER TABLE courses ADD COLUMN max_seats INT DEFAULT 60;

-- Verify
\d courses

-- Step 12: Add CHECK constraint for grades
ALTER TABLE enrollments ADD CONSTRAINT chk_grade CHECK (grade IN ('A','B','C','D','F') OR grade IS NULL);

-- Verify
\d enrollments

-- Step 13: Rename hod_name to head_of_dept
ALTER TABLE departments RENAME COLUMN hod_name TO head_of_dept;

-- Verify
\d departments

-- Step 14: Drop phone_number column (rollback simulation)
ALTER TABLE students DROP COLUMN phone_number;

-- Verify
\d students

