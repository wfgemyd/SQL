-- Query 1
SELECT * FROM hospitals.doctor NATURAL JOIN hospitals.department;

-- Query 2
SELECT * FROM hospitals.nurse NATURAL JOIN hospitals.treatment;

-- Query 3
SELECT * FROM hospitals.patient NATURAL JOIN hospitals.room;

-- Query 4
SELECT * FROM hospitals.doctor NATURAL JOIN hospitals.dutyshift;

-- Query 5
SELECT * FROM hospitals.prescription NATURAL JOIN hospitals.patient;

-- Query 6
SELECT * FROM hospitals.prescription NATURAL JOIN hospitals.doctor;

-- Query 7
SELECT * FROM hospitals.visitor NATURAL JOIN hospitals.patient;

-- Query 8
SELECT * FROM hospitals.treatment NATURAL JOIN hospitals.prescription;

-- Query 9
SELECT * FROM hospitals.doctor NATURAL JOIN hospitals.prescription NATURAL JOIN hospitals.patient;

-- Query 10
SELECT * FROM hospitals.dutyshift NATURAL JOIN hospitals.department NATURAL JOIN hospitals.doctor;

-- Query 11
SELECT * FROM hospitals.nurse NATURAL JOIN hospitals.room;

-- Query 12
SELECT * FROM hospitals.department NATURAL JOIN hospitals.room;

-- Query 13
SELECT * FROM hospitals.patient NATURAL JOIN hospitals.prescription;

-- Query 14
SELECT * FROM hospitals.visitor NATURAL JOIN hospitals.doctor;

-- Query 15
SELECT * FROM hospitals.nurse NATURAL JOIN hospitals.patient;

-- Query 16
SELECT * FROM hospitals.doctor NATURAL JOIN hospitals.treatment;

-- Query 17
SELECT * FROM hospitals.room NATURAL JOIN hospitals.treatment;

-- Query 18
SELECT * FROM hospitals.department NATURAL JOIN hospitals.treatment;

-- Query 19
SELECT * FROM hospitals.prescription NATURAL JOIN hospitals.room;

-- Query 20
SELECT * FROM hospitals.visitor NATURAL JOIN hospitals.treatment;

-- Query 21
SELECT * FROM hospitals.nurse NATURAL JOIN hospitals.visitor;

-- Query 22
SELECT * FROM hospitals.department NATURAL JOIN hospitals.visitor;

-- Query 23
SELECT * FROM hospitals.patient NATURAL JOIN hospitals.treatment;

-- Query 24
SELECT * FROM hospitals.dutyshift NATURAL JOIN hospitals.patient;

-- Query 25
SELECT * FROM hospitals.doctor NATURAL JOIN hospitals.visitor;
