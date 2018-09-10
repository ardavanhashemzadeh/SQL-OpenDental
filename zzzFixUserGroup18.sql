/* Ardavan Hashemzadeh
** September 10 20118
** Insert row in UserGroupAttach table
** if it doesn't exist already */

SET @username='';

INSERT INTO usergroupattach(usernum, usergroupnum)
SELECT uo.usernum, uo.usergroupnum FROM userod uo
LEFT JOIN usergroupattach uga ON uo.usernum=uga.usernum AND uo.usergroupnum=uga.usergroupnum
WHERE username LIKE @username
AND uga.usernum IS NULL;

SELECT ishidden, username, password, description FROM userod NATURAL LEFT JOIN usergroup WHERE username LIKE @username;
