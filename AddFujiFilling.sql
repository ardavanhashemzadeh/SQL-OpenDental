-- IN PROGRES!!!!!!!!!!!!!!!!!!!!!!!

-- Update new code for "Fuji"
SET @OldCode='D2940';
SET @NewCode='D2940F';

UPDATE (SELECT * FROM procedurecode WHERE ProcCode=@OldCode) AS OldTbl, procedurecode AS NewTbl
SET NewTbl.Descript="Filling - Fuji",
NewTbl.AbbrDesc="Fill Fuji",
NewTbl.ProcTime=OldTbl.ProcTime,
NewTbl.ProcCat=OldTbl.ProcCat,
NewTbl.TreatArea=OldTbl.TreatArea,
NewTbl.NoBillIns=OldTbl.NoBillIns,
NewTbl.IsProsth=OldTbl.IsProsth,
NewTbl.DefaultNote=OldTbl.DefaultNote,
NewTbl.IsHygiene=OldTbl.IsHygiene,
NewTbl.GTypeNum=OldTbl.GTypeNum,
NewTbl.IsTaxed=OldTbl.IsTaxed,
NewTbl.PaintType=OldTbl.PaintType,
NewTbl.GraphicColor=-256,
NewTbl.IsCanadianLab=OldTbl.IsCanadianLab,
NewTbl.PreExisting=OldTbl.PreExisting,
NewTbl.BaseUnits=OldTbl.BaseUnits,
NewTbl.SubstOnlyIf=OldTbl.SubstOnlyIf,
NewTbl.IsMultiVisit=OldTbl.IsMultiVisit,
NewTbl.ProvNumDefault=OldTbl.ProvNumDefault,
NewTbl.CanadaTimeUnits=OldTbl.CanadaTimeUnits,
NewTbl.IsRadiology=OldTbl.IsRadiology,
NewTbl.BypassGlobalLock=OldTbl.BypassGlobalLock
WHERE NewTbl.ProcCode=@NewCode;
