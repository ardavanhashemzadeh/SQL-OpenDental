/* Ardavan Hashemzadeh
** July 10 2019
** Ortho cases broken down by
** Fee Schedule and Start year and quarter
*/
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
