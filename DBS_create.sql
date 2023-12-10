-- -----------------------------------------------------
-- Schema hospital
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS hospitals;

-- -----------------------------------------------------
-- Table `hospitals`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hospitals.department (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(256) NOT NULL,
    phone_num_extension VARCHAR(256) NOT NULL
);

-- -----------------------------------------------------
-- Table `hospitals`.`doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hospitals.doctor (
    doctor_id SERIAL PRIMARY KEY,
    department_id INTEGER NOT NULL REFERENCES hospitals.department(department_id) ON DELETE CASCADE,
    first_name VARCHAR(256) NOT NULL,
    last_name VARCHAR(256) NOT NULL,
    specialization VARCHAR(256) NOT NULL,
    phone_num VARCHAR(256) NOT NULL,
    address VARCHAR(256) NOT NULL
);

-- -----------------------------------------------------
-- Table `hospitals`.`dutyshift`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hospitals.dutyshift (
    shift_id SERIAL PRIMARY KEY,
    doctor_id INTEGER NOT NULL REFERENCES hospitals.doctor(doctor_id) ON DELETE CASCADE,
    department_id INTEGER NOT NULL REFERENCES hospitals.department(department_id) ON DELETE CASCADE,
    start_time VARCHAR(256) NOT NULL,
    end_time VARCHAR(256) NOT NULL
);

-- -----------------------------------------------------
-- Table `hospitals`.`nurse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hospitals.nurse (
    nurse_id SERIAL PRIMARY KEY,
    first_name VARCHAR(256) NOT NULL,
    last_name VARCHAR(256) NOT NULL,
    is_chef VARCHAR(256) NOT NULL,
    nurse_nurse_id INTEGER,
    CONSTRAINT fk_nurse_nurse FOREIGN KEY (nurse_nurse_id) REFERENCES hospitals.nurse(nurse_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table `hospitals`.`room`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hospitals.room (
    room_id SERIAL PRIMARY KEY,
    department_id INTEGER NOT NULL REFERENCES hospitals.department(department_id) ON DELETE CASCADE,
    is_vip BOOLEAN NOT NULL DEFAULT FALSE,  -- Assuming FALSE as default for is_vip
    occupancy INTEGER NOT NULL,
    CHECK ((is_vip = TRUE AND occupancy <= 1) OR (is_vip = FALSE)), -- Ensuring proper check for VIP room
    CHECK ((occupancy <= 6 AND is_vip = FALSE) OR (is_vip = TRUE)) -- Ensuring occupancy does not exceed 6 for non-VIP rooms
);


-- -----------------------------------------------------
-- Table `hospitals`.`patient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hospitals.patient (
    patient_id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES hospitals.room(room_id) ON DELETE CASCADE,
    first_name VARCHAR(256) NOT NULL,
    last_name VARCHAR(256) NOT NULL,
    dob VARCHAR(256) NOT NULL,
    gender VARCHAR(256) NOT NULL,
    address VARCHAR(256) NOT NULL
);

-- -----------------------------------------------------
-- Table `hospitals`.`prescription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hospitals.prescription (
    prescription_id SERIAL PRIMARY KEY,
    doctor_id INTEGER NOT NULL REFERENCES hospitals.doctor(doctor_id) ON DELETE CASCADE,
    patient_id INTEGER NOT NULL REFERENCES hospitals.patient(patient_id) ON DELETE CASCADE
);


-- -----------------------------------------------------
-- Table `hospitals`.`treatment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hospitals.treatment (
    nurse_id INTEGER NOT NULL REFERENCES hospitals.nurse(nurse_id) ON DELETE CASCADE,
    prescription_id INTEGER NOT NULL REFERENCES hospitals.prescription(prescription_id) ON DELETE CASCADE,
    treatment_description VARCHAR(256) NOT NULL,
    PRIMARY KEY (nurse_id, prescription_id)
);

-- -----------------------------------------------------
-- Table `hospitals`.`visitor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS hospitals.visitor (
    visitor_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES hospitals.patient(patient_id) ON DELETE CASCADE,
    first_name VARCHAR(256) NOT NULL,
    last_name VARCHAR(256) NOT NULL,
    relation VARCHAR(256) NOT NULL,
    visit_date_and_time VARCHAR(256) NOT NULL
);


-- view that combines doctor and department information
CREATE VIEW view_doctor_department AS
SELECT d.doctor_id, d.first_name, d.last_name, d.specialization, dp.department_name
FROM hospitals.doctor d
JOIN hospitals.department dp ON d.department_id = dp.department_id;



