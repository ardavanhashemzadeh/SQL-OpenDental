/* Just a small hack to take me back and fill the crack */

select * from userodpref where usernum=(SELECT usernum FROM userod WHERE username LIKE "The Local User");

INSERT INTO userodpref(UserNum, Fkey, FkeyType, ValueString, ClinicNum)
SELECT u.usernum, p.Fkey, p.FkeyType, p.ValueString, p.ClinicNum
FROM userod u, userodpref p
WHERE u.username LIKE "TheCEMTuser"
AND p.UserNum=(SELECT UserNum FROM userod WHERE UserName LIKE "The Local User")
AND p.FkeyType=11;
