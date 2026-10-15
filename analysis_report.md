# EduTrack v2 — Informe de auditoría sobre el esquema normalizado

Consultas ejecutadas en Supabase sobre `edutrack_v2.sql` (8 estudiantes, 7 cursos, 16 inscripciones).
Todas las consultas usan al menos un JOIN y ninguna subconsulta. El diagrama entidad-relación está en [`diagram.png`](diagram.png).

## Modelo de datos

- `students` (PK `id`) 1 — n `enrollments` (FK `student_id`)
- `courses` (PK `id`) 1 — n `enrollments` (FK `course_id`)
- `students` n — m `courses`, a través de la tabla intermedia `enrollments`

## Q1 - Inscripciones con estudiante, curso y porcentaje de completado

## Q2 - Estudiantes que han aprobado al menos un curso

## Q3 - Porcentaje de completado medio por instructor

## Q4 - Estudiantes sin ninguna inscripción

## Q5 - Cursos sin ninguna inscripción

## Q6 - Estudiantes inscritos en más de un curso

## Q7 - Ingresos totales por categoría (precio actual del curso)

## Q8 - Estudiantes inscritos por instructor

## Q9 - Integridad: inscripciones con estudiante inexistente

## Q10 - Integridad: inscripciones con curso inexistente
