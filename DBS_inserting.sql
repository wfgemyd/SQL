-- Insert data into `hospitals`.`department`
INSERT INTO hospitals.department (department_name, phone_num_extension) VALUES
('Cardiology', '1001'),
('Neurology', '1002'),
('Oncology', '1003'),
('Pediatrics', '1004'),
('General Medicine', '1234'),
('Orthopedics', '1005');

-- Insert data into `hospitals`.`doctor`
INSERT INTO hospitals.doctor (department_id, first_name, last_name, specialization, phone_num, address) VALUES
(1, 'John', 'Doe', 'Cardiologist', '555-0101', '123 Elm Street'),
(2, 'Jane', 'Smith', 'Neurologist', '555-0102', '456 Oak Avenue'),
(3, 'Emily', 'Jones', 'Oncologist', '555-0103', '789 Pine Boulevard'),
(4, 'William', 'Brown', 'Pediatrician', '555-0104', '321 Maple Drive'),
(5, 'Sarah', 'Davis', 'Orthopedist', '555-0105', '654 Cedar Lane');

-- Insert data into `hospitals`.`dutyshift`
INSERT INTO hospitals.dutyshift (doctor_id, department_id, start_time, end_time) VALUES
(1, 1, '08:00', '16:00'),
(2, 2, '09:00', '17:00'),
(3, 3, '10:00', '18:00'),
(4, 4, '11:00', '19:00'),
(5, 5, '12:00', '20:00');

-- Insert data into `hospitals`.`nurse`
-- Insert head nurses (no nurse_nurse_id, which means it's NULL)
INSERT INTO hospitals.nurse (first_name, last_name, is_chef) VALUES
('Alice', 'Headnurse', 'Yes'),
('Craig', 'Chiefnurse', 'Yes');

-- Insert other nurses with a nurse_nurse_id (assuming Alice got nurse_id 1 and Craig got nurse_id 2)
INSERT INTO hospitals.nurse (nurse_nurse_id, first_name, last_name, is_chef) VALUES
(1, 'Bob', 'Undernurse', 'No'),
(1, 'Charlie', 'Assistnurse', 'No'),
(2, 'Diana', 'Helpnurse', 'No'),
(2, 'Eva', 'Aidnurse', 'No');

-- Insert data into `hospitals`.`room`
-- Insert multiple rooms
INSERT INTO hospitals.room (department_id, is_vip, occupancy) VALUES
(1, FALSE, 1),
(2, FALSE, 2),
(2, TRUE, 1),  -- VIP room with allowed occupancy
(3, FALSE, 2),
(4, TRUE, 1),  -- Another VIP room with allowed occupancy
(5, TRUE, 1);  -- A third VIP room with allowed occupancy


-- Insert data into `hospitals`.`patient`
INSERT INTO hospitals.patient (room_id, first_name, last_name, dob, gender, address) VALUES
(1, 'Gary', 'Wilson', '1985-07-12', 'Male', '123 Birch Street'),
(2, 'Hannah', 'Clark', '1990-05-16', 'Female', '234 Cedar Road'),
(3, 'Ian', 'Rodriguez', '1978-11-22', 'Male', '345 Elm Avenue'),
(4, 'Julia', 'Lopez', '2002-03-30', 'Female', '456 Pine Lane'),
(5, 'Kyle', 'Garcia', '1966-01-19', 'Male', '567 Maple Parkway');

-- Insert data into `hospitals`.`prescription`
INSERT INTO hospitals.prescription (doctor_id, patient_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert data into `hospitals`.`treatment`
-- Assuming a valid nurse_id and prescription_id from previous inserts
INSERT INTO hospitals.treatment (nurse_id, prescription_id, treatment_description) VALUES
(1, 1, 'Blood Pressure Monitoring'),
(2, 2, 'Medication Administration'),
(3, 3, 'Chemotherapy'),
(4, 4, 'Routine Checkup'),
(5, 5, 'Orthopedic Surgery');

-- Insert data into `hospitals`.`visitor`
INSERT INTO hospitals.visitor (patient_id, first_name, last_name, relation, visit_date_and_time) VALUES
(1, 'Laura', 'Moore', 'Sister', '2023-07-01 10:00'),
(2, 'Mark', 'White', 'Brother', '2023-07-02 11:00'),
(3, 'Nancy', 'Hall', 'Mother', '2023-07-03 12:00'),
(4, 'Oscar', 'Young', 'Father', '2023-07-04 13:00'),
(5, 'Patricia', 'King', 'Daughter', '2023-07-05 14:00');