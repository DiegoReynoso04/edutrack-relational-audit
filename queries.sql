-- EduTrack v2 — Auditoría sobre el esquema normalizado (students, courses, enrollments)
-- Todas las consultas usan al menos un JOIN y ninguna subconsulta.

-- ============================================================
-- INNER JOIN
-- ============================================================

-- Q1: inscripciones con nombre del estudiante, título del curso y porcentaje de completado


-- Q2: estudiantes que han aprobado al menos un curso (nombre, email y curso aprobado)


-- Q3: porcentaje de completado medio por instructor, de mayor a menor


-- ============================================================
-- LEFT JOIN (detección de datos faltantes)
-- ============================================================

-- Q4: estudiantes sin ninguna inscripción


-- Q5: cursos sin ninguna inscripción


-- ============================================================
-- Agregación entre tablas
-- ============================================================

-- Q6: estudiantes inscritos en más de un curso (GROUP BY + HAVING)


-- Q7: ingresos totales por categoría con el precio actual del curso (courses.monthly_fee)


-- Q8: número de estudiantes inscritos por instructor


-- ============================================================
-- Integridad de datos
-- ============================================================

-- Q9: inscripciones con student_id que no corresponde a ningún estudiante (huérfanas)


-- Q10: inscripciones con course_id que no corresponde a ningún curso (huérfanas)

