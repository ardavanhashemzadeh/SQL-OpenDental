/* Ardavan Hashemzadeh
   November 16 2018
   Sealant KPIs
*/
SET @FromDate='2018-01-01';
SET @ToDate='2018-12-31';
SET @Provider='aa';
SELECT Date, Name, DAYNAME(Date) AS Weekday, Production, Collection, Collection/SealantCount AS Average, SealantCount FROM (
SELECT pl.ProcDate AS "Date",
CONCAT(FName, " ", LName) AS "Name", "" AS "Weekday",
(SELECT valuestring FROM preference WHERE prefname='practicetitle') AS Location, "" AS "Hrs of the day",
ROUND(SUM(ProcFee),2) AS "Production",
ROUND(SUM(InsPayAmt),2) AS "Collection",
"" AS "Average for 1 sealant",
COUNT(*) AS "SealantCount"
FROM procedurelog pl JOIN provider p USING (provnum) JOIN procedurecode pc USING (codenum) JOIN claimproc cp USING (ProcNum)
WHERE DATE(pl.ProcDate) BETWEEN @FromDate AND @ToDate AND proccode="D1351"
AND ProcStatus=2 AND p.Abbr LIKE CONCAT('%', @Provider, '%')
GROUP BY pl.ProcDate, p.ProvNum
ORDER BY LName, pl.ProcDate
) a
