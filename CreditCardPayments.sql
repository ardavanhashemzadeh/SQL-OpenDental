SELECT paydate, payamt, itemname
FROM payment p JOIN definition d ON p.PayType=d.defnum
WHERE paydate BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) AND NOW()
AND itemname LIKE "%credit%"
ORDER BY paydate DESC;
