/*  Ardavan Hashemzadeh
    September 25 2018
    List patients under 3yo
    who are due for recare
*/

SELECT patnum, patname, TIMESTAMPDIFF(YEAR,birthdate,CURDATE()) AS age, LastApt
FROM (
  SELECT a.patnum, birthdate,
  CONCAT(fname, " ", lname) AS patname,
  MAX(aptdatetime) AS LastApt
  FROM appointment a JOIN patient p ON a.patnum=p.patnum
  GROUP BY a.patnum) a
WHERE DATE(LastApt) <= DATE_SUB(now(), INTERVAL 6 MONTH)
AND TIMESTAMPDIFF(YEAR,birthdate,CURDATE()) <= 3
ORDER BY LastApt DESC;

