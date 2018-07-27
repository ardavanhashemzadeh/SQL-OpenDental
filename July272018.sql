/* Count how many instances of a username */
SELECT UserName, COUNT(*) AS TheCount FROM userod GROUP BY username;

/* List the usernames which appear more than once */
SELECT UserName, TheCount FROM (SELECT UserName, COUNT(*) AS TheCount FROM userod GROUP BY username) tc  WHERE TheCount > 1;

/* Select the highest usernum of usernames which appear more than once (ordered by UserName) */
SELECT UserName, MAX(UserNum) AS DuplUserNum FROM
(SELECT UserName FROM (SELECT UserName, COUNT(*) AS TheCount FROM userod GROUP BY username) tc  WHERE TheCount > 1) rd
NATURAL JOIN userod od GROUP BY UserName ORDER BY UserName;

/* Change the username, CEMT usernum, and hidden flag of users who appear more than once */
UPDATE userod SET UserName=CONCAT("Z-Duplicate-",UserName), UserNumCEMT=0, isHidden=1 WHERE UserNum IN (
	SELECT DuplUserNum FROM (
		SELECT UserName, MAX(UserNum) AS DuplUserNum FROM (
			SELECT UserName FROM (
				SELECT UserName, COUNT(*) AS TheCount FROM userod GROUP BY username
				) TheUsernameInstanceCountTable 
			WHERE TheCount > 1
			) TheMultipleUsernameListTable
		NATURAL JOIN userod od GROUP BY UserName ORDER BY UserName
		) TheUsernameAndHighestUsernumOfDuplicatesTable
	)

/* Remove leading and trailing spaces from usernames */
UPDATE userod SET UserName=TRIM(UserName);
