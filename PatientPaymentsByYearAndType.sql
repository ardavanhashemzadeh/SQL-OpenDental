/* Ardavan Hashemzadeh
   May 30 2019
   Show patient payments for last month
*/
SELECT YEAR(paydate) AS 'Year', itemname AS PaymentType, SUM(payamt) AS 'Amount'
FROM payment p JOIN definition d ON p.paytype=d.defnum
WHERE paydate BETWEEN DATE_SUB(NOW(), INTERVAL 10 YEAR) and NOW()
GROUP BY YEAR(paydate), itemname
ORDER BY paydate DESC
