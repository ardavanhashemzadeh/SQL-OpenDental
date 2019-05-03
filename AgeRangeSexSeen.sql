/*  Ardavan Hashemzadeh
    May 3rd 2019
    Age range and gender of patients seen in date range
*/

SET @FromDate='2019-01-01';
SET @ToDate='2019-01-31';


SELECT Gender,
SUM(IF(Age BETWEEN 0 AND 4,TheCount,0)) AS '0-4',
SUM(IF(Age BETWEEN 5 AND 6,TheCount,0)) AS '5-6',
SUM(IF(Age BETWEEN 7 AND 8,TheCount,0)) AS '7-8',
SUM(IF(Age > 8,TheCount,0)) AS '8+' FROM
(
SELECT Age, COUNT(Age) AS TheCount, Gender FROM 
(
SELECT a.patnum, YEAR(aptdatetime)-YEAR(birthdate) as 'Age',
CASE
  WHEN gender=0 THEN "Male"
  WHEN gender=1 THEN "Female"
  WHEN gender=2 THEN "Unknown"
END AS 'Gender'
FROM appointment a
JOIN patient p ON a.patnum=p.patnum
WHERE DATE(aptdatetime) BETWEEN @FromDate AND @ToDate
AND aptstatus=2
GROUP BY patnum
) a
GROUP BY Age, Gender
ORDER BY Age, Gender
) b
GROUP BY Gender
