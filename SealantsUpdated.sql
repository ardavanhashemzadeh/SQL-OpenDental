/* Ardavan Hashemzadeh
   November 16 2018
   Hygiene report for R.B.
*/

SELECT pl.ProcDate AS "Date",
CONCAT(FName, " ", LName) AS "Name", "" AS "Weekday",
(SELECT valuestring FROM preference WHERE prefname='practicetitle') AS Location, "" AS "Hrs of the day",
ROUND(SUM(ProcFee),2) AS "Production",
ROUND(SUM(InsPayAmt),2) AS "Collection",
"" AS "Average for 1 sealant",
COUNT(*) AS "Number of sealants"
FROM procedurelog pl JOIN provider p USING (provnum) JOIN procedurecode pc USING (codenum) JOIN claimproc cp USING (ProcNum)
WHERE DATE(pl.ProcDate) BETWEEN DATE_SUB(NOW(), INTERVAL 7 DAY) AND DATE(NOW()) AND proccode="D1351"
AND ProcStatus=2
GROUP BY pl.ProcDate, p.ProvNum
ORDER BY LName, pl.ProcDate
