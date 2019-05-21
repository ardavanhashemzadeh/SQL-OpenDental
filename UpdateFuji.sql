-- IN PROGRES!!!!!!!!!!!!!!!!!!!!!!!

-- Update new code for "Fuji"
SET @OldCode='D2940';
SET @NewCode='D2940F';

UPDATE procedurecode AS Old, procedurecode AS New
SET New.Descript="Filling - Fuji",
New.AbbrDesc="Fill Fuji",
New.ProcTime=Old.ProcTime,
New.ProcCat=Old.ProcCat,
New.TreatArea=Old.TreatArea,
New.NoBillIns=Old.NoBillIns,
New.IsProsth=Old.IsProsth,
New.DefaultNote=Old.DefaultNote,
New.IsHygiene=Old.IsHygiene,
New.GTypeNum=Old.GTypeNum,
New.IsTaxed=Old.IsTaxed,
New.PaintType=Old.PaintType,
New.GraphicColor=-256,
New.IsCanadianLab=Old.IsCanadianLab,
New.PreExisting=Old.PreExisting,
New.BaseUnits=Old.BaseUnits,
New.SubstOnlyIf=Old.SubstOnlyIf,
New.IsMultiVisit=Old.IsMultiVisit,
New.ProvNumDefault=Old.ProvNumDefault,
New.CanadaTimeUnits=Old.CanadaTimeUnits,
New.IsRadiology=Old.IsRadiology,
New.BypassGlobalLock=Old.BypassGlobalLock
WHERE Old.ProcCode=@OldCode AND New.ProcCode=@NewCode;
