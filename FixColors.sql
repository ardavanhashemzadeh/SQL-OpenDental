-- Fix issues caused by blind automation

-- Recon

select proccode, abbrdesc, graphiccolor from procedurecode where graphiccolor<>0;

-- Fix treat area of fillings
UPDATE procedurecode SET TreatArea=1,PaintType=6 WHERE proccode IN ('D2940F', 'D2940', 'N2940');


-- Inform OD of the changes
SET @DTS=(SELECT NOW());
INSERT INTO signalod (DateViewing,SigDateTime,FKey,FKeyType,IType,RemoteRole,MsgValue) VALUES('0001-01-01',@DTS,0,'Undefined',4,0,'');
