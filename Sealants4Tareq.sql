/* Ardavan Hashemzadeh
   July 21 2018
   Hygiene report for T.A.
*/

SELECT ProcDate AS "Date",
CONCAT(FName, " ", LName) AS "Name",
"" AS "Weekday",
(SELECT valuestring FROM preference WHERE prefname='practicetitle') AS Location,
"" AS "Hrs of the day",
ROUND(SUM(ProcFee),2) AS "Production of sealants",
"" AS "Average for 1 sealant",
COUNT(*) AS "Number of sealants"
FROM procedurelog pl JOIN provider p USING (provnum) JOIN procedurecode pc USING (codenum)
WHERE DATE(ProcDate) BETWEEN '2017-07-01' AND DATE(NOW()) AND proccode="D1351"
GROUP BY ProcDate, ProvNum
ORDER BY LName, ProcDate
