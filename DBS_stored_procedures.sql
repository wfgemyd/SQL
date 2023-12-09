
-- Create Stored procedure to Get all Data
CREATE OR REPLACE FUNCTION get_all_patient()
RETURNS TABLE (
    patient_id INTEGER,
    room_id INTEGER,
    first_name VARCHAR(256),
    last_name VARCHAR(256),
    dob VARCHAR(256),
    gender VARCHAR(256),
    address VARCHAR(256)
)
AS $$
BEGIN
    RETURN QUERY SELECT * FROM hospitals.patient;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_all_patient();

--DROP FUNCTION get_treatment(INT);

-- Create Stored procedure to get treatment detail
CREATE OR REPLACE FUNCTION get_treatment(p_patient_id INT)
RETURNS TABLE (
    r_nurse_id INTEGER,
    r_prescription_id INTEGER,
    r_treatment_description VARCHAR(256)
)
AS $$
BEGIN
    RETURN QUERY SELECT t.nurse_id AS r_nurse_id, t.prescription_id AS r_prescription_id, t.treatment_description AS r_treatment_description
    FROM hospitals.treatment t
    JOIN hospitals.prescription p ON t.prescription_id = p.prescription_id
    JOIN hospitals.patient pt ON p.patient_id = pt.patient_id
    WHERE pt.patient_id = p_patient_id;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_treatment(1);

-- Create Stored procedure to Get Sorted Data
CREATE OR REPLACE FUNCTION sort_patient_by_room()
RETURNS TABLE (
    patient_id INTEGER,
    room_id INTEGER,
    first_name VARCHAR(256),
    last_name VARCHAR(256),
    dob VARCHAR(256),
    gender VARCHAR(256),
    address VARCHAR(256)
)
AS $$
BEGIN
    RETURN QUERY SELECT * FROM hospitals.patient
    ORDER BY room_id;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM sort_patient_by_room();

-- Create Stored procedure to Get Doctors with specific fields
CREATE OR REPLACE FUNCTION get_doctors()
RETURNS TABLE (
    doctor_id INTEGER,
    first_name VARCHAR(256),
    last_name VARCHAR(256)
)
AS $$
BEGIN
    RETURN QUERY SELECT d.doctor_id, d.first_name, d.last_name FROM hospitals.doctor d;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_doctors();

-- Create Stored procedure to Count Patients in Standard Rooms
CREATE OR REPLACE FUNCTION count_patient_in_standard_room()
RETURNS INTEGER
AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM hospitals.patient WHERE room_id IN (SELECT room_id FROM hospitals.room WHERE is_vip = FALSE));
END;
$$ LANGUAGE plpgsql;
SELECT count_patient_in_standard_room();

