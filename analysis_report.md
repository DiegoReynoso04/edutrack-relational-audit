# EduTrack v2 — Informe de auditoría sobre el esquema normalizado

Consultas ejecutadas en Supabase sobre `edutrack_v2.sql` (8 estudiantes, 7 cursos, 16 inscripciones).
Todas las consultas usan al menos un JOIN y ninguna subconsulta. El diagrama entidad-relación está en [`diagram.png`](diagram.png).

## Modelo de datos

- `students` (PK `id`) 1 — n `enrollments` (FK `student_id`)
- `courses` (PK `id`) 1 — n `enrollments` (FK `course_id`)
- `students` n — m `courses`, a través de la tabla intermedia `enrollments`

## Q1 - Inscripciones con estudiante, curso y porcentaje de completado

Resultado: 16

| id | student_name    | course_title           | completion_percentage |
| -- | --------------- | ---------------------- | --------------------- |
| 1  | Emily Watson    | Intro to Python        | 85                    |
| 2  | Emily Watson    | Web Design Basics      | 60                    |
| 3  | Klaus Weber     | Intro to Python        | 92                    |
| 4  | Klaus Weber     | Data Analysis with SQL | 78                    |
| 5  | Lucia Fernandes | Web Design Basics      | 5                     |
| 6  | Lucia Fernandes | Digital Marketing 101  | 3                     |
| 7  | Marco Rossi     | Advanced Python        | 95                    |
| 8  | Marco Rossi     | Intro to Python        | 88                    |
| 9  | Yuki Nakamura   | Data Analysis with SQL | 45                    |
| 10 | Yuki Nakamura   | UI/UX Fundamentals     | 0                     |
| 11 | Pierre Dubois   | UI/UX Fundamentals     | 0                     |
| 12 | Priya Sharma    | Digital Marketing 101  | 70                    |
| 13 | Priya Sharma    | Intro to Python        | 55                    |
| 14 | Pierre Dubois   | Data Analysis with SQL | 20                    |
| 15 | Emily Watson    | Advanced Python        | 40                    |
| 16 | Lucia Fernandes | Advanced Python        | 0                     |

Observaciones:

- Las 16 inscripciones tienen un estudiante y un curso existentes: el INNER JOIN no descarta ninguna fila (lo confirman Q9 y Q10).
- Giulia Romano y Email Campaigns no aparecen porque no tienen inscripciones; el INNER JOIN solo devuelve filas con coincidencia en ambas tablas (ver Q4 y Q5).


## Q2 - Estudiantes que han aprobado al menos un curso

Resultado: 6 cursos aprobados por 4 estudiantes distintos

| student_name | student_email                     | course_title           |
| ------------ | --------------------------------- | ---------------------- |
| Emily Watson | emily.watson@student.edutrack.com | Intro to Python        |
| Klaus Weber  | klaus.weber@student.edutrack.com  | Data Analysis with SQL |
| Klaus Weber  | klaus.weber@student.edutrack.com  | Intro to Python        |
| Marco Rossi  | marco.rossi@student.edutrack.com  | Advanced Python        |
| Marco Rossi  | marco.rossi@student.edutrack.com  | Intro to Python        |
| Priya Sharma | priya.sharma@student.edutrack.com | Digital Marketing 101  |

Observaciones:

- Solo 4 de los 8 estudiantes han aprobado algún curso. Klaus Weber y Marco Rossi han aprobado dos cada uno.
- Intro to Python acumula 3 de los 6 aprobados.
- Lucia Fernandes, Yuki Nakamura y Pierre Dubois no han aprobado ningún curso, a pesar de tener 3, 2 y 2 inscripciones respectivamente.


## Q3 - Porcentaje de completado medio por instructor

Resultado (de mayor a menor):

| instructor_name    | promedio_completado |
| ------------------ | ------------------- |
| Marta López        | 66.14               |
| Carlos Vega        | 40.00               |
| Lucia Prades       | 36.50               |
| Pending assignment | 0.00                |

Observaciones:

