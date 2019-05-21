-- Please create a query of patients under 4 years old that are due for cleaning and need major/min treatment
-- Ardavan Hashemzadeh
-- May 21 2019


SELECT lname, fname, YEAR(CURDATE())-YEAR(birthdate) AS Age, MAX(DATE(aptdatetime)) AS LastAppointment
FROM patient JOIN procedurelog USING(patnum) JOIN appointment USING(patnum) JOIN procedurecode USING(codenum)
WHERE aptstatus=2
AND procstatus=1
AND procdate=DATE(aptdatetime)
AND (
proccode LIKE "D2%"
OR proccode LIKE "D3%"
OR proccode LIKE "D4%"
OR proccode LIKE "D5%"
OR proccode LIKE "D6%"
OR proccode LIKE "D7%"
OR proccode LIKE "D8%"
OR proccode LIKE "D9%"
)
GROUP BY patient.patnum, appointment.aptnum
HAVING LastAppointment<=DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
AND Age <= 4
ORDER BY LastAppointment DESC



