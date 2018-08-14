/* Create(or update) a local (non CEMT) user named "Show CEMT Users" who has the Security Admin permission but no usable password */
INSERT INTO userod(UserName)
SELECT "Show CEMT Users" FROM (SELECT NULL) PlaceHolder WHERE NOT EXISTS (SELECT username FROM userod WHERE username LIKE "%CEMT%");
UPDATE userod SET
password=0,
ishidden=0,
usernumcemt=0,
usergroupnum=(SELECT usergroupnum FROM grouppermission WHERE permtype=24 LIMIT 1)
WHERE username LIKE "Show CEMT Users";
INSERT INTO usergroupattach(usernum, usergroupnum)
SELECT uo.usernum, uo.usergroupnum FROM userod uo
LEFT JOIN usergroupattach uga ON uo.usernum=uga.usernum AND uo.usergroupnum=uga.usergroupnum
WHERE username LIKE "Show CEMT Users"
AND uga.usernum IS NULL;
