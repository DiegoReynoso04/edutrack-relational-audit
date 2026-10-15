-- EduTrack v2 — Auditoría sobre el esquema normalizado (students, courses, enrollments)
-- Todas las consultas usan al menos un JOIN y ninguna subconsulta.

-- ============================================================
-- INNER JOIN
-- ============================================================

-- Q1: inscripciones con nombre del estudiante, título del curso y porcentaje de completado
SELECT e.id, s.name AS student_name, c.title AS course_title, e.completion_percentage
FROM enrollments e
INNER JOIN students s ON e.student_id = s.id
INNER JOIN courses c ON e.course_id = c.id
ORDER BY e.id;

-- Q2: estudiantes que han aprobado al menos un curso (nombre, email y curso aprobado)
SELECT s.name AS student_name, s.email AS student_email, c.title AS course_title
FROM enrollments e
INNER JOIN students s ON e.student_id = s.id
INNER JOIN courses c ON e.course_id = c.id
WHERE e.passed = true
ORDER BY s.name, c.title;

-- Q3: porcentaje de completado medio por instructor, de mayor a menor
SELECT c.instructor_name, ROUND(AVG(e.completion_percentage), 2) AS promedio_completado
FROM enrollments e
INNER JOIN courses c ON e.course_id = c.id
GROUP BY c.instructor_name
ORDER BY promedio_completado DESC;

-- ============================================================
-- LEFT JOIN (detección de datos faltantes)
-- ============================================================

-- Q4: estudiantes sin ninguna inscripción
SELECT s.id, s.name, s.email, s.signup_date
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.id
WHERE e.id IS NULL;

-- Q5: cursos sin ninguna inscripción
SELECT c.id, c.title, c.category, c.instructor_name, c.monthly_fee
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.id
WHERE e.id IS NULL;

-- ============================================================
-- Agregación entre tablas
-- ============================================================

-- Q6: estudiantes inscritos en más de un curso (GROUP BY + HAVING)
SELECT s.id, s.name, COUNT(DISTINCT e.course_id) AS cursos_inscritos
FROM students s
INNER JOIN enrollments e ON e.student_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(DISTINCT e.course_id) > 1
ORDER BY cursos_inscritos DESC, s.name;

-- Q7: ingresos totales por categoría con el precio actual del curso (courses.monthly_fee)
SELECT c.category, COUNT(e.id) AS inscripciones, SUM(c.monthly_fee) AS ingresos_totales
FROM enrollments e
INNER JOIN courses c ON e.course_id = c.id
GROUP BY c.category
ORDER BY ingresos_totales DESC;

-- Q8: número de estudiantes inscritos por instructor
SELECT c.instructor_name, COUNT(DISTINCT e.student_id) AS estudiantes_inscritos, COUNT(e.id) AS inscripciones
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.id
GROUP BY c.instructor_name
ORDER BY estudiantes_inscritos DESC, c.instructor_name;

-- ============================================================
-- Integridad de datos
-- ============================================================

-- Q9: inscripciones con student_id que no corresponde a ningún estudiante (huérfanas)
SELECT e.id, e.student_id, e.course_id, e.enrollment_date
FROM enrollments e
LEFT JOIN students s ON e.student_id = s.id
WHERE s.id IS NULL;

-- Q10: inscripciones con course_id que no corresponde a ningún curso (huérfanas)
SELECT e.id, e.student_id, e.course_id, e.enrollment_date
FROM enrollments e
LEFT JOIN courses c ON e.course_id = c.id
WHERE c.id IS NULL;
