/* Ardavan Hashemzadeh
   October 16 2018
   Show credit transactions for last month
*/
SELECT paydate, itemname, payamt
FROM payment p JOIN definition d ON p.paytype=d.defnum
WHERE paydate BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) and NOW()
AND itemname LIKE "%credit%"
ORDER BY paydate DESC
