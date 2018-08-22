/* Ardavan Hashemzadeh
   August 22nd 2018
   List the number of active patients per each zip code
*/
SELECT Zip AS ZipCode, COUNT(*) AS Patients
FROM patient WHERE patstatus=0
GROUP BY ZipCode
ORDER BY Patients DESC;
