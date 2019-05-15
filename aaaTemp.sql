-- Work in progress

select * from fee where codenum=(select codenum from procedurecode where proccode="D1351" limit 1);




INSERT INTO fee(Amount, OldCode, FeeSched, UseDefaultFee, UseDefaultCov, CodeNum, ClinicNum, ProvNum)
SELECT * FROM (SELECT Amount, OldCode, FeeSched, UseDefaultFee, UseDefaultCov, (SELECT CodeNum FROM procedurecode WHERE ProcCode = "D1351F" LIMIT 1) AS CodeNum, ClinicNum, ProvNum FROM fee WHERE CodeNum=(SELECT CodeNum FROM procedurecode WHERE ProcCode="D1351")) NewFee
LEFT JOIN (SELECT Amount, OldCode, FeeSched, UseDefaultFee, UseDefaultCov, (SELECT CodeNum FROM procedurecode WHERE ProcCode = "D1351F" LIMIT 1) AS CodeNum, ClinicNum, ProvNum FROM fee WHERE CodeNum=(SELECT CodeNum FROM procedurecode WHERE ProcCode="D1351")) OldFee
USING(FeeSched,CodeNum)







-- Copy fees from existing code
INSERT INTO fee(Amount, OldCode, FeeSched, UseDefaultFee, UseDefaultCov, CodeNum, ClinicNum, ProvNum)
SELECT NewFee.* FROM (SELECT Amount, OldCode, FeeSched, UseDefaultFee, UseDefaultCov, (SELECT CodeNum FROM procedurecode WHERE ProcCode = "D1351F" LIMIT 1) AS CodeNum, ClinicNum, ProvNum FROM fee WHERE CodeNum=(SELECT CodeNum FROM procedurecode WHERE ProcCode="D1351")) NewFee
LEFT JOIN (SELECT Amount, OldCode, FeeSched, UseDefaultFee, UseDefaultCov, (SELECT CodeNum FROM procedurecode WHERE ProcCode = "D1351F" LIMIT 1) AS CodeNum, ClinicNum, ProvNum FROM fee WHERE CodeNum=(SELECT CodeNum FROM procedurecode WHERE ProcCode="D1351")) OldFee
USING(FeeSched,CodeNum) WHERE OldFee.CodeNum IS NULL
