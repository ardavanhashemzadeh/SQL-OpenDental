/* Ardavan Hashemzadeh
   May 29 2019
   Show patient payments for last month
*/
SELECT paydate AS 'Date', itemname AS PaymentType, payamt AS 'Amount'
FROM payment p JOIN definition d ON p.paytype=d.defnum
WHERE paydate BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) and NOW()
GROUP BY paydate, itemname
ORDER BY paydate DESC
