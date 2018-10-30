/* Ardavan Hashemzadeh
   October 30 2018
   Show credit payments for last month
*/
SELECT paydate, itemname, SUM(payamt)
FROM payment p JOIN definition d ON p.paytype=d.defnum
WHERE paydate BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) and NOW()
AND itemname LIKE "%credit%"
GROUP BY paydate, itemname
ORDER BY paydate DESC
