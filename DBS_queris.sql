--A Select doctors and their department names
SELECT d.first_name, d.last_name, dp.department_name
FROM hospitals.doctor d
JOIN hospitals.department dp ON d.department_id = dp.department_id;

--B Select doctors who are not assigned to any duty shift
SELECT d.first_name, d.last_name
FROM hospitals.doctor d
LEFT JOIN hospitals.dutyshift ds ON d.doctor_id = ds.doctor_id
WHERE ds.shift_id IS NULL;

--C Select patients in VIP rooms
SELECT p.first_name, p.last_name
FROM hospitals.patient p
JOIN hospitals.room r ON p.room_id = r.room_id
WHERE r.is_vip = TRUE;

--D1ra Select departments where all doctors specialize in 'Cardiology'
-- Insert a Cardiologist in the Cardiology department
INSERT INTO hospitals.doctor (department_id, first_name, last_name, specialization, phone_num, address)
VALUES ((SELECT department_id FROM hospitals.department WHERE department_name = 'Cardiology'), 'John', 'Doe', 'Cardiologist', '555-0101', '123 Heart St');

-- Insert another Cardiologist in the Cardiology department
INSERT INTO hospitals.doctor (department_id, first_name, last_name, specialization, phone_num, address)
VALUES ((SELECT department_id FROM hospitals.department WHERE department_name = 'Cardiology'), 'Jane', 'Roe', 'Cardiologist', '555-0102', '124 Heart St');

-- Select departments where all doctors have the specialization 'Cardiology'
SELECT DISTINCT dp.department_name
FROM hospitals.department dp
WHERE NOT EXISTS (
    SELECT *
    FROM hospitals.doctor d
    WHERE d.department_id = dp.department_id AND d.specialization <> 'Cardiologist'
);

--F1 Join patients with their assigned rooms
SELECT p.first_name, p.last_name, r.room_id
FROM hospitals.patient p
JOIN hospitals.room r ON p.room_id = r.room_id;

--F2 Natural join between doctor and prescription using doctor_id
SELECT *
FROM hospitals.doctor
NATURAL JOIN hospitals.prescription;

--F3 Cross join between nurses and doctors
SELECT n.first_name AS nurse_name, d.first_name AS doctor_name
FROM hospitals.nurse n
CROSS JOIN hospitals.doctor d;

--F4 Find all doctors and their possible duty shifts (including those without a shift)
SELECT d.first_name, d.last_name, ds.shift_id
FROM hospitals.doctor d
LEFT JOIN hospitals.dutyshift ds ON d.doctor_id = ds.doctor_id;

--F5 Full outer join between nurses and treatments
SELECT n.first_name, t.treatment_description
FROM hospitals.nurse n
FULL OUTER JOIN hospitals.treatment t ON n.nurse_id = t.nurse_id;

