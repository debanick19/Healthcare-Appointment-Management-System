--  "Healthcare Appointment Management System" --

create database MyHospital;
use MyHospital;


-- Project Overview--
-- Title: Healthcare Appointment Management System
-- Objective: To provide a database-backed system for managing doctor appointments, reducing scheduling conflicts, and ensuring efficient resource utilization in healthcare facilities.

-- Features--
-- Patient Records: Manage patient profiles with contact information and medical history.
-- Doctor Details: Store doctor availability, specialties, and contact information.
-- Appointment Booking: Track scheduled appointments, cancellations, and no-shows.
-- Hospital Resources: Manage availability of hospital rooms, lab equipment, or diagnostic slots.
-- Feedback System: Allow patients to provide feedback on their experience, ensuring quality monitoring.

-- 1.Querying Patients--
-- Retrieve the names and ages of patients who have scheduled appointments in 2023 with a doctor specializing in "Cardiology":
SELECT DISTINCT p.name, p.age
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE d.specialty = 'Cardiology' AND YEAR(a.date) = 2023;


-- 2. Doctor Specializations
-- List the number of appointments handled by each doctor, grouped by their specialization--
SELECT d.specialty, d.name AS doctor_name, COUNT(a.appointment_id) AS appointment_count
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.specialty, d.name;

-- 3. Patient Feedback Analysis
-- Find the average feedback rating for each doctor and display the results in descending order of ratings--
SELECT d.name AS doctor_name, AVG(f.rating) AS average_rating
FROM Doctors d
JOIN Feedback f ON d.doctor_id = f.doctor_id
GROUP BY d.name
ORDER BY average_rating DESC;

-- 4. Appointment Status Distribution-- 
-- How many appointments are in each status (Confirmed, Cancelled, Completed)?--
SELECT status, COUNT(*) AS appointment_count
FROM Appointments
GROUP BY status;

-- 5. Top Hospitals by Resource Availability
-- Find the top 3 hospitals with the most resources marked as "Available"--
SELECT h.name AS hospital_name, COUNT(r.resource_id) AS available_resources
FROM Hospitals h
JOIN Resources r ON h.hospital_id = r.hospital_id
WHERE r.availability_status = 'Available'
GROUP BY h.name
ORDER BY available_resources DESC
LIMIT 3;

-- 6. Doctor Availability Check
-- Retrieve the details of doctors who are available between "10:00" and "14:00"--

SELECT doctor_id, name, specialty, availability_slots
FROM Doctors
WHERE availability_slots LIKE '%10:00%' OR availability_slots LIKE '%14:00%';

-- 7. Upcoming Appointments--
-- Display the next 5 upcoming appointments based on the current date and time--

SELECT appointment_id, patient_id, doctor_id, hospital_id, date, time
FROM Appointments
WHERE CONCAT(date, ' ', time) > NOW()
ORDER BY date, time
LIMIT 5;

-- 8. Hospital Utilization
-- For each hospital, calculate the total number of appointments scheduled-- 
SELECT h.name AS hospital_name, COUNT(a.appointment_id) AS total_appointments
FROM Hospitals h
LEFT JOIN Appointments a ON h.hospital_id = a.hospital_id
GROUP BY h.name;

-- 9  Active Patient Count
-- Find the number of unique patients who have scheduled more than 3 appointments--

SELECT COUNT(*) AS active_patient_count
FROM (
    SELECT patient_id, COUNT(appointment_id) AS appointment_count
    FROM Appointments
    GROUP BY patient_id
    HAVING appointment_count > 3
) AS subquery;

-- 10. Feedback for Doctors in Cardiology-- 
-- Retrieve the average feedback score for doctors in the "Cardiology" specialization--

SELECT d.name AS doctor_name, AVG(f.rating) AS average_rating
FROM Doctors d
JOIN Feedback f ON d.doctor_id = f.doctor_id
WHERE d.specialty = 'Cardiology'
GROUP BY d.name;

-- 11. Resource Usage-
-- Find which hospitals have all their resources marked as "In Use"--

SELECT Hospitals.name AS hospital_name
FROM Hospitals
JOIN Resources ON Hospitals.hospital_id = Resources.hospital_id
GROUP BY Hospitals.name
HAVING SUM(Resources.availability_status = 'In Use') = COUNT(Resources.resource_id);


-- 12. Most Popular Appointment Slots--
-- Identify the time slots with the highest number of scheduled appointments--

SELECT time, COUNT(*) AS appointment_count
FROM Appointments
GROUP BY time
ORDER BY appointment_count DESC;

-- 13. Feedback Filter by Rating--
-- List the names of doctors who have received a feedback rating of 5 from more than 5 patients--

SELECT Doctors.name AS doctor_name, COUNT(Feedback.rating) AS five_star_feedback_count
FROM Doctors
JOIN Feedback ON Doctors.doctor_id = Feedback.doctor_id
WHERE Feedback.rating = 5
GROUP BY Doctors.name
HAVING five_star_feedback_count > 5;

-- 14. Patient Without Feedback--
-- Find the details of patients who have never submitted feedback for any doctor--

SELECT p.patient_id, p.name, p.age, p.gender, p.contact
FROM Patients p
LEFT JOIN Feedback f ON p.patient_id = f.patient_id
WHERE f.feedback_id IS NULL;

-- 15. Overlapping Appointments-- 
-- Identify if any doctor has overlapping appointments on the same date and time--
SELECT a1.doctor_id, a1.date, a1.time, COUNT(*) AS overlap_count
FROM Appointments a1
JOIN Appointments a2 
  ON a1.doctor_id = a2.doctor_id 
  AND a1.date = a2.date 
  AND a1.time = a2.time
  AND a1.appointment_id != a2.appointment_id
GROUP BY a1.doctor_id, a1.date, a1.time
HAVING overlap_count > 1;

-- Bonus Challenge Question--
-- Check which doctors are associated with the highest-rated hospitals based on feedback from patients--

SELECT Doctors.name AS doctor_name, Hospitals.name AS hospital_name, AVG(Feedback.rating) AS hospital_avg_rating
FROM Doctors
JOIN Hospitals ON Doctors.hospital_id = Hospitals.hospital_id
JOIN Feedback ON Feedback.hospital_id = Hospitals.hospital_id
GROUP BY Doctors.name, Hospitals.name
ORDER BY hospital_avg_rating DESC;





























