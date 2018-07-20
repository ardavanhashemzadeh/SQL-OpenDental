/* Ardavan Hashemzadeh
   Started July 21 2018
   Random queries
*/

/* Count insurance plans of certain carriers */
SET @CarrierName="Liberty Dental%";
SELECT GroupName, GroupNum, Description AS Carrier, COUNT(*) AS Plans
FROM insplan ip JOIN feesched fs ON ip.FeeSched=fs.FeeSchedNum WHERE carriernum IN (
SELECT carriernum FROM carrier WHERE carriername LIKE @CarrierName)
GROUP BY GroupName, GroupNum, Description
