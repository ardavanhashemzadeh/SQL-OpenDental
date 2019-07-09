SET @FromDate='2018-01-01', @ToDate='2018-12-31';
SELECT SUM(starts) FROM (
SELECT Starts.FeeSchedule, COUNT(*) AS Starts FROM (
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
) test
  

SET @FromDate='2018-01-01', @ToDate='2018-12-31';
SELECT Starts.FeeSchedule, COUNT(*) AS Starts FROM (
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

-- FeeSched Recon
SELECT * FROM FeeSched LIMIT 10;

-- Link PT to FS Recon
SELECT * FROM Patient p JOIN FeeSched fs ON p.FeeSched=fs.FeeSchedNum LIMIT 10;

-- Patients with starts in a particular quarter
-- Q1 SET @FromDate=’2018-01-01’, @ToDate=’2018-03-31’;
-- Q2 SET @FromDate=’2018-04-01’, @ToDate=’2018-06-31’;
-- Q3 SET @FromDate=’2018-07-01’, @ToDate=’2018-09-31’;
-- Q4 SET @FromDate=’2018-10-01’, @ToDate=’2018-12-31’;
SET @FromDate='2018-01-01', @ToDate='2018-12-31';
SELECT COUNT(*) FROM (
SELECT DISTINCT p.patnum, fs.description FROM procedurelog JOIN procedurecode USING(codenum) JOIN patient p USING(patnum) JOIN feesched fs ON p.feesched=fs.feeschednum WHERE procstatus=2 AND proccode IN ("D8060", "D8080", "D8090") AND procdate BETWEEN @FromDate AND @ToDate) a;


-- Patients with complete tx
SELECT StartYear, COUNT(starts.patnum) AS Starts, COUNT( FROM procedurelog JOIN procedurecode USING (codenum) JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts USING (patnum)
WHERE procstatus=2 AND proccode="D8680"
GROUP BY StartYear
ORDER BY StartYear;


-- FeeSched Recon
SELECT * FROM FeeSched LIMIT 10;

-- Link PT to FS Recon
SELECT * FROM Patient p JOIN FeeSched fs ON p.FeeSched=fs.FeeSchedNum LIMIT 10;


-- EXP Patients with completed tx
SELECT StartYear, COUNT(DISTINCT patnum) AS CompletedCases, SUM(InsPayAmt)+SUM(PayAmt) AS Total FROM procedurelog JOIN procedurecode USING(codenum) INNER JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts USING (patnum) LEFT JOIN payment USING(patnum) LEFT JOIN claim USING(patnum)
WHERE procstatus=2 AND proccode="D8680"
GROUP BY StartYear
ORDER BY StartYear;

-- Patients with complete tx
SELECT StartYear, COUNT(DISTINCT PATNUM) AS CompletedTX FROM procedurelog JOIN procedurecode USING (codenum) JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts USING (patnum)
WHERE procstatus=2 AND proccode="D8680"
GROUP BY StartYear
ORDER BY StartYear;

-- Patients with incomplete tx
SELECT Starts.StartYear, COUNT(DISTINCT PATNUM) AS IncompleteTX FROM (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts
LEFT JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode = "D8680") Complete USING(patnum) WHERE Complete.patnum IS NULL
GROUP BY StartYear
ORDER BY StartYear;

-- Patients with Starts
SELECT YEAR(procdate) AS StartYear, COUNT(DISTINCT patnum) AS Starts FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") GROUP BY StartYear ORDER BY StartYear




-- Count and dollar sum of pending claims that are not preauths and are for starts per year
SELECT YEAR(DateSent) AS TheYear, COUNT(*) AS TheCount, SUM(ClaimFee) AS ClaimAmount, SUM(InsPayAmt) AS InsurancePaidAmount FROM
(
SELECT DateSent, ClaimFee, c.InsPayAmt FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent
) a
GROUP BY TheYear

-- Count and dollar sum of starts which do not have insurance claims attached.
SELECT YEAR(pl.procdate) AS TheYear, COUNT(*) AS TheCount, SUM(procfee) AS TheAmount FROM procedurelog pl JOIN procedurecode pc USING(codenum) LEFT JOIN claimproc cp USING(procnum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") AND claimnum IS NULL
GROUP BY TheYear
-- Stuff
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

-- Show some claims
SELECT * FROM claim LIMIT 10

-- Show pending claims
SELECT * FROM claim WHERE ClaimStatus="S";

-- Show pending claims which are not preauths
SELECT * FROM claim WHERE ClaimStatus="S" AND ClaimType <> "PreAuth"

-- Show pending claims which are not preauths ordered by date sent
SELECT * FROM claim WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" ORDER BY DateSent

-- Show some claimprocs
SELECT * FROM claimproc LIMIT 10;

-- Show come claimprocs with the procedurecodes
SELECT * FROM claimproc JOIN procedurelog USING(procnum) JOIN procedurecode USING(codenum) LIMIT 10

-- Show pending claims which are not preauths ordered by date sent
SELECT * FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent

--- Maybe same as above?
SELECT * FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent

-- How many pending claims that are not preauths and are for starts per year
SELECT YEAR(DateSent) AS TheYear, COUNT(*) AS TheCount FROM
(
SELECT DateSent FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent
) a
GROUP BY TheYear

-- Count and dollar sum of pending claims that are not preauths and are for starts per year
SELECT YEAR(DateSent) AS TheYear, COUNT(*) AS TheCount, SUM(ClaimFee) AS ClaimAmount, SUM(InsPayAmt) AS InsurancePaidAmount FROM
(
SELECT DateSent, ClaimFee, c.InsPayAmt FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent
) a
GROUP BY TheYear

-- Count and dollar sum of starts which do not have insurance claims attached.
SELECT YEAR(pl.procdate) AS TheYear, COUNT(*) AS TheCount, SUM(procfee) AS TheAmount FROM procedurelog pl JOIN procedurecode pc USING(codenum) LEFT JOIN claimproc cp USING(procnum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") AND claimnum IS NULL
GROUP BY TheYear

-- Payplans
SELECT * FROM payplan limit 10




-- EXP Patients with completed tx
SELECT StartYear, COUNT(DISTINCT patnum) AS CompletedCases, SUM(InsPayAmt)+SUM(PayAmt) AS Total FROM procedurelog JOIN procedurecode USING(codenum) INNER JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts USING (patnum) LEFT JOIN payment USING(patnum) LEFT JOIN claim USING(patnum)
WHERE procstatus=2 AND proccode="D8680"
GROUP BY StartYear
ORDER BY StartYear;

-- Patients with complete tx
SELECT StartYear, COUNT(DISTINCT PATNUM) AS CompletedTX FROM procedurelog JOIN procedurecode USING (codenum) JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts USING (patnum)
WHERE procstatus=2 AND proccode="D8680"
GROUP BY StartYear
ORDER BY StartYear;

-- Patients with incomplete tx
SELECT Starts.StartYear, COUNT(DISTINCT PATNUM) AS IncompleteTX FROM (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts
LEFT JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode = "D8680") Complete USING(patnum) WHERE Complete.patnum IS NULL
GROUP BY StartYear
ORDER BY StartYear;

-- Patients with Starts
SELECT YEAR(procdate) AS StartYear, COUNT(DISTINCT patnum) AS Starts FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") GROUP BY StartYear ORDER BY StartYear




-- Count and dollar sum of pending claims that are not preauths and are for starts per year
SELECT YEAR(DateSent) AS TheYear, COUNT(*) AS TheCount, SUM(ClaimFee) AS ClaimAmount, SUM(InsPayAmt) AS InsurancePaidAmount FROM
(
SELECT DateSent, ClaimFee, c.InsPayAmt FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent
) a
GROUP BY TheYear

-- Count and dollar sum of starts which do not have insurance claims attached.
SELECT YEAR(pl.procdate) AS TheYear, COUNT(*) AS TheCount, SUM(procfee) AS TheAmount FROM procedurelog pl JOIN procedurecode pc USING(codenum) LEFT JOIN claimproc cp USING(procnum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") AND claimnum IS NULL
GROUP BY TheYear
-- Stuff
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

-- Show some claims
SELECT * FROM claim LIMIT 10

-- Show pending claims
SELECT * FROM claim WHERE ClaimStatus="S";

-- Show pending claims which are not preauths
SELECT * FROM claim WHERE ClaimStatus="S" AND ClaimType <> "PreAuth"

-- Show pending claims which are not preauths ordered by date sent
SELECT * FROM claim WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" ORDER BY DateSent

-- Show some claimprocs
SELECT * FROM claimproc LIMIT 10;

-- Show come claimprocs with the procedurecodes
SELECT * FROM claimproc JOIN procedurelog USING(procnum) JOIN procedurecode USING(codenum) LIMIT 10

-- Show pending claims which are not preauths ordered by date sent
SELECT * FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent

--- Maybe same as above?
SELECT * FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent

-- How many pending claims that are not preauths and are for starts per year
SELECT YEAR(DateSent) AS TheYear, COUNT(*) AS TheCount FROM
(
SELECT DateSent FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent
) a
GROUP BY TheYear

-- Count and dollar sum of pending claims that are not preauths and are for starts per year
SELECT YEAR(DateSent) AS TheYear, COUNT(*) AS TheCount, SUM(ClaimFee) AS ClaimAmount, SUM(InsPayAmt) AS InsurancePaidAmount FROM
(
SELECT DateSent, ClaimFee, c.InsPayAmt FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent
) a
GROUP BY TheYear

-- Count and dollar sum of starts which do not have insurance claims attached.
SELECT YEAR(pl.procdate) AS TheYear, COUNT(*) AS TheCount, SUM(procfee) AS TheAmount FROM procedurelog pl JOIN procedurecode pc USING(codenum) LEFT JOIN claimproc cp USING(procnum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") AND claimnum IS NULL
GROUP BY TheYear

-- Payplans
SELECT * FROM payplan limit 10


                                                                                                                                            
                                                                                                                                            


-- EXP Patients with completed tx
SELECT StartYear, COUNT(DISTINCT patnum) AS CompletedCases, SUM(InsPayAmt)+SUM(PayAmt) AS Total FROM procedurelog JOIN procedurecode USING(codenum) INNER JOIN (
SELECT DISTINCT patnum, YEAR(procdate) AS StartYear FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")) Starts USING (patnum) LEFT JOIN payment USING(patnum) LEFT JOIN claim USING(patnum)
WHERE procstatus=2 AND proccode="D8680"
GROUP BY StartYear
ORDER BY StartYear;


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

-- Show some claims
SELECT * FROM claim LIMIT 10

-- Show pending claims
SELECT * FROM claim WHERE ClaimStatus="S";

-- Show pending claims which are not preauths
SELECT * FROM claim WHERE ClaimStatus="S" AND ClaimType <> "PreAuth"

-- Show pending claims which are not preauths ordered by date sent
SELECT * FROM claim WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" ORDER BY DateSent

-- Show some claimprocs
SELECT * FROM claimproc LIMIT 10;

-- Show come claimprocs with the procedurecodes
SELECT * FROM claimproc JOIN procedurelog USING(procnum) JOIN procedurecode USING(codenum) LIMIT 10

-- Show pending claims which are not preauths ordered by date sent
SELECT * FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent

--- Maybe same as above?
SELECT * FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent


-- How many pending claims that are not preauths and are for starts per year
SELECT YEAR(DateSent) AS TheYear, COUNT(*) AS TheCount FROM
(
SELECT DateSent FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent
) a
GROUP BY TheYear

-- Count and dollar sum of pending claims that are not preauths and are for starts per year
SELECT YEAR(DateSent) AS TheYear, COUNT(*) AS TheCount, SUM(ClaimFee) AS ClaimAmount, SUM(InsPayAmt) AS InsurancePaidAmount FROM
(
SELECT DateSent, ClaimFee, c.InsPayAmt FROM claim c JOIN claimproc cp USING(claimnum) JOIN procedurelog pl USING(procnum) JOIN procedurecode pc USING(codenum)
WHERE ClaimStatus="S" AND ClaimType <> "PreAuth" AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")
ORDER BY DateSent
) a
GROUP BY TheYear


-- Count and dollar sum of starts which do not have insurance claims attached.
SELECT YEAR(pl.procdate) AS TheYear, COUNT(*) AS TheCount, SUM(procfee) AS TheAmount FROM procedurelog pl JOIN procedurecode pc USING(codenum) LEFT JOIN claimproc cp USING(procnum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090") AND claimnum IS NULL
GROUP BY TheYear


-- Payplans
SELECT * FROM payplan limit 10



-- Stuff
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
