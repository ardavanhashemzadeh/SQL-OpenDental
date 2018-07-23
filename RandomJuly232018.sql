SELECT * FROM usergroup INTO OUTFILE "wsusergroup.txt";
SELECT * FROM grouppermission INTO OUTFILE "wsgrouppermission.txt";
SELECT * FROM userod INTO OUTFILE "wsuserod.txt";


LOAD DATA INFILE "wsusergroup.txt" INTO TABLE usergroup;
LOAD DATA INFILE "wsgrouppermission.txt" INTO TABLE grouppermission;
LOAD DATA INFILE "wsuserod.txt" INTO TABLE userod;




SELECT UserName, UserNumCEMT FROM userod WHERE isHidden=0 INTO OUTFILE "cemtusernums.tsv";



DROP TABLE IF EXISTS rdtempcemtusers;

CREATE TABLE rdtempcemtusers(UserName varchar(255), UserNumCEMT bigint(20));

LOAD DATA INFILE "cemtusernums.tsv" INTO TABLE rdtempcemtusers;

UPDATE userod uo JOIN rdtempcemtusers rduo USING(UserName) SET uo.UserNumCEMT=rduo.UserNumCEMT;

DROP TABLE IF EXISTS rdtempcemtusers;

UPDATE userod SET isHidden=0, UserNumCEMT=0 WHERE UserName="Admin";
UPDATE userod SET UserName="Check box labled: Show CEMT users" WHERE UserName="Admin";




UPDATE userod SET UserName="Show CEMT users" WHERE UserName="Check box labled: Show CEMT users";



SELECT * FROM definition WHERE Category=3 AND (ItemName LIKE "Pano" OR ItemValue LIKE "%D0330%");



INSERT INTO definition(Category, ItemName, ItemValue)
SELECT 3, "PANO", "D0330" FROM (SELECT NULL) PlaceHolder
WHERE NOT EXISTS (SELECT ItemValue FROM Definition WHERE Category=3 AND ItemValue="D0330" LIMIT 1);

UPDATE definition SET ItemName="PANO", isHidden=0 WHERE ItemValue="D0330";

SELECT * FROM definition WHERE Category=3 AND (ItemName LIKE "Pano" OR ItemValue LIKE "D0330")\G
