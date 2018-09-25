/*  Ardavan Hashemzadeh
    September 25 2018
    List patients under 3yo
    who are due for recare
*/

SELECT patnum, patname, TIMESTAMPDIFF(YEAR,birthdate,CURDATE()) AS age
FROM (
  SELECT patnum, birthdate,
  CONCAT(fname, " ", lname) AS patname,
  MAX(aptdatetime) AS LastApt
  FROM appointment NATURAL JOIN patient
  GROUP BY patnum) a
WHERE DATE(LastApt) <= DATE_SUB(now(), INTERVAL 6 MONTH)
AND TIMESTAMPDIFF(YEAR,birthdate,CURDATE()) <= 3;
