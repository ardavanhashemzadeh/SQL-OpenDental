/* Ardavan Hashemzadeh
** September 10 2018
** Insert or Update OD user creating usergroup
** if it doesn't exist already */
SET @olduname='';
SET @username='';
SET @password='';
SET @usergroup='';
INSERT INTO usergroup(Description)
SELECT @usergroup AS Description FROM (SELECT NULL) PlaceHolder
WHERE NOT EXISTS (SELECT Description FROM usergroup WHERE Description LIKE @usergroup);
INSERT INTO userod(username, password, usergroupnum)
SELECT @username AS username, @password AS password,
(SELECT usergroupnum FROM usergroup WHERE description LIKE @usergroup LIMIT 1) AS usergroupnum
FROM (SELECT NULL) PlaceHolder WHERE @username<>'' AND NOT EXISTS
(SELECT username FROM userod WHERE username=@username UNION SELECT username FROM userod WHERE username=@olduname);
UPDATE userod SET ishidden=0 WHERE username=@olduname OR username=@username;
UPDATE userod SET username=@username WHERE @olduname<>'' AND username=@olduname;
UPDATE userod SET password=@password WHERE @password<>'' AND username=@username;
UPDATE userod SET usergroupnum=(SELECT usergroupnum FROM usergroup WHERE description LIKE @usergroup LIMIT 1)
WHERE @usergroup<>'' AND username = @username;

INSERT INTO usergroupattach(usernum, usergroupnum)
SELECT uo.usernum, uo.usergroupnum FROM userod uo
LEFT JOIN usergroupattach uga ON uo.usernum=uga.usernum AND uo.usergroupnum=uga.usergroupnum
WHERE username LIKE @username
AND uga.usernum IS NULL;

SELECT ishidden, username, password, description FROM userod NATURAL LEFT JOIN usergroup WHERE username LIKE @username;
