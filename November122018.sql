/*  Ardavan Hashemzadeh
    November 12 2018
    List of patients with Treatment Planned procedures/ No appointment is made
*/
SET @MinAge=0;
SET @MaxAge=3;

SELECT patnum, Age, LastAppointment FROM (
        SELECT pl.patnum, YEAR(NOW())-YEAR(Birthdate) AS Age, MAX(aptdatetime) AS LastAppointment FROM patient p JOIN procedurelog pl ON p.patnum=pl.patnum
        JOIN procedurecode pc ON pl.codenum=pc.codenum
        LEFT JOIN appointment a ON pl.patnum=a.patnum
        WHERE procdate >= DATE_SUB(NOW(), INTERVAL 3 YEAR)
        AND procstatus=1
        GROUP BY pl.patnum) a
WHERE (LastAppointment <= NOW() OR LastAppointment IS NULL)
AND Age <=18
ORDER BY LastAppointment DESC

