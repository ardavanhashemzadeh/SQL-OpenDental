UPDATE preference SET ValueString="9dUWCG1BYk" WHERE PrefName="CentralManagerSyncCode";
SELECT ValueString FROM preference WHERE PrefName="CentralManagerSyncCode"\G

SELECT UserName, UserNumCEMT FROM userod INTO OUTFILE "/rdCEMTusers";

/* Create and populate temporary table */
CREATE TABLE rdtempusers(UserName varchar(255), UserNumCEMT bigint(20));
LOAD DATA INFILE "/rdCEMTusers" INTO TABLE rdtempusers
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';

/* Add the CEMT user numbers */
UPDATE userod od JOIN rdtempusers rd USING(UserName)
SET od.UserNumCEMT=rd.UserNumCEMT;

/* Cleanup temporary table */
DROP TABLE rdtempusers;

/* Fix the 0 index issue */
UPDATE userod SET isHidden=0, UserNumCEMT=0 WHERE UserName="Show CEMT users";

/* Confirm there are non hidden non CEMT users */
SELECT UserName FROM userod WHERE UserNumCEMT=0 AND isHidden=0\G
