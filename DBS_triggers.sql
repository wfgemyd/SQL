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
    ) > 6 THEN
        RAISE EXCEPTION 'Error in room: Max of 6 patients allowed in Standard Room.';
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

-- Trigger to ensure there is always a doctor on duty for each department
CREATE OR REPLACE FUNCTION ensure_doctor_on_duty()
RETURNS TRIGGER
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM hospitals.dutyshift AS ds
        WHERE ds.department_id = NEW.department_id
        AND ds.start_time <= NEW.end_time
        AND ds.end_time >= NEW.start_time
    ) THEN
        RAISE EXCEPTION 'Alert in dutyshift: No doctor assigned for the specified department during this time slot.';
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

