-- Ardavan Hashemzadeh
-- June 5th 2019
-- Doctor Driven, Preventative, and Total Production and Collection

SET @FromDate=DATE_SUB(NOW(), INTERVAL 1 MONTH);
SET @ToDate=CURDATE();
SET @Provider='ec';

SELECT abbr AS Provider,
pl.procdate AS 'DateOfService',
DAYNAME(pl.procdate) AS 'Weekday',
Location,
ROUND(SUM(procfee),2) AS 'TotalProduction',
ROUND(SUM(IFNULL(inspayamt,0)+IFNULL(splitamt,0)),2) AS 'TotalCollection',
ROUND(SUM(CASE WHEN Prevention.codenum IS NOT NULL THEN procfee END),2) AS 'PreventionProduction',
ROUND(SUM(CASE WHEN Prevention.codenum IS NOT NULL THEN IFNULL(inspayamt,0)+IFNULL(splitamt,0) ELSE 0 END),2) AS 'PreventionCollection',
ROUND(SUM(CASE WHEN DoctorDrivenTx.codenum IS NOT NULL THEN procfee END),2) AS 'DoctorDrivenProduction',
ROUND(SUM(CASE WHEN DoctorDrivenTx.codenum IS NOT NULL THEN IFNULL(inspayamt,0)+IFNULL(splitamt,0) ELSE 0 END),2) AS 'DoctorDrivenCollection'

FROM procedurelog pl JOIN provider p USING (provnum)
LEFT JOIN claimproc cp USING (procnum)
LEFT JOIN paysplit ps USING (procnum)
LEFT JOIN (SELECT codenum FROM procedurecode WHERE proccode IN ('D0601','D0602','D0603','D0210','D0220','D0230','D0240','D0250','D0260','D0270','D0272','D0274','D0277','D0290','D0310','D0320','D0321','D0322','D0330','D0340','D0350','D0415','D0425','D0470','D1110','D1120','D1201','D1203','D1204','D1206','D1208','D1205','D1310','D1320','D1330','D1351','D1510','D1515','D1520','D1525','D1550','D4341','D4342','D4343','D4381','D4910','D4920','D5936','D5937','D5986','D6985','D7997','D8210','D8692','D9430','D9440','D9450','D9630','D9910','D9911','D9940','D9941','D9950','D9972','D9973','D9993','D9994')) Prevention USING (codenum)
GROUP BY pl.procdate, abbr
ORDER BY pl.procdate DESC
