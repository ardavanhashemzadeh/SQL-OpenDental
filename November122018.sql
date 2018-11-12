/*  Ardavan Hashemzadeh
    November 12 2018
    List of patients with Treatment Planned procedures/ No appointment is made
*/
SET @MinAge=0;
SET @MaxAge=3;

SELECT patnum, Age, LastAppointment FROM (
        SELECT pl.patnum, YEAR(NOW())-YEAR(Birthdate) AS Age, MAX(aptdatetime) AS LastAppointment
        FROM patient p
        JOIN procedurelog pl ON p.patnum=pl.patnum
        LEFT JOIN appointment a ON pl.patnum=a.patnum
        WHERE procdate >= DATE_SUB(NOW(), INTERVAL 3 YEAR)
        AND procstatus=1
        GROUP BY pl.patnum) a
WHERE (LastAppointment <= NOW() OR LastAppointment IS NULL)
AND Age BETWEEN @MinAge AND @MaxAge
ORDER BY LastAppointment DESC

/*
*
*
*
*
*/


/*  Ardavan Hashemzadeh
    November 12 2018
    List of patients with No Bundles/Codes generated for the appointment
    This query returns patients who have planned appointments with no procedures
*/
SET @MinAge=0;
SET @MaxAge=3;

SELECT patnum, Age, LastAppointment FROM (
        SELECT pl.patnum, YEAR(NOW())-YEAR(Birthdate) AS Age, MAX(aptdatetime) AS LastAppointment
        FROM patient p
        JOIN procedurelog pl ON p.patnum=pl.patnum
        LEFT JOIN appointment a ON pl.patnum=a.patnum
        GROUP BY pl.patnum) a
JOIN (SELECT patnum FROM procedurelog pl WHERE aptnum IS NULL GROUP BY patnum) b ON a.patnum=b.patnum
WHERE (LastAppointment <= NOW() OR LastAppointment IS NULL)
AND Age BETWEEN @MinAge AND @MaxAge
ORDER BY LastAppointment DESC
/*
*
*
*
*
*/



/*  Ardavan Hashemzadeh
    November 12 2018
    List of patients with No re-Care appointment is made
    This query returns patients who do not have future planned appointments
*/
SET @MinAge=0;
SET @MaxAge=3;

SELECT patnum, Age, LastAppointment FROM (
        SELECT pl.patnum, YEAR(NOW())-YEAR(Birthdate) AS Age, MAX(aptdatetime) AS LastAppointment
        FROM patient p
        JOIN procedurelog pl ON p.patnum=pl.patnum
        LEFT JOIN appointment a ON pl.patnum=a.patnum
        GROUP BY pl.patnum) a
WHERE (LastAppointment <= NOW() OR LastAppointment IS NULL)
AND Age BETWEEN @MinAge AND @MaxAge
ORDER BY LastAppointment DESC
/*
*
*
*
*
*/





/*  Ardavan Hashemzadeh
    November 12 2018
    List of patients with Spacemaintainer Impression Appointment is not made
    In Progress
*/
SET @MinAge=0;
SET @MaxAge=3;

SELECT patnum, Age, LastAppointment FROM (
        SELECT pl.patnum, YEAR(NOW())-YEAR(Birthdate) AS Age, MAX(aptdatetime) AS LastAppointment
        FROM patient p
        JOIN procedurelog pl ON p.patnum=pl.patnum
        JOIN procedurecode pc ON pc.codenum=pl.codenum
        LEFT JOIN appointment a ON pl.patnum=a.patnum
        GROUP BY pl.patnum) a
WHERE (LastAppointment <= NOW() OR LastAppointment IS NULL)
AND Age BETWEEN @MinAge AND @MaxAge
ORDER BY LastAppointment DESC
/*
*
*
*
*
*/