- Marta López tiene el mejor promedio (7 inscripciones entre Intro to Python y Data Analysis with SQL).
- El promedio de Carlos Vega (5 inscripciones) baja por Web Design Basics y por la inscripción de Lucia Fernandes en Advanced Python, que está al 0 %.
- El promedio de Lucia Prades se calcula solo con Digital Marketing 101 (2 inscripciones): su otro curso, Email Campaigns, no tiene inscripciones y no entra en el INNER JOIN.
- `Pending assignment` no es un instructor real: corresponde a UI/UX Fundamentals, cuyas dos inscripciones están al 0 %.


## Q4 - Estudiantes sin ninguna inscripción

Resultado: 1

| id | name          | email                              | signup_date |
| -- | ------------- | ---------------------------------- | ----------- |
| 8  | Giulia Romano | giulia.romano@student.edutrack.com | 2024-05-07  |

Observaciones:

- Giulia Romano se registró el 2024-05-07 y nunca se ha inscrito en ningún curso.
- Es 1 de los 8 estudiantes registrados (12,5 %): una candidata clara para una campaña de activación.
- Con un INNER JOIN esta estudiante no aparecería nunca; solo el LEFT JOIN muestra las filas de `students` sin pareja en `enrollments`.


## Q5 - Cursos sin ninguna inscripción

Resultado: 1

| id | title           | category  | instructor_name | monthly_fee |
| -- | --------------- | --------- | --------------- | ----------- |
| 7  | Email Campaigns | Marketing | Lucia Prades    | 19.99       |

Observaciones:

- Email Campaigns (Marketing, 19.99 al mes) no tiene ninguna inscripción: es el candidato a archivar que mencionaba Operaciones.
- Es el curso más barato del catálogo y su instructora, Lucia Prades, también imparte Digital Marketing 101, que sí tiene inscripciones (2).
- Antes de archivarlo convendría revisar si se ha llegado a promocionar, ya que Marketing es la categoría con menos inscripciones.


## Q6 - Estudiantes inscritos en más de un curso

Resultado: 7

| id | name            | cursos_inscritos |
| -- | --------------- | ---------------- |
| 1  | Emily Watson    | 3                |
| 3  | Lucia Fernandes | 3                |
| 2  | Klaus Weber     | 2                |
| 4  | Marco Rossi     | 2                |
| 6  | Pierre Dubois   | 2                |
| 7  | Priya Sharma    | 2                |
| 5  | Yuki Nakamura   | 2                |

Observaciones:

- 7 de los 8 estudiantes están inscritos en más de un curso; la única excepción es Giulia Romano, que no tiene ninguno (Q4).
- Emily Watson y Lucia Fernandes tienen 3 cursos cada una. Lucia, sin embargo, no ha aprobado ninguno y tiene un progreso muy bajo en todos (5 %, 3 % y 0 %).
- El filtro por número de cursos se hace con `HAVING`, porque se aplica sobre el resultado del `COUNT` y no sobre filas individuales.


## Q7 - Ingresos totales por categoría (precio actual del curso)

Resultado (de mayor a menor):

| category    | inscripciones | ingresos_totales |
| ----------- | ------------- | ---------------- |
| Programming | 7             | 409.93           |
| Data        | 3             | 179.97           |
| Design      | 4             | 169.96           |
| Marketing   | 2             | 59.98            |

Total: 819.84

Observaciones:

- **Programming es la categoría que más ingresos genera** (409.93, la mitad del total): tiene más inscripciones (7) y el curso más caro (Advanced Python, 69.99).
- Los ingresos se calculan con el precio actual de `courses.monthly_fee`, una vez por inscripción. En estos datos coinciden con la suma del pago histórico (`enrollments.monthly_fee_paid`), porque ningún precio ha cambiado desde la inscripción.
- Data ingresa más que Design con menos inscripciones (3 frente a 4), por el precio más alto de Data Analysis with SQL (59.99).
- Email Campaigns no suma ingresos porque no tiene inscripciones (Q5).


