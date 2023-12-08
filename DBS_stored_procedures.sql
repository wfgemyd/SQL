
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

-- Create Stored procedure to get treatment detail
CREATE OR REPLACE FUNCTION get_treatment(patient_id INT)
RETURNS TABLE (
    nurse_id INTEGER,
    prescription_id INTEGER,
    treatment_description VARCHAR(256)
)
AS $$
BEGIN
    RETURN QUERY SELECT nurse_id, prescription_id, treatment_description
    FROM hospitals.treatment
    WHERE patient_id = patient_id;
END;
$$ LANGUAGE plpgsql;

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

-- Create Stored procedure to Get Doctors with specific fields
CREATE OR REPLACE FUNCTION get_doctors()
RETURNS TABLE (
    doctor_id INTEGER,
    first_name VARCHAR(256),
    last_name VARCHAR(256)
)
AS $$
BEGIN
    RETURN QUERY SELECT doctor_id, first_name, last_name FROM hospitals.doctor;
END;
$$ LANGUAGE plpgsql;

-- Create Stored procedure to Count Patients in Standard Room
CREATE OR REPLACE FUNCTION count_patient_in_standard_room()
RETURNS INTEGER
AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM hospitals.patient WHERE room_id IN (SELECT room_id FROM hospitals.room WHERE is_vip = FALSE));
END;
$$ LANGUAGE plpgsql;
