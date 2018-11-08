/*  Ardavan Hashemzadeh
    November 8th 2018 :)
    Patients 18 or younger with
    open treatment plans from the last 3 years for
    (Following lines match lines of codes):
    Prefab Stainless Steel Crown
    Pulp
    Sealant, SDF
    unlilateral, bilateral Space Maintainers
    Extraction
    Anterior Composite 1, 2, 3, 4+ surfaces
    Posterior Composite 1, 2, 3, 4+ surfaces
*/

SELECT patnum, Age, LastAppointment FROM (
	SELECT pl.patnum, YEAR(NOW())-YEAR(Birthdate) AS Age, MAX(aptdatetime) AS LastAppointment FROM patient p JOIN procedurelog pl ON p.patnum=pl.patnum
	JOIN procedurecode pc ON pl.codenum=pc.codenum
	LEFT JOIN appointment a ON pl.patnum=a.patnum
	WHERE procdate <= DATE_SUB(NOW(), INTERVAL 3 YEAR)
	AND pc.proccode IN ("D2930", "D2931", "D2933", "D2934",
		"D3220", "D3230", "D3240",
		"D1351", "D1354",
		"D1510", "D1515",
		"D7140",
		"D2330", "D2331", "D2332", "D2335",
		"D2391", "D2392", "D2393", "D2394")
	AND procstatus=1
	GROUP BY pl.patnum) a
WHERE (LastAppointment <= NOW() OR LastAppointment IS NULL)
AND Age <=18
ORDER BY LastAppointment DESC
