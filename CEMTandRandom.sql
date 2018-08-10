/* Delete unused users (18.1) */
DELETE FROM userod WHERE
usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM adjustment)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM alertread)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM appointment)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM carrier)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM cdspermission)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM claim)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM claimpayment)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM claimproc)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM commlog)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM dashboardlayout)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM emailaddress)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM emailmessage)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM entrylog)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM erxlog)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM etrans)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM emailmessage)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM fee)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM feesched)
AND usernum NOT IN (SELECT DISTINCT HistUserNum FROM histappointment)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM histappointment)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM inseditlog)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM insplan)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM inssub)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM insverify)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM insverifyhist)
AND usernum NOT IN (SELECT DISTINCT VerifyUserNum FROM insverifyhist)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM journalentry)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEdit FROM journalentry)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM orthochart)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM patfield)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM patient)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM payment)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM paysplit)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM popup)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM procedurelog)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM procnote)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM proctp)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM securitylog)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM task)
AND usernum NOT IN (SELECT DISTINCT UserNumHist FROM taskhist)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM tasklist)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM tasknote)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM tasksubscription)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM taskunread)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM transaction)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEdit FROM transaction)
AND usernum NOT IN (SELECT DISTINCT SecUserNumEntry FROM treatplan)
AND usernum NOT IN (SELECT DISTINCT UserNumPresenter FROM treatplan)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM tsitranslog)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM userclinic)
/* AND usernum NOT IN (SELECT DISTINCT UserNum FROM usergroupattach) */
/* AND usernum NOT IN (SELECT DISTINCT UserNumCEMT FROM userod) */
AND usernum NOT IN (SELECT DISTINCT UserNum FROM userodapptview)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM userodpref)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM vaccinedef)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM wikilisthist)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM wikipage)
AND usernum NOT IN (SELECT DISTINCT UserNum FROM wikipagehist);
DELETE FROM usergroupattach WHERE usernum NOT IN (SELECT DISTINCT UserNum FROM userod);

/* Find all user and group information about a few specific users */
SELECT * FROM userod u LEFT JOIN usergroupattach uga ON u.usernum=uga.usernum
LEFT JOIN usergroup ug ON uga.usergroupnum=ug.usergroupnum
WHERE username LIKE "zzz" OR username LIKE "nath%ona" \G

/* Find all users who do not have an entry in the usergroupattach table */
SELECT username FROM userod WHERE usernum NOT IN (SELECT DISTINCT usernum FROM usergroupattach);

/* Find all users who are not associated with a group */
SELECT username, uga.* FROM userod JOIN usergroupattach uga USING (usernum) WHERE uga.usergroupnum=0;

/* Check on syncing status by counting users and displaying usergroups and attachments */
SELECT COUNT(*) AS Users FROM userod; SELECT * FROM usergroup; SELECT COUNT(*) AS UserGroupAttachments FROM usergroupattach;

/* Add security admin permission to group named like Security*admin* if the perm doesn't exist */
SET @GroupName="Security%Admin%";
INSERT INTO grouppermission(UserGroupNum, PermType)
SELECT UserGroupNum, 24 AS PermType
FROM usergroup WHERE Description LIKE @GroupName AND NOT EXISTS
(SELECT PermType FROM usergroup NATURAL JOIN grouppermission WHERE Description LIKE @GroupName AND PermType=24 LIMIT 1);

SET @GroupName="Security%Admin%";
INSERT INTO grouppermission(UserGroupNum, PermType)
SELECT UserGroupNum, 24 AS PermType
FROM usergroup WHERE Description LIKE @GroupName AND
(SELECT PermType FROM usergroup NATURAL JOIN grouppermission WHERE Description LIKE @GroupName AND PermType=24 LIMIT 1)
IS NULL;

/* Display username and group of particular user (does not work on versions after 17.2 because of the new usergroupattach table) */
SELECT username, description, usernumcemt FROM userod NATURAL JOIN usergroup WHERE username LIKE "zzz"

/* Show all groups with the Secuirty admin permission */
SELECT Description, PermType FROM usergroup NATURAL JOIN grouppermission WHERE permtype=24;

/* Show all users and their group whose groups have the Security Admin permission */
SELECT username, description, permtype, usernumcemt, userod.ishidden FROM userod NATURAL JOIN usergroup NATURAL JOIN grouppermission WHERE permtype=24;

/* Display the permission type, usergroup number and description, usernum, and username of users having Security Admin permission */
SELECT (SELECT userod.UserName FROM userod WHERE userod.UserNum=usergroupattach.UserNum) Username,
grouppermission.PermType,
usergroupattach.UserGroupNum,
usergroup.Description,
usergroupattach.UserNum
FROM grouppermission INNER JOIN usergroupattach ON usergroupattach.usergroupnum=grouppermission.usergroupnum
INNER JOIN usergroup ON usergroup.UserGroupNum=usergroupattach.UserGroupNum
WHERE grouppermission.PermType=24;

/* Add all hidden users to the hidden group */
UPDATE userod SET usergroupnum=(SELECT usergroupnum FROM usergroup WHERE description LIKE "%hidden" LIMIT 1) WHERE ishidden=1;

/* Update the usergroupattach table to reflect the usergroup from the userod table */
UPDATE usergroupattach uga JOIN userod uo ON uga.usernum=uo.usernum
SET uga.usernum=uo.usernum, uga.usergroupnum=uo.usergroupnum;

/* Create a local (non CEMT) user named "Show CEMT Users" who has the Security Admin permission but no usable password */
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

/* Show computers with an AtoZpath override clear the override then confirm */
SELECT ComputerName, AtoZpath FROM computerpref WHERE AtoZpath <> '';
UPDATE computerpref SET AtoZpath='' WHERE AtoZpath <> '';
SELECT ComputerName, AtoZpath FROM computerpref WHERE AtoZpath <> '';

/* Send a signal to OpenDental that changes have been made to security settings */
INSERT INTO signalod(SigDateTime,IType,FKeyType) VALUES(NOW(),19,"Undefined");

/* Display user information */
SELECT username, usernum, usernumcemt FROM userod;

/* Experimenting with federated tables (did not work as expected) */
CREATE TABLE woodsideuserod(
	UserNum bigint(20),
	UserName varchar(255),
	Password varchar(255),
	UserGroupNum bigint(20))
ENGINE=FEDERATED
CONNECTION="mysql://username:password@server:port/database/table";

/* Insert row into usergroupattach table for users who do not have an entry */
INSERT INTO usergroupattach(UserNum, UserGroupNum)
SELECT UserNum, UserGroupNum FROM userod WHERE usernum NOT IN (SELECT usernum FROM usergroupattach);

/* Display user information from userod table */
SELECT username, usernum, usernumcemt, usergroupnum FROM userod;

/* Count how many users per each group */
SELECT Description, COUNT(*) FROM userod NATURAL JOIN usergroup GROUP BY usergroup.usergroupnum ORDER BY Description;

/* Look for duplicate group names */
SELECT COUNT(*) AS TheCount, Description FROM usergroup GROUP BY Description;