--G1 Select doctors who have prescribed more than 5 prescriptions
-- Insert 6 prescriptions for John Doe (assuming his doctor_id is 1 and patient_id's exist)
INSERT INTO hospitals.prescription (doctor_id, patient_id)
VALUES (1, 1), (1, 1), (1, 1), (1, 1), (1, 1), (1, 1);

SELECT d.first_name, d.last_name
FROM hospitals.doctor d
WHERE d.doctor_id IN (
    SELECT p.doctor_id
    FROM hospitals.prescription p
    GROUP BY p.doctor_id
    HAVING COUNT(p.prescription_id) > 5
);

--G2 List of departments with the count of their doctors
SELECT dp.department_name, COUNT(d.doctor_id) AS doctor_count
FROM hospitals.department dp
JOIN (
    SELECT doctor_id, department_id
    FROM hospitals.doctor
) d ON dp.department_id = d.department_id
GROUP BY dp.department_name;

--G3 Select patient names along with the count of their visits
SELECT p.first_name, p.last_name,
(SELECT COUNT(v.visitor_id)
 FROM hospitals.visitor v
 WHERE v.patient_id = p.patient_id) AS visit_count
FROM hospitals.patient p;

--G4 Select patients who have not been visited
INSERT INTO hospitals.patient (room_id, first_name, last_name, dob, gender, address)
VALUES (1, 'John', 'Doe', '1980-01-01', 'Male', '123 Main Street');
INSERT INTO hospitals.visitor (patient_id, first_name, last_name, relation, visit_date_and_time)
VALUES (NULL, 'John', 'Doe', 'Friend', '2023-03-15 14:00');
SELECT p.first_name, p.last_name
FROM hospitals.patient p
WHERE NOT EXISTS (
    SELECT *
    FROM hospitals.visitor v
    WHERE v.patient_id = p.patient_id
);

--H1 Combine names of all staff (doctors and nurses)
SELECT first_name, last_name
FROM hospitals.doctor
UNION
SELECT first_name, last_name
FROM hospitals.nurse;

--H2 Select doctors who have never prescribed anything
SELECT first_name, last_name
FROM hospitals.doctor
EXCEPT
SELECT d.first_name, d.last_name
FROM hospitals.doctor d
JOIN hospitals.prescription p ON d.doctor_id = p.doctor_id;

--H3 Select patients who are both in a VIP room and have a prescription
SELECT p.first_name, p.last_name
FROM hospitals.patient p
JOIN hospitals.room r ON p.room_id = r.room_id
WHERE r.is_vip = TRUE
INTERSECT
SELECT pa.first_name, pa.last_name
FROM hospitals.patient pa
JOIN hospitals.prescription pr ON pa.patient_id = pr.patient_id;

--I1 Count the number of patients in each department
SELECT dp.department_name, COUNT(p.patient_id) AS patient_count
FROM hospitals.patient p
JOIN hospitals.room r ON p.room_id = r.room_id
JOIN hospitals.department dp ON r.department_id = dp.department_id
GROUP BY dp.department_name;

--I1 Find the average number of patients in each VIP and non-VIP room
SELECT is_vip, AVG(occupancy) AS average_occupancy
FROM hospitals.room
GROUP BY is_vip;

-- Insert a department
INSERT INTO hospitals.department (department_name, phone_num_extension)
VALUES ('Oncology', '4001');
INSERT INTO hospitals.room (department_id, is_vip, occupancy)
VALUES (7, FALSE, 2), (7, FALSE, 2), (7, FALSE, 2), (7, FALSE, 2), (7, FALSE, 2);
INSERT INTO hospitals.patient (room_id, first_name, last_name, dob, gender, address)
VALUES (7, 'Patient', 'One', '1980-01-01', 'Male', '123 Street'),
       (8, 'Patient', 'Two', '1981-02-02', 'Female', '124 Street'),
       (9, 'Patient', 'Three', '1982-03-03', 'Male', '125 Street'),
       (10, 'Patient', 'Four', '1983-04-04', 'Female', '126 Street'),
       (11, 'Patient', 'Five', '1984-05-05', 'Male', '127 Street'),
       (7, 'Patient', 'Six', '1985-06-06', 'Female', '128 Street'),
       (8, 'Patient', 'Seven', '1986-07-07', 'Male', '129 Street'),
       (9, 'Patient', 'Eight', '1987-08-08', 'Female', '130 Street'),
       (10, 'Patient', 'Nine', '1988-09-09', 'Male', '131 Street'),
       (11, 'Patient', 'Ten', '1989-10-10', 'Female', '132 Street'),
       (7, 'Patient', 'Eleven', '1990-11-11', 'Male', '133 Street');
--I2 List departments with more than 10 patients
SELECT dp.department_name
FROM hospitals.patient p
JOIN hospitals.room r ON p.room_id = r.room_id
JOIN hospitals.department dp ON r.department_id = dp.department_id
GROUP BY dp.department_name
HAVING COUNT(p.patient_id) > 10;

--K List departments, count of doctors, and their average number of prescriptions, ordered by the count of doctors
SELECT dp.department_name, COUNT(d.doctor_id) AS doctor_count, AVG(prescription_count) AS avg_prescriptions
FROM hospitals.department dp
JOIN hospitals.doctor d ON dp.department_id = d.department_id
LEFT JOIN (
    SELECT doctor_id, COUNT(prescription_id) AS prescription_count
    FROM hospitals.prescription
    GROUP BY doctor_id
) p ON d.doctor_id = p.doctor_id
GROUP BY dp.department_name
HAVING COUNT(d.doctor_id) > 5
ORDER BY COUNT(d.doctor_id);

--M Assuming a view 'view_doctor_department' that combines doctor and department information
SELECT *
FROM view_doctor_department
WHERE department_name = 'Cardiology';

--N Insert into prescription from a subquery
INSERT INTO hospitals.prescription (doctor_id, patient_id)
SELECT d.doctor_id, p.patient_id
FROM hospitals.doctor d, hospitals.patient p
WHERE d.specialization = 'Cardiologist' AND p.gender = 'Female';

INSERT INTO hospitals.treatment (nurse_id, prescription_id, treatment_description)
VALUES (6, 3, 'Chemotherapy');
SELECT * FROM hospitals.nurse;
--O Update nurse's chef status based on a subquery
UPDATE hospitals.nurse n
SET is_chef = 'Yes', nurse_nurse_id = NULL
WHERE EXISTS (
    SELECT *
    FROM hospitals.treatment t
    WHERE n.nurse_id = t.nurse_id AND t.treatment_description LIKE '%Chemotherapy%'
);

--O Update room occupancy for all non-VIP rooms to maximum capacity (6) if currently less than 3
UPDATE hospitals.room
SET occupancy = 6
WHERE is_vip = FALSE AND occupancy < 3;


--P Delete patients who have not been visited
DELETE FROM hospitals.patient
WHERE patient_id NOT IN (
    SELECT v.patient_id
    FROM hospitals.visitor v
);

--B(ra)

INSERT INTO hospitals.doctor (department_id, first_name, last_name, specialization, phone_num, address)
VALUES ((SELECT department_id FROM hospitals.department WHERE department_name = 'General Medicine'), 'Jane', 'Smith', 'General', '555-0202', '456 Elm Street');

SELECT d.first_name, d.last_name
FROM hospitals.doctor d
LEFT JOIN hospitals.dutyshift ds ON d.doctor_id = ds.doctor_id
WHERE ds.shift_id IS NULL;



-- Insert a Cardiologist in the Cardiology department
INSERT INTO hospitals.doctor (department_id, first_name, last_name, specialization, phone_num, address)
VALUES ((SELECT department_id FROM hospitals.department WHERE department_name = 'Cardiology'), 'John', 'Doe', 'Cardiologist', '555-0101', '123 Heart St');

-- Insert another Cardiologist in the Cardiology department
INSERT INTO hospitals.doctor (department_id, first_name, last_name, specialization, phone_num, address)
VALUES ((SELECT department_id FROM hospitals.department WHERE department_name = 'Cardiology'), 'Jane', 'Roe', 'Cardiologist', '555-0102', '124 Heart St');

-- Select departments where all doctors have the specialization 'Cardiology'
SELECT DISTINCT dp.department_name
FROM hospitals.department dp
WHERE NOT EXISTS (
    SELECT *
    FROM hospitals.doctor d
    WHERE d.department_id = dp.department_id AND d.specialization <> 'Cardiologist'
);

--K List departments along with the number of doctors in each,
-- the average number of prescriptions they've written,
-- only include departments with more than 2 doctors,
-- and order by the total number of prescriptions in descending order
SELECT
    dp.department_name,
    COUNT(d.doctor_id) AS number_of_doctors,
    AVG(sub.prescription_count) AS avg_prescriptions
FROM
    hospitals.department dp
JOIN
    hospitals.doctor d ON dp.department_id = d.department_id
LEFT JOIN
    (SELECT doctor_id, COUNT(*) AS prescription_count
     FROM hospitals.prescription
     GROUP BY doctor_id) sub ON d.doctor_id = sub.doctor_id
GROUP BY
    dp.department_name
HAVING
    COUNT(d.doctor_id) > 2
ORDER BY
    SUM(sub.prescription_count) DESC;
