-- In an effort to quickly migrate standard users to "CEMT" users I simply added a UserGroupNumCEMT
-- The unforseen consequence was that permissions weren't syncing properly
-- These lines helped resolve the issue in our environment, it may break yours

-- Fix permission issues for local users migrated to CEMT
-- The problem seems to be that OD is using the local userg

UPDATE userod SET UserGroupNum=0 WHERE username NOT LIKE "%Show CEMT users%";

-- Inform OD of the changes
SET @DTS=NOW();
INSERT INTO signalod (DateViewing,SigDateTime,FKey,FKeyType,IType,RemoteRole,MsgValue) VALUES('0001-01-01',@DTS,0,'Undefined',19,0,'')
