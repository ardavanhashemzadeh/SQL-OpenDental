-- Needed to quickly update many users on a very remote instance
-- and didn't wish to login to the desktop or move files around
-- This query will output the queries necessary to add a CEMT user num
-- to the "duplicate" users who don't have one already

SELECT CONCAT("UPDATE userod SET usernumcemt=",usernumcemt," WHERE username='",username,"';") FROM userod WHERE username IN (ListOfUsers);
