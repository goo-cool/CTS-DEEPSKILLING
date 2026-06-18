

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
