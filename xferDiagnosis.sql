/* Define variables */
SET @Category=16;

/* EXPORT DATA */
/* Export data from source */
SELECT ItemOrder, ItemName, ItemValue FROM definition WHERE Category=@Category AND isHidden=0 INTO OUTFILE "\\\\serveroheight\\share\\rdtempdefs04052018.txt";

/* IMPORT DATA */
/* Clean up the unused definitions and its temporary table */
DROP TABLE IF EXISTS rduseddefs;
CREATE TABLE rduseddefs(DefNum bigint(20));
INSERT INTO rduseddefs(DefNum)
SELECT DISTINCT dx FROM procedurelog;
DELETE FROM definition WHERE Category=@Category AND DefNum NOT IN (SELECT DefNum FROM rduseddefs);
DROP TABLE IF EXISTS rduseddefs;


/* Create temporary tables on destination (dropping first if they exists) */
DROP TABLE IF EXISTS rdtempdef;
CREATE TABLE rdtempdef(ItemOrder smallint(5), ItemName varchar(255), ItemValue varchar(255));

/* Populate temporary table */
LOAD DATA LOCAL INFILE "\\\\serveroheight\\share\\rdtempdefs04052018.txt" INTO TABLE rdtempdef;

/* Hide existing items and push bottom of the list */
SET @TheCount = (SELECT COUNT(*) FROM rdtempdef);
UPDATE definition SET isHidden=1, ItemOrder=ItemOrder+@TheCount WHERE Category=@Category;

/* Insert new items into main table */
INSERT INTO definition(Category, ItemOrder, ItemName, ItemValue)
SELECT DISTINCT @Category AS Category, rd.ItemOrder, rd.ItemName, rd.ItemValue
FROM rdtempdef rd LEFT JOIN definition d ON rd.ItemName LIKE d.ItemName
WHERE d.ItemName IS NULL;

/* Update existing items which already existed */
UPDATE definition d JOIN rdtempdef rd ON d.ItemName LIKE rd.ItemName
SET d.ItemOrder=rd.ItemOrder, d.ItemName=rd.ItemName, d.ItemValue=rd.ItemValue, d.isHidden=0
WHERE d.Category=@Category;

/* Send update signal to OpenDental */
INSERT INTO signalod(SigDateTime, IType)
VALUES(NOW(), 14);

/* Delete temporary table */
DROP TABLE IF EXISTS rdtempdef;
