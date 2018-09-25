/*  Ardavan Hashemzadeh
    September 25 2018
    List patients under 3yo
    who are due for recare
*/

SELECT patnum, pat, age
FROM (
  SELECT patnum,
  TIMESTAMPDIFF(YEAR,birthdate,CURDATE()) AS age,
  CONCAT(fname, " ", lname) AS pat,
  MAX(aptdatetime) AS LastApt
  FROM appointment NATURAL JOIN patient) a
WHERE DATE(LastApt) <= DATE_SUB(now(), INTERVAL 6 MONTH)
AND age <= 3;
