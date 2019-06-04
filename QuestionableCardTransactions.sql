-- Ardavan Hashemzadeh
-- June 4th 2018
-- Show number of card transactions with no note from past year
-- Broken down by user and day

SELECT username, paydate, itemname, COUNT(*) AS 'Instances', SUM(PayAmt) AS 'Amount'
FROM payment p JOIN definition d ON p.paytype=d.defnum JOIN userod u ON p.SecUserNumEntry=u.usernum
WHERE paydate BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) and NOW()
AND itemname LIKE "%credit%"
AND paynote = ''
GROUP BY paydate, username
ORDER BY paydate DESC
