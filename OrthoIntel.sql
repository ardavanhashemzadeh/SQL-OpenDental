SELECT COUNT(*)
FROM procedurelog pl JOIN procedurecode pc USING(codenum)
LEFT JOIN (SELECT DISTINCT patnum FROM procedurelog JOIN procedurecode USING(codenum) WHERE proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
) starts USING (patnum)
WHERE proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
AND starts.patnum IS NULL



-- Patients with Ortho Start Codes
SELECT DISTINCT patnum FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")

-- Count of patients with Ortho Start codes
SELECT COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")

-- Patients with completed Ortho tx (based on code D8680)
SELECT DISTINCT patnum FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode="D8680"

-- Count of patients with completed Ortho tx (based on code D8680)
SELECT COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode=”D8680”

-- Count of patients broken down by Ortho Start codes
SELECT proccode, COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
GROUP BY proccode

-- Count of patients in a year broken down by Ortho Start codes
SET @ProcYear='2010';
SELECT proccode, COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") AND YEAR(procdate)=@ProcYear
GROUP BY proccode
ORDER BY proccode DESC

-- Count of patients with completed ortho tx based on start year
SELECT COUNT(*) AS CompletedCases, StartYear FROM procedurelog JOIN procedurecode USING(codenum) JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts USING (patnum)
WHERE procstatus=2 AND proccode="D8680"
GROUP BY StartYear
ORDER BY StartYear;



-- Starts by year
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") ORDER BY StartYear













-- Patients with Ortho Start Codes
SELECT DISTINCT patnum FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")

-- Count of patients with Ortho Start codes
SELECT COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")

-- Patients with completed Ortho tx (based on code D8680)
SELECT DISTINCT patnum FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode="D8680"

-- Count of patients with completed Ortho tx (based on code D8680)
SELECT COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode=”D8680”
