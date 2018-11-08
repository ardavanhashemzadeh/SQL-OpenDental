/* Ardavan Hashemzadeh
   November 8th 2018
   Recall List
*/
SELECT fname, lname, Age, LastAppointment,
	  CarrierName, HmPhone, WkPhone, WirelessPhone
FROM (SELECT PatNum, MAX(aptdatetime) AS LastAppointment
	FROM appointment GROUP BY PatNum) apt
JOIN (SELECT p.patnum, fname, lname, YEAR(NOW())-YEAR(birthdate) AS Age, HmPhone, WkPhone, WirelessPhone, CarrierName
  FROM patient p
	LEFT JOIN patplan pp ON pp.patnum=p.patnum
	LEFT JOIN inssub ins ON ins.plannum=pp.patplannum
	LEFT JOIN insplan ip ON ip.plannum= ins.plannum
	LEFT JOIN carrier c ON c.carriernum=ip.carriernum
	WHERE pp.ordinal=1
	GROUP BY p.PatNum) ins
ON apt.patnum=ins.patnum
WHERE LastAppointment<=DATE_SUB(NOW(),INTERVAL 3 YEAR)
AND Age <= 17
ORDER BY LastAppointment DESC
