How many new patients in the past 2 weeks scheduled a Maj Appt? 

SET @FromDate=CURDATE() - INTERVAL 2 WEEK;
SET @ToDate=CURDATE();
SELECT pl.aptnum, pl.patnum, SUM(LENGTH(surf)) AS Surfaces
FROM procedurelog pl JOIN appointment a ON pl.aptnum=a.aptnum
WHERE DATE(aptdatetime) >= @ToDate AND aptstatus=1
AND pl.patnum IN (SELECT * FROM (SELECT patnum FROM appointment WHERE IsNewPatient=1 AND aptstatus=2 AND DATE(aptdatetime) BETWEEN @FromDate AND @ToDate) a)
GROUP BY pl.patnum, pl.aptnum HAVING Surfaces >= 2;

How many new patients scheduled their 6rc (Next 6 months)?

SET @FromDate=CURDATE() - INTERVAL 2 WEEK;
SET @ToDate=CURDATE();
SELECT patnum
FROM appointment a JOIN operatory o ON a.op=o.operatorynum
WHERE DATE(aptdatetime) >= @ToDate AND aptstatus=1 AND opname LIKE "%bay%"
AND patnum IN (SELECT * FROM (SELECT patnum FROM appointment WHERE IsNewPatient=1 AND aptstatus=2 AND DATE(aptdatetime) BETWEEN @FromDate AND @ToDate) a);

How many patients are actually coming back ?
SET @FromDate=CURDATE() - INTERVAL 2 WEEK;
SET @ToDate=CURDATE();
SELECT patnum
FROM appointment
WHERE DATE(aptdatetime) >= @ToDate AND aptstatus=1
AND patnum IN (SELECT * FROM (SELECT patnum FROM appointment WHERE IsNewPatient=1 AND aptstatus=2 AND DATE(aptdatetime) BETWEEN @FromDate AND @ToDate) a);

What percentage of patients are actually coming back ?

SET @FromDate=CURDATE() - INTERVAL 2 WEEK;
SET @ToDate=CURDATE();
SELECT (
  SELECT COUNT(*)
  FROM appointment
  WHERE DATE(aptdatetime) >= @ToDate AND aptstatus=1
  AND patnum IN (
    SELECT * FROM (
      SELECT patnum FROM appointment
      WHERE IsNewPatient=1
      AND aptstatus=2
      AND DATE(aptdatetime) BETWEEN @FromDate AND @ToDate
      ) a
    )
  )
/
(
  SELECT COUNT(*) FROM (
    SELECT patnum
    FROM appointment WHERE IsNewPatient=1 AND aptstatus=2
    AND DATE(aptdatetime) BETWEEN @FromDate AND @ToDate
  ) a
) * 100
AS PercentReturning;

