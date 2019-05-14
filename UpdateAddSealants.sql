-- Update existing sealant code to state "SealRite" brand
UPDATE procedurecode SET Descript="Sealant - SealRite - Per Tooth", AbbrDesc="SealRite Seal" WHERE ProcCode="D1351";

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
"D1351F" AS ProcCode,
"Sealant - Fuji - Per Tooth" AS Descript,
"Fuji Seal" AS AbbrDesc,
"/X/" AS ProcTime,
@ProcCat AS ProcCat,
2 AS TreatArea,
0 AS NoBillIns,
0 AS IsProsth,
"TEETH WERE ISOLATED, CHECKED FOR CARIES FREE STATUS ON SURFACE TO BE SEALED.  TWO STEP BONDING USED: 38% PHOSPHORIC ACID USED TO ETCH SURFACE,  AND PLACED BONDING RESIN.  SEALANTS APPLIED AND CURED TO ALLOCATED TOOTH. CHECKED FOR SMOOTHNESS. MOUTH FULLY IRRIGATED POST-TREATMENT." AS DefaultNote,
1 AS IsHygiene,
11 AS GTypeNum,
0 AS IsTaxed,
13 AS PaintType,
-6291971 AS GraphicColor,
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
WHERE OldCode.ProcCode IS NULL
