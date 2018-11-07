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
	WHERE procstatus=1
	GROUP BY pl.patnum) a
WHERE (LastAppointment BETWEEN DATE_SUB(NOW(), INTERVAL 3 YEAR) AND NOW() OR LastAppointment IS NULL)
ORDER BY LastAppointment DESC
LIMIT 100;
