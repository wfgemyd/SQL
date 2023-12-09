-- Create Triggers

-- Check Patient In Standard Room
CREATE OR REPLACE FUNCTION check_patient_in_standard_room()
RETURNS TRIGGER
AS $$
BEGIN
    IF (
        SELECT COUNT(*) as total_patient
        FROM hospitals.patient AS p
        JOIN hospitals.room AS r
        ON p.room_id = r.room_id
        WHERE p.room_id = NEW.room_id AND r.is_vip = FALSE
    ) >= 6 THEN
        RAISE EXCEPTION 'Error in room: Max of 6 patients allowed in Standard Room.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop the existing trigger if it exists
DROP TRIGGER IF EXISTS trg_check_patient_in_standard_room ON hospitals.patient;

-- Create the new trigger
CREATE TRIGGER trg_check_patient_in_standard_room
BEFORE INSERT ON hospitals.patient
FOR EACH ROW
EXECUTE FUNCTION check_patient_in_standard_room();


INSERT INTO hospitals.patient (room_id, first_name, last_name, dob, gender, address) VALUES
(4, 'Test', 'Patient', '2000-01-01', 'M', '123 Test Address'),
(4, 'Gary', 'Wilson', '1985-07-12', 'Male', '123 Birch Street'),
(4, 'Hannah', 'Clark', '1990-05-16', 'Female', '234 Cedar Road'),
(4, 'Ian', 'Rodriguez', '1978-11-22', 'Male', '345 Elm Avenue'),
(4, 'Julia', 'Lopez', '2002-03-30', 'Female', '456 Pine Lane');


-- Trigger to prevent changing a room to VIP if it already has occupants
CREATE OR REPLACE FUNCTION prevent_change_to_vip()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.is_vip = TRUE AND (SELECT COUNT(*) FROM hospitals.patient WHERE room_id = NEW.room_id) > 0 THEN
        RAISE EXCEPTION 'Error is room: Cannot change room to VIP; it already has occupants.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop the existing trigger if it exists
DROP TRIGGER IF EXISTS prevent_change_to_vip ON hospitals.room;

-- Create the new trigger
CREATE TRIGGER prevent_change_to_vip
BEFORE UPDATE ON hospitals.room
FOR EACH ROW
WHEN (NEW.is_vip <> OLD.is_vip)
EXECUTE FUNCTION prevent_change_to_vip();

UPDATE hospitals.room
SET is_vip = TRUE
WHERE room_id = 2 AND is_vip = FALSE;

-- Check Patient In VIP Room
CREATE OR REPLACE FUNCTION check_patient_in_vip_room()
RETURNS TRIGGER
AS $$
BEGIN
    IF (
        SELECT COUNT(*) as total_patient
        FROM hospitals.patient AS p
        JOIN hospitals.room AS r
        ON p.room_id = r.room_id
        WHERE p.room_id = NEW.room_id AND r.is_vip = TRUE
    ) >= 1 THEN
        RAISE EXCEPTION 'Error in room: Only one patient allowed in VIP Room.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop the existing trigger if it exists
DROP TRIGGER IF EXISTS check_patient_in_vip_room ON hospitals.patient;

-- Create the new trigger
CREATE TRIGGER check_patient_in_vip_room
BEFORE INSERT ON hospitals.patient
FOR EACH ROW
EXECUTE FUNCTION check_patient_in_vip_room();

INSERT INTO hospitals.patient (room_id, first_name, last_name, dob, gender, address)
VALUES (3, 'Test', 'Patient', '2000-01-01', 'M', '123 Test Address');


ALTER TABLE hospitals.dutyshift
ALTER COLUMN start_time TYPE TIME USING start_time::TIME,
ALTER COLUMN end_time TYPE TIME USING end_time::TIME;


-- Trigger to ensure there is always a doctor on duty for each department
CREATE OR REPLACE FUNCTION ensure_doctor_on_duty()
RETURNS TRIGGER
AS $$
BEGIN
    -- Check for any overlapping shift
    IF EXISTS (
        SELECT 1
        FROM hospitals.dutyshift AS ds
        WHERE ds.department_id = NEW.department_id
        AND (
           (NEW.start_time < ds.end_time AND NEW.end_time > ds.start_time) -- Overlaps
           OR (NEW.start_time = ds.start_time AND NEW.end_time = ds.end_time) -- Same as another shift
        )
    ) THEN
        RAISE EXCEPTION 'Alert in dutyshift: Doctor assigned overlaps with another duty shift for the specified department.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop the existing trigger if it exists
DROP TRIGGER IF EXISTS ensure_doctor_on_duty_trigger ON hospitals.dutyshift;

-- Create the new trigger
CREATE TRIGGER ensure_doctor_on_duty_trigger
BEFORE INSERT ON hospitals.dutyshift
FOR EACH ROW
EXECUTE FUNCTION ensure_doctor_on_duty();

INSERT INTO hospitals.dutyshift (doctor_id, department_id, start_time, end_time)
VALUES (1, 1, '09:00', '11:00');

