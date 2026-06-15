

-- =========================================
-- HANDS-ON 3 : TASK 1
-- SUBQUERIES
-- =========================================

-- Q35: Students enrolled in more courses than the average number of enrollments per student
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS student_name, COUNT(e.course_id) AS course_count FROM students s INNER JOIN enrollments e ON s.student_id=e.student_id GROUP BY s.student_id,s.first_name,s.last_name HAVING COUNT(e.course_id) > (SELECT AVG(course_count) FROM (SELECT COUNT(course_id) AS course_count FROM enrollments GROUP BY student_id) avg_enrollments);

-- Q36: Courses where all enrolled students received grade 'A'
SELECT c.course_id, c.course_name FROM courses c WHERE NOT EXISTS (SELECT 1 FROM enrollments e WHERE e.course_id=c.course_id AND e.grade<>'A');

-- Q37: Highest paid professor in each department
SELECT p.professor_id, p.prof_name, p.salary, p.department_id FROM professors p WHERE p.salary=(SELECT MAX(p2.salary) FROM professors p2 WHERE p2.department_id=p.department_id);

-- Q38: Departments whose average professor salary exceeds 85000 using derived table
SELECT dept_name, avg_salary FROM (SELECT d.dept_name, AVG(p.salary) AS avg_salary FROM departments d INNER JOIN professors p ON d.department_id=p.department_id GROUP BY d.dept_name) dept_avg WHERE avg_salary > 85000;


-- =========================================
-- HANDS-ON 3 : TASK 2
-- CREATING AND USING VIEWS
-- =========================================

-- Q39: Create vw_student_enrollment_summary
CREATE OR REPLACE VIEW vw_student_enrollment_summary AS SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS student_name, d.dept_name, COUNT(e.course_id) AS courses_enrolled, ROUND(AVG(CASE WHEN e.grade='A' THEN 4 WHEN e.grade='B' THEN 3 WHEN e.grade='C' THEN 2 WHEN e.grade='D' THEN 1 ELSE 0 END),2) AS gpa FROM students s LEFT JOIN departments d ON s.department_id=d.department_id LEFT JOIN enrollments e ON s.student_id=e.student_id GROUP BY s.student_id,s.first_name,s.last_name,d.dept_name;

-- Verify View
SELECT * FROM vw_student_enrollment_summary;

-- Q40: Create vw_course_stats
CREATE OR REPLACE VIEW vw_course_stats AS SELECT c.course_name, c.course_code, COUNT(e.student_id) AS total_enrollments, ROUND(AVG(CASE WHEN e.grade='A' THEN 4 WHEN e.grade='B' THEN 3 WHEN e.grade='C' THEN 2 WHEN e.grade='D' THEN 1 ELSE 0 END),2) AS avg_gpa FROM courses c LEFT JOIN enrollments e ON c.course_id=e.course_id GROUP BY c.course_name,c.course_code;

-- Verify View
SELECT * FROM vw_course_stats;

-- Q41: Find students with GPA above 3.0
SELECT * FROM vw_student_enrollment_summary WHERE gpa > 3.0;

-- Q42: Attempt UPDATE through the view
UPDATE vw_student_enrollment_summary SET dept_name='Electronics' WHERE student_id=1;

-- Documentation Comment
-- Multi-table views with GROUP BY, COUNT, AVG and JOINs are generally not updatable.
-- PostgreSQL prevents updates because it cannot uniquely determine which underlying row(s)
-- should be modified in the base tables.

-- Q43: Drop and recreate view WITH CHECK OPTION
DROP VIEW IF EXISTS vw_student_enrollment_summary;

CREATE VIEW vw_student_enrollment_summary AS SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS student_name, d.dept_name, s.enrollment_year FROM students s INNER JOIN departments d ON s.department_id=d.department_id WHERE s.enrollment_year >= 2022 WITH LOCAL CHECK OPTION;

-- Verify recreated view
SELECT * FROM vw_student_enrollment_summary;


