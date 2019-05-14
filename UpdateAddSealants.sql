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
VALUES(
"D1353F", -- ProcCode,
"Sealant - Fuji - Per Tooth", -- Descript,
"Fuji Seal", -- AbbrDesc,
"/X/", -- ProcTime,
@ProcCat, -- ProcCat,
2, -- TreatArea,
0, -- NoBillIns,
0, -- IsProsth,
"Bla Bla Bla", -- DefaultNote,
1, -- IsHygiene,
11, -- GTypeNum,
0, -- IsTaxed,
13, -- PaintType,
-6291971, -- GraphicColor,
0, -- IsCanadianLab,
1, -- PreExisting,
0, -- BaseUnits,
0, -- SubstOnlyIf,
0, -- IsMultiVisit,
0, -- ProvNumDefault,
1, -- CanadaTimeUnits,
0, -- IsRadiology,
0 -- BypassGlobalLock
)

