/*  Ardavan Hashemzadeh
    November 7th 2018
    List of patients with TP'd pulp
*/
SELECT pl.patnum , MAX(pl.procdate) AS "TP Date" FROM procedurelog pl
JOIN procedurecode pc ON pl.codenum=pc.codenum
WHERE pl.procdate >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
AND pc.proccode IN ("D3220", "D3230", "D3221", "D3222", "D3240")
AND procstatus=1
GROUP BY pl.patnum
ORDER BY MAX(pl.procdate)
LIMIT 100;
