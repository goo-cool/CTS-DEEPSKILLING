

-- =========================================
-- TASK 1 : BASELINE PERFORMANCE (NO INDEXES)
-- =========================================

-- Q48
-- Run EXPLAIN on the query below and observe the execution plan.

EXPLAIN
SELECT s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;


--49 --50 checkout screenshots

-- =========================================
-- TASK 2 : ADD INDEXES AND COMPARE PLANS
-- =========================================

--51

CREATE INDEX idx_students_enrollment_year
ON students(enrollment_year);

--52

CREATE UNIQUE INDEX idx_enrollments_student_course
ON enrollments(student_id,course_id);

--53

CREATE INDEX idx_courses_course_code
ON courses(course_code);

--54

EXPLAIN
SELECT s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON s.student_id = e.student_id
JOIN courses c
ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

--55

CREATE INDEX idx_enrollments_null_grades
ON enrollments(student_id)
WHERE grade IS NULL;

-- =========================================
-- TASK 3 : IDENTIFY AND FIX THE N+1 PROBLEM
-- =========================================

-- Q56
-- N+1 Problem Simulation
--
-- Implement using Python.
--
-- Logic:
-- 1 Query:
-- SELECT * FROM enrollments
--
-- Then N Additional Queries:
-- SELECT * FROM students WHERE student_id=?
--
-- Total Queries:
-- 1 + N
--
-- This is called the N+1 Query Problem.


-- =========================================
-- Q57
-- Fix N+1 Using JOIN
-- =========================================

-- Single SQL Query:

SELECT e.enrollment_id,
       s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
JOIN courses c
ON e.course_id = c.course_id;

-- One query replaces many database round trips.


-- =========================================
-- Q58
-- Compare Round Trips
-- =========================================

-- N+1 Version:
-- 1 query + N queries

-- JOIN Version:
-- 1 query total

-- Result:
-- JOIN version performs significantly fewer
-- database round trips.


-- =========================================
-- Q59
-- Documentation
-- =========================================

-- Example:
--
-- If there are 10,000 enrollments:
--
-- N+1 Approach
-- = 1 + 10,000 queries
-- = 10,001 database calls
--
-- JOIN Approach
-- = 1 query
--
-- Therefore JOIN is vastly more efficient
-- and scalable.