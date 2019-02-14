/*
    Ardavan Hashemzadeh
    February 14 2019
    Credit card report by date
*/
SELECT PayDate, ItemName, SUM(PayAmt) AS Amount
FROM payment p JOIN definition d ON p.PayType=d.DefNum
WHERE ItemName LIKE "%credit%"
OR ItemName LIKE "%card%"
GROUP BY PayDate, PayType
ORDER BY PayDate;
