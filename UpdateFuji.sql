-- IN PROGRES!!!!!!!!!!!!!!!!!!!!!!!

-- Update new code for "Fuji"


UPDATE procedurecode Old, procedurecode New
SET New.ProcCode=@NewCode,
New.Descript="Filling - Fuji",
New.AbbrDesc="Fill Fuji",
New.ProcTime=,
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