## Q8 - Estudiantes inscritos por instructor

Resultado:

| instructor_name    | estudiantes_inscritos | inscripciones |
| ------------------ | --------------------- | ------------- |
| Marta López        | 6                     | 7             |
| Carlos Vega        | 3                     | 5             |
| Lucia Prades       | 2                     | 2             |
| Pending assignment | 2                     | 2             |

Observaciones:

- Marta López atiende a 6 de los 7 estudiantes activos. Klaus Weber está en sus dos cursos, por eso hay 7 inscripciones pero 6 estudiantes distintos.
- Carlos Vega tiene 5 inscripciones pero solo 3 estudiantes: Emily Watson y Lucia Fernandes están en sus dos cursos.
- Las 2 inscripciones de `Pending assignment` (UI/UX Fundamentals) siguen sin un instructor real.
- Se usa `LEFT JOIN` desde `courses` para que un instructor sin inscripciones aparezca con 0; en estos datos todos tienen al menos una.


## Q9 - Integridad: inscripciones con estudiante inexistente

Resultado: 0 (ninguna inscripción huérfana)

La consulta no devuelve filas: todas las inscripciones tienen un `student_id` que corresponde a un estudiante existente.

Observaciones:

- El resultado es el esperado: la columna `enrollments.student_id` tiene una clave foránea (`REFERENCES students(id)`), así que la base de datos rechaza cualquier inscripción con un estudiante que no exista.
- La consulta sigue siendo útil como control periódico, por ejemplo si en el futuro se importan datos sin esa restricción.


## Q10 - Integridad: inscripciones con curso inexistente

Resultado: 0 (ninguna inscripción huérfana)

La consulta no devuelve filas: todas las inscripciones tienen un `course_id` que corresponde a un curso existente.

Observaciones:

- Igual que en Q9, la clave foránea `REFERENCES courses(id)` impide que exista una inscripción con un curso inexistente.
- Junto con Q9, confirma que el INNER JOIN de Q1 no descarta ninguna inscripción: las 16 tienen estudiante y curso válidos.

---

## Resumen para el equipo de Operaciones

| Pregunta | Respuesta |
| -------- | --------- |
| ¿Qué estudiantes están inscritos en más de un curso? | 7 de 8: Emily Watson y Lucia Fernandes (3 cursos); Klaus Weber, Marco Rossi, Pierre Dubois, Priya Sharma y Yuki Nakamura (2) (Q6). |
| ¿Qué cursos no tienen ninguna inscripción? | Email Campaigns (Marketing, Lucia Prades, 19.99) (Q5). |
| ¿Porcentaje de completado medio por instructor? | Marta López 66.14 · Carlos Vega 40.00 · Lucia Prades 36.50 · Pending assignment 0.00 (Q3). |
| ¿Qué estudiantes han aprobado al menos un curso? | 4: Emily Watson, Klaus Weber, Marco Rossi y Priya Sharma, con 6 cursos aprobados en total (Q2). |
| ¿Hay inscripciones vinculadas a estudiantes o cursos inexistentes? | No. 0 huérfanas en ambos casos; las claves foráneas lo garantizan (Q9, Q10). |
| ¿Qué categoría genera más ingresos con el precio actual? | Programming, con 409.93 de 819.84 en total (Q7). |

Otros hallazgos:

- Giulia Romano está registrada pero no tiene ninguna inscripción (Q4).
- UI/UX Fundamentals sigue sin instructor real (`Pending assignment`) y sus 2 estudiantes están al 0 % (Q3, Q8).
- Lucia Fernandes está inscrita en 3 cursos sin haber aprobado ninguno y con un progreso muy bajo en todos (Q1, Q6).

Acciones recomendadas:

1. Decidir si se archiva Email Campaigns o se promociona antes, dado que Marketing es la categoría con menos inscripciones.
2. Asignar un instructor real a UI/UX Fundamentals.
3. Contactar con Giulia Romano (activación) y con Lucia Fernandes (riesgo de abandono).
