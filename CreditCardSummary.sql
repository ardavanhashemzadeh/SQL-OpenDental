/* Ardavan Hashemzadeh
   October 16 2018
   Show patient ayments for last month
   Broken down by payment type
*/
SELECT paydate, itemname, SUM(payamt)
FROM payment p JOIN definition d ON p.paytype=d.defnum
WHERE paydate BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) and NOW()
AND itemname LIKE "%credit%"
GROUP BY paydate, itemname
ORDER BY paydate DESC
