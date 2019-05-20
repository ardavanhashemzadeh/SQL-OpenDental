-- Ardavan Hashemzadeh
-- Add code for missing sealants

-- Insert new code for "Fuji" brand
SET @ProcCat=(SELECT ProcCat FROM procedurecode WHERE ProcCode="D1351" LIMIT 1);
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
"N1351F" AS ProcCode,
"Missing Sealant - Sealant applied in previous treatment is missing." AS Descript,
"Missing Sealant" AS AbbrDesc,
"/X/" AS ProcTime,
@ProcCat AS ProcCat,
2 AS TreatArea,
0 AS NoBillIns,
0 AS IsProsth,
"Sealant applied previously not present" AS DefaultNote,
1 AS IsHygiene,
11 AS GTypeNum,
0 AS IsTaxed,
13 AS PaintType,
-256 AS GraphicColor,
0 AS IsCanadianLab,
1 AS PreExisting,
0 AS BaseUnits,
0 AS SubstOnlyIf,
0 AS IsMultiVisit,
0 AS ProvNumDefault,
1 AS CanadaTimeUnits,
0 AS IsRadiology,
0 AS BypassGlobalLock
) NewCode
LEFT JOIN procedurecode OldCode USING(ProcCode)
WHERE OldCode.ProcCode IS NULL;

-- Inform OD of the change
SET @DTS=(SELECT NOW());
INSERT INTO signalod (DateViewing,SigDateTime,FKey,FKeyType,IType,RemoteRole,MsgValue) VALUES('0001-01-01',@DTS,0,'Undefined',4,0,'');

