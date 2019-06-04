-- Ardavan Hashemzadeh
-- June 4th 2018
-- Show paynotes and associated user from card transactions from past year

SELECT username, paydate, itemname, paynote
FROM payment p JOIN definition d ON p.paytype=d.defnum JOIN userod u ON p.SecUserNumEntry=u.usernum
WHERE paydate BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) and NOW()
AND itemname LIKE "%credit%"
