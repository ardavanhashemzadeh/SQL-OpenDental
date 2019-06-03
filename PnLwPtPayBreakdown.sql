-- Ardavan Hashemzadeh
-- June 2nd 2019
-- Annual Production and Income Report like OpenDental internal with addition of Pt.Payment breakdown
-- Your setup may vary, adjust to match if totals don't
-- Based on OpenDental query number 1252

SET @FromDate='2010-01-01', @ToDate='2019-12-31';
SELECT DATE_FORMAT(result.Date,'%b %Y') AS 'Date',
FORMAT(SUM(result.Fee),2) AS '$Production_',
FORMAT(SUM(result.Adj),2) AS '$Adjust_',
FORMAT(SUM(result.InsW),2) AS '$Writeoff_',
FORMAT(SUM(result.Fee+result.Adj+result.InsW),2) AS '$Total Prod_',

FORMAT(SUM(result.Cash),2) AS '$Cash_',
FORMAT(SUM(result.Check),2) AS '$Check_',
FORMAT(SUM(result.CreditC),2) AS '$Credit Card_',

FORMAT(SUM(result.PtInc),2) AS '$Pt Income_',
FORMAT(SUM(result.InsInc),2) AS '$Ins Income_',
FORMAT(SUM(result.PtInc+result.InsInc),2) AS '$Total Income_'
FROM (
	SELECT DATE(pl.ProcDate) AS 'Date',
	CONCAT(CONCAT(CONCAT(CONCAT(p.LName,', '),p.FName),' '),p.MiddleI) AS 'PatName',
	pc.Descript AS 'Description',
	prov.Abbr AS 'Provider',
	clinic.Description AS 'Clinic',
	pl.ProcFee*(pl.UnitQty+pl.BaseUnits)-IFNULL(SUM(cp.WriteOff),0) AS 'Fee',
	0 AS 'Adj',
	0 AS 'InsW',
	0 AS 'Cash',
	0 AS 'Check',
	0 AS 'CreditC',
	0 AS 'PtInc',
	0 AS 'InsInc'
	FROM procedurelog pl
	INNER JOIN patient p ON p.PatNum=pl.PatNum
	INNER JOIN procedurecode pc ON pc.CodeNum=pl.CodeNum
	INNER JOIN provider prov ON prov.ProvNum=pl.ProvNum
	LEFT JOIN claimproc cp ON pl.ProcNum=cp.ProcNum AND cp.Status='7' 
	LEFT JOIN clinic ON clinic.ClinicNum=pl.ClinicNum
	WHERE pl.ProcStatus = '2'
	AND pl.ProcDate BETWEEN @FromDate AND @ToDate
	GROUP BY pl.ProcNum 
	 
	UNION ALL 

	SELECT adj.AdjDate AS 'Date',
	CONCAT(CONCAT(CONCAT(CONCAT(p.LName,', '),p.FName),' '),p.MiddleI) AS 'PatName',
	adjtype.ItemName AS 'Description',
	prov.Abbr AS 'Provider',
	clinic.Description AS 'Clinic',
	0 AS 'Fee',
	adj.AdjAmt AS 'Adj',
	0 AS 'InsW',
	0 AS 'Cash',
	0 AS 'Check',
	0 AS 'CreditC',
	0 AS 'PtInc',
	0 AS 'InsInc'
	FROM adjustment adj
	INNER JOIN patient p ON p.PatNum=adj.PatNum 
	INNER JOIN definition adjtype ON adjtype.DefNum=adj.AdjType 
	INNER JOIN provider prov ON prov.ProvNum=adj.ProvNum 
	LEFT JOIN clinic ON clinic.ClinicNum=adj.ClinicNum
	WHERE adj.AdjDate BETWEEN @FromDate AND @ToDate

	UNION ALL 

	SELECT cp.DateCP AS 'Date',
	CONCAT(CONCAT(CONCAT(CONCAT(p.LName,', '),p.FName),' '),p.MiddleI) AS 'PatName',
	CONCAT(CONCAT(pc.AbbrDesc,' '),car.CarrierName) AS 'Description',
	prov.Abbr AS 'Provider',
	clinic.Description AS 'Clinic',
	0 AS 'Fee',
	0 AS 'Adj',
	-SUM(cp.WriteOff) AS 'InsW',
	0 AS 'Cash',
	0 AS 'Check',
	0 AS 'CreditC',
	0 AS 'PtInc',
	0 AS 'InsInc'
	FROM claimproc cp
	LEFT JOIN patient p ON cp.PatNum = p.PatNum 
	LEFT JOIN procedurelog pl ON pl.ProcNum=cp.ProcNum 
	LEFT JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum 
	LEFT JOIN insplan ip ON ip.PlanNum = cp.PlanNum 
	LEFT JOIN carrier car ON car.CarrierNum = ip.CarrierNum
	LEFT JOIN provider prov ON prov.ProvNum = cp.ProvNum
	LEFT JOIN clinic ON clinic.ClinicNum=cp.ClinicNum
	WHERE (cp.Status=1 OR cp.Status=4) 
	AND cp.WriteOff > '.0001' 
	AND cp.DateCP BETWEEN @FromDate AND @ToDate
	GROUP BY cp.ClaimProcNum 

	UNION ALL 

	SELECT ps.DatePay AS 'Date',
	CONCAT(p.LName,', ',p.FName,' ',p.MiddleI) AS 'PatName',
	paytype.ItemName AS 'Description',
	prov.Abbr AS 'Provider',
	clinic.Description AS 'Clinic',
	0 AS 'Fee',
	0 AS 'Adj',
	0 AS 'InsW',
	SUM(ps.SplitAmt) AS 'Cash',
	0 AS 'Check',
	0 AS 'CreditC',
	0 AS 'PtInc',
	0 AS 'InsInc'
	FROM paysplit ps JOIN payment USING(paynum) JOIN definition ON payment.paytype=definition.defnum
	LEFT JOIN patient p ON p.PatNum=ps.PatNum 
	LEFT JOIN payment pay ON pay.PayNum=ps.PayNum 
	LEFT JOIN definition paytype ON pay.PayType=paytype.DefNum 
	LEFT JOIN provider prov ON prov.ProvNum=ps.ProvNum 
	LEFT JOIN clinic ON clinic.ClinicNum=ps.ClinicNum
	WHERE pay.PayDate BETWEEN @FromDate AND @ToDate AND definition.ItemName LIKE "Cash"
	GROUP BY ps.PatNum,ps.ProvNum,ps.ClinicNum,payment.PayType,ps.DatePay 

	UNION ALL 
	
	SELECT ps.DatePay AS 'Date',
	CONCAT(p.LName,', ',p.FName,' ',p.MiddleI) AS 'PatName',
	paytype.ItemName AS 'Description',
	prov.Abbr AS 'Provider',
	clinic.Description AS 'Clinic',
	0 AS 'Fee',
	0 AS 'Adj',
	0 AS 'InsW',
	0 AS 'Cash',
	SUM(ps.SplitAmt) AS 'Check',
	0 AS 'CreditC',
	0 AS 'PtInc',
	0 AS 'InsInc'
	FROM paysplit ps JOIN payment USING(paynum) JOIN definition ON payment.paytype=definition.defnum
	LEFT JOIN patient p ON p.PatNum=ps.PatNum 
	LEFT JOIN payment pay ON pay.PayNum=ps.PayNum 
	LEFT JOIN definition paytype ON pay.PayType=paytype.DefNum 
	LEFT JOIN provider prov ON prov.ProvNum=ps.ProvNum 
	LEFT JOIN clinic ON clinic.ClinicNum=ps.ClinicNum
	WHERE pay.PayDate BETWEEN @FromDate AND @ToDate AND definition.ItemName LIKE "Check"
	GROUP BY ps.PatNum,ps.ProvNum,ps.ClinicNum,payment.PayType,ps.DatePay 

	UNION ALL 
	
	SELECT ps.DatePay AS 'Date',
	CONCAT(p.LName,', ',p.FName,' ',p.MiddleI) AS 'PatName',
	paytype.ItemName AS 'Description',
	prov.Abbr AS 'Provider',
	clinic.Description AS 'Clinic',
	0 AS 'Fee',
	0 AS 'Adj',
	0 AS 'InsW',
	0 AS 'Cash',
	0 AS 'Check',
	SUM(ps.SplitAmt) AS 'CreditC',
	0 AS 'PtInc',
	0 AS 'InsInc'
	FROM paysplit ps JOIN payment USING(paynum) JOIN definition ON payment.paytype=definition.defnum
	LEFT JOIN patient p ON p.PatNum=ps.PatNum 
	LEFT JOIN payment pay ON pay.PayNum=ps.PayNum 
	LEFT JOIN definition paytype ON pay.PayType=paytype.DefNum 
	LEFT JOIN provider prov ON prov.ProvNum=ps.ProvNum 
	LEFT JOIN clinic ON clinic.ClinicNum=ps.ClinicNum
	WHERE pay.PayDate BETWEEN @FromDate AND @ToDate AND definition.ItemName LIKE "Credit Card"
	GROUP BY ps.PatNum,ps.ProvNum,ps.ClinicNum,payment.PayType,ps.DatePay 

	UNION ALL 

	SELECT ps.DatePay AS 'Date',
	CONCAT(p.LName,', ',p.FName,' ',p.MiddleI) AS 'PatName',
	paytype.ItemName AS 'Description',
	prov.Abbr AS 'Provider',
	clinic.Description AS 'Clinic',
	0 AS 'Fee',
	0 AS 'Adj',
	0 AS 'InsW',
	0 AS 'Cash',
	0 AS 'Check',
	0 AS 'CreditC',
	SUM(ps.SplitAmt) AS 'PtInc',
	0 AS 'InsInc'
	FROM paysplit ps
	LEFT JOIN patient p ON p.PatNum=ps.PatNum 
	LEFT JOIN payment pay ON pay.PayNum=ps.PayNum 
	LEFT JOIN definition paytype ON pay.PayType=paytype.DefNum 
	LEFT JOIN provider prov ON prov.ProvNum=ps.ProvNum 
	LEFT JOIN clinic ON clinic.ClinicNum=ps.ClinicNum
	WHERE pay.PayDate BETWEEN @FromDate AND @ToDate
	GROUP BY ps.PatNum,ps.ProvNum,ps.ClinicNum,PayType,ps.DatePay 

	UNION ALL 

	SELECT claimpay.CheckDate AS 'Date',
	CONCAT(p.LName,', ',p.FName,' ',p.MiddleI) AS 'PatName',
	car.CarrierName AS 'Description',
	prov.Abbr AS 'Provider',
	clinic.Description AS 'Clinic',
	0 AS 'Fee',
	0 AS 'Adj',
	0 AS 'InsW',
	0 AS 'Cash',
	0 AS 'Check',
	0 AS 'CreditC',
	0 AS 'PtInc',
	SUM(cp.InsPayAmt) AS 'InsInc'
	FROM claimproc cp
	INNER JOIN patient p ON p.PatNum=cp.PatNum
	INNER JOIN insplan ip ON ip.PlanNum=cp.PlanNum
	INNER JOIN carrier car ON car.CarrierNum=ip.CarrierNum
	INNER JOIN provider prov ON prov.ProvNum=cp.ProvNum
	INNER JOIN claimpayment claimpay ON claimpay.ClaimPaymentNum=cp.ClaimPaymentNum
	LEFT JOIN clinic ON clinic.ClinicNum=cp.ClinicNum
	WHERE (cp.Status=1 OR cp.Status=4) 
	AND claimpay.CheckDate BETWEEN @FromDate AND @ToDate
	GROUP BY cp.PatNum,cp.ProvNum,cp.PlanNum,cp.ClinicNum,claimpay.CheckDate
) result
GROUP BY YEAR(result.Date),MONTH(result.Date)
ORDER BY result.Date
