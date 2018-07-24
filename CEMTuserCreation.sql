/* Change some usernames */
UPDATE userod SET UserName="Dummy.User" WHERE UserName IN ("Administrator", "Admin2", "AA")

/* List all users */
SELECT UserName FROM userod ORDER BY UserName;

/* Create and populate temporary table */
CREATE TABLE rdtempusers(UserName varchar(255));
LOAD DATA INFILE "\\rdtest.tsv" INTO TABLE rdtempusers LINES TERMINATED BY '\r\n';

/* Add users which don't exist */
INSERT INTO userod(UserName,UserGroupNum,isHidden)
SELECT DISTINCT rd.UserName, (SELECT UserGroupNum FROM usergroup WHERE Description LIKE "hidden") UserGroupNum, 1
FROM rdtempusers rd LEFT JOIN userod od ON rd.UserName=od.UserName
WHERE od.UserName IS NULL ORDER BY rd.UserName;

/* Cleanup temporary table */
DROP TABLE rdtempusers;

/* Give CEMT usernum to all users */
UPDATE userod SET UserNumCEMT=UserNum;
