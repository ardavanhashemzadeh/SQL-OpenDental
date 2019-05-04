SELECT patnum, DATE(MIN(aptdatetime)) AS FirstAppointment,
DATE(MAX(aptdatetime)) AS LastAppointment
FROM appointment
WHERE aptstatus=2
GROUP BY patnum
LIMIT 10;

SELECT DATE(aptdatetime) FROM appointment WHERE patnum=3 AND aptstatus=2 ORDER BY aptdatetime;
