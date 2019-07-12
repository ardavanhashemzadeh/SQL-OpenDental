/* Ardavan Hashemzadeh */

-- FeeSched Recon
SELECT * FROM FeeSched LIMIT 10;

-- Link PT to FS Recon
SELECT * FROM Patient p JOIN FeeSched fs ON p.FeeSched=fs.FeeSchedNum LIMIT 10;

-- Show some claims
SELECT * FROM claim LIMIT 10

-- Show pending claims
SELECT * FROM claim WHERE ClaimStatus="S";

-- Show pending claims which are not preauths
SELECT * FROM claim WHERE ClaimStatus="S" AND ClaimType <> "PreAuth"

-- Show pending claims which are not preauths ordered by date sent
SELECT * FROM claim WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" ORDER BY DateSent

-- Payplans
SELECT * FROM payplan limit 10

-- Show some claimprocs
SELECT * FROM claimproc LIMIT 10;

-- Show come claimprocs with the procedurecodes
SELECT * FROM claimproc JOIN procedurelog USING(procnum) JOIN procedurecode USING(codenum) LIMIT 10

-- Patients with Ortho Start Codes
SELECT DISTINCT patnum FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")

-- Count of patients with Ortho Start codes
SELECT COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")

-- Patients with completed Ortho tx (based on code D8680)
SELECT DISTINCT patnum FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode="D8680"

-- Count of patients with completed Ortho tx (based on code D8680)
SELECT COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode=”D8680”

-- Starts by year
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") ORDER BY StartYear

-- Fees for a particular code
SELECT ProcCode, Amount, Description AS FeeSchedule
FROM fee f LEFT JOIN feesched fs ON f.feesched=fs.feeschednum
LEFT JOIN procedurecode USING(codenum)
WHERE proccode LIKE "_8670"
ORDER BY FeeSchedule

-- Codes used and their fees per fee schedule
SELECT ProcCode, Descript, Amount, Description AS FeeSchedule
FROM fee f LEFT JOIN feesched fs ON f.feesched=fs.feeschednum
LEFT JOIN procedurecode USING(codenum)
JOIN (SELECT DISTINCT codenum FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2) CodesUsed USING(codenum)
ORDER BY FeeSchedule,ProcCode

-- Starts per year and quarter and corresponding completions
SELECT StartYear, StartQuarter, Starts.FeeSchedule, COUNT(Starts.patnum) AS Starts, COUNT(Debands.patnum) AS Completed
FROM (
  SELECT DISTINCT p.patnum, fs.description AS FeeSchedule, YEAR(procdate) AS StartYear, QUARTER(procdate) AS StartQuarter
  FROM procedurelog JOIN procedurecode USING(codenum)
  JOIN patient p USING(patnum)
  JOIN feesched fs ON p.feesched=fs.feeschednum
  WHERE procstatus=2
  AND proccode IN ("D8060", "D8080", "D8090")) Starts
LEFT JOIN (
  SELECT DISTINCT patnum
  FROM procedurelog JOIN procedurecode USING(codenum)
  WHERE procstatus=2
  AND proccode="D8680") Debands
USING(patnum)
GROUP BY StartYear, StartQuarter, FeeSchedule
ORDER BY StartYear, StartQuarter, FeeSchedule

-- Starts per period and their corresponding completions
SET @FromDate='2018-01-01', @ToDate='2018-12-31';
SELECT Starts.FeeSchedule, COUNT(Starts.patnum) AS Starts, COUNT(Debands.patnum) AS Completed
FROM (
  SELECT DISTINCT p.patnum, fs.description AS FeeSchedule
  FROM procedurelog JOIN procedurecode USING(codenum)
  JOIN patient p USING(patnum)
  JOIN feesched fs ON p.feesched=fs.feeschednum
  WHERE procstatus=2
  AND proccode IN ("D8060", "D8080", "D8090")
  AND procdate BETWEEN @FromDate AND @ToDate) Starts
LEFT JOIN (
  SELECT DISTINCT p.patnum, fs.description AS FeeSchedule
  FROM procedurelog JOIN procedurecode USING(codenum)
  JOIN patient p USING(patnum)
  JOIN feesched fs ON p.feesched=fs.feeschednum
  WHERE procstatus=2
  AND proccode="D8680") Debands
USING(patnum)
GROUP BY FeeSchedule

-- Patients with complete tx
SELECT StartYear, COUNT(starts.patnum) AS Starts, COUNT( FROM procedurelog JOIN procedurecode USING (codenum) JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts USING (patnum)
WHERE procstatus=2 AND proccode="D8680"
GROUP BY StartYear
ORDER BY StartYear;
