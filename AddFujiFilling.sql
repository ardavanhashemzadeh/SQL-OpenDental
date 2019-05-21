-- INCOMPLETE, copypasted from previous query but needs major modifications!!!!!!!!!!

-- IN PROGRES!!!!!!!!!!!!!!!!!!!!!!!

-- Update new code for "Fuji"
SET @OldCode='D2940';
SET @NewCode='D2940F';

-- Insert new code for "Fuji"
INSERT INTO procedurecode(
ProcCode,
Descript,
AbbrDesc,
ProcTime,
ProcCat,
TreatArea,
NoBillIns,
IsProsth,
DefaultNote,
IsHygiene,
GTypeNum,
IsTaxed,
PaintType,
GraphicColor,
IsCanadianLab,
PreExisting,
BaseUnits,
SubstOnlyIf,
IsMultiVisit,
ProvNumDefault,
CanadaTimeUnits,
IsRadiology,
BypassGlobalLock
)
SELECT NewCode.* FROM (SELECT
@NewCode AS ProcCode,
"Filling - Fuji" AS Descript,
"Fill Fuji" AS AbbrDesc,
ProcTime,
ProcCat,
TreatArea,
NoBillIns,
IsProsth,
DefaultNote,
IsHygiene,
GTypeNum,
IsTaxed,
PaintType,
-256 AS GraphicColor,
IsCanadianLab,
PreExisting,
BaseUnits,
SubstOnlyIf,
IsMultiVisit,
ProvNumDefault,
CanadaTimeUnits,
IsRadiology,
BypassGlobalLock
FROM procedurecode WHERE ProcCode=@OldCode
) NewCode
LEFT JOIN procedurecode OldCode USING(ProcCode)
WHERE OldCode.ProcCode IS NULL;

-- Inform OD of the change
SET @DTS=(SELECT NOW());
INSERT INTO signalod (DateViewing,SigDateTime,FKey,FKeyType,IType,RemoteRole,MsgValue) VALUES('0001-01-01',@DTS,0,'Undefined',4,0,'');

-- Copy fees from existing code
INSERT INTO fee(Amount, OldCode, FeeSched, UseDefaultFee, UseDefaultCov, CodeNum, ClinicNum, ProvNum)
SELECT NewFee.* FROM (SELECT Amount, OldCode, FeeSched, UseDefaultFee, UseDefaultCov, (SELECT CodeNum FROM procedurecode WHERE ProcCode = @NewCode LIMIT 1) AS CodeNum, ClinicNum, ProvNum FROM fee WHERE CodeNum=(SELECT CodeNum FROM procedurecode WHERE ProcCode=@OldCode)) NewFee
LEFT JOIN (SELECT FeeSched, CodeNum FROM fee WHERE CodeNum IN (SELECT CodeNum FROM procedurecode WHERE ProcCode=@NewCode)) OldFee
USING(FeeSched,CodeNum) WHERE OldFee.CodeNum IS NULL;


-- Inform OD of the change
SET @DTS=(SELECT NOW());
INSERT INTO signalod (DateViewing,SigDateTime,FKey,FKeyType,IType,RemoteRole,MsgValue)
SELECT DISTINCT '0001-01-01' AS DateViewing,
@DTS AS SigDateTime,
FeeSched AS FKey,
'FeeSched' AS FKeyType,
16 AS IType,
0 AS RemoteRole,
'' AS MsgValue
FROM fee WHERE CodeNum IN (SELECT CodeNum FROM procedurecode WHERE ProcCode=@NewCode);
