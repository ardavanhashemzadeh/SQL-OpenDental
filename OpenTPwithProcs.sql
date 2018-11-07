/*  Ardavan Hashemzadeh
    Halloween 2018 :)
    List 100 most recent patients
    with open treatment plans for
    (Following lines match lines of codes):
    Prefab Stainless Steel Crown
    Pulp
    Sealant, SDF
    unlilateral, bilateral Space Maintainers
    Extraction
    Anterior Composite 1, 2, 3, 4+ surfaces
    Posterior Composite 1, 2, 3, 4+ surfaces
*/
 SELECT patnum, LastAppointment FROM (
	SELECT pl.patnum, MAX(aptdatetime) AS LastAppointment FROM procedurelog pl
	JOIN procedurecode pc ON pl.codenum=pc.codenum
	LEFT JOIN appointment a ON pl.patnum=a.patnum
	WHERE pc.proccode IN ("D2930", "D2931", "D2933", "D2934",
		"D3220", "D3230", "D3240",
		"D1351", "D1354",
		"D1510", "D1515",
		"D7140",
		"D2330", "D2331", "D2332", "D2335",
		"D2391", "D2392", "D2393", "D2394")
	AND procstatus=1
	GROUP BY pl.patnum) a
WHERE (LastAppointment <= NOW() OR LastAppointment IS NULL)
ORDER BY LastAppointment DESC
LIMIT 100;
