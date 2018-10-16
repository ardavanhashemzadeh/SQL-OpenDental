/* Registration Key */
SELECT * FROM preference WHERE prefname LIKE 'RegistrationKey';
UPDATE preference SET ValueString=':)' WHERE PrefName='RegistrationKey';

/*
*
*
*
*
*
*/

/* Diagnosis stuffs */
/* EXPORT DATA */
/* Export data from source */
SELECT ItemOrder, ItemName, ItemValue FROM definition WHERE Category=16 AND isHidden=0 INTO OUTFILE "";

/* IMPORT DATA */
/* Define variables */
SET @Category=16;

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
LOAD DATA LOCAL INFILE "\\\\server\\folder\\file.txt" INTO TABLE rdtempdef;

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


/*
*
*
*
*
*
*/

/* Insert Provider */


/* Provider Information */
SET @Abbr="";
SET @LName="";
SET @FName="";
SET @MI="";
SET @Suffix="";
SET @FeeSched="";
SET @Specialty="General";
SET @SSN="";
SET @StateLicense="";
SET @DEANum="";
SET @IsSecondary=0;
SET @ProvColor=0;
SET @UsingTIN=0;
SET @BlueCrossID="";
SET @SigOnFile=1;
SET @MedicaidID="";
SET @OutlineColor=0;
SET @NationalProvID="";
SET @TaxonomyCodeOverride="";
SET @IsCDAnet=0;
SET @EcwID="";
SET @StateRxID="";
SET @IsNotPerson=0;
SET @StateWhereLicensed="NY";
SET @IsInstructor=0;
SET @EhrMuStage=0;
SET @CustomID="";
SET @ProvStatus=0;

/* Create Speciality if it doesn't exit */
/* The category number for Specialty in the Definition table */
SET @Category=35;
/* Place the new specialty at the end of the list */
SET @SpecialtyItemOrder=(SELECT COALESCE(MAX(ItemOrder) + 1,0) AS ItemOrder FROM Definition WHERE Category=@Category AND IsHidden=0);
UPDATE Definition SET ItemOrder=ItemOrder+1 WHERE Category=@Category AND ItemOrder >= @SpecialtyItemOrder;

/* Unhide the specialty if it is hidden */
UPDATE Definition SET IsHidden=0 WHERE Category=@Category AND ItemName=@Specialty;

/* Insert the speciality into the table if it doesn't exist */
INSERT INTO Definition(Category, ItemOrder, ItemName)
SELECT @Category, @SpecialtyItemOrder, @Specialty
FROM (SELECT NULL) PlaceHolder
WHERE NOT EXISTS (SELECT ItemName FROM Definition WHERE Category=@Category AND ItemName=@Specialty AND IsHidden=0);

/* Get the reference number for the speciality */
SET @SpecialtyRef = COALESCE((SELECT DefNum FROM Definition WHERE Category=@Category AND ItemName=@Specialty AND IsHidden=0 LIMIT 1),0);

/* Place the new provider at the bottom of the list, but above the hidden providers */
SET @ProviderItemOrder=(SELECT COALESCE(MAX(ItemOrder) + 1,0) AS ItemOrder FROM Provider WHERE IsHidden=0);
UPDATE Provider SET ItemOrder=ItemOrder+1 WHERE ItemOrder => @SpecialtyItemOrder;


/* Insert the provider if they do not already exist */
INSERT INTO provider(
	ItemOrder,
	Abbr,
	LName,
	FName,
	MI,
	Suffix,
	FeeSchedule,
	Specialty,
	SSN,
	StateLicense,
	DEANum,
	IsSecondary,
	ProvColor,
	UsingTIN,
	BlueCrossID,
	SigOnFile,
	MedicaidID,
	OutlineColor,
	NationalProvID,
	TaxonomyCodeOverride,
	IsCDAnet,
	EcwID,
	StateRxID,
	IsNotPerson,
	StateWhereLicensed,
	IsInstructor,
	EhrMuStage,
	CustomID,
	ProvStatus
	)
VALUES(
	@ProviderItemOrder,
	@Abbr,
	@LName,
	@FName,
	@MI,
	@Suffix,
	@FeeSchedule,
	@Specialty,
	@SSN,
	@StateLicense,
	@DEANum,
	@IsSecondary,
	@ProvColor,
	@UsingTIN,
	@BlueCrossID,
	@SigOnFile,
	@MedicaidID,
	@OutlineColor,
	@NationalProvID,
	@TaxonomyCodeOverride,
	@IsCDAnet,
	@EcwID,
	@StateRxID,
	@IsNotPerson,
	@StateWhereLicensed,
	@IsInstructor,
	@EhrMuStage,
	@CustomID,
	@ProvStatus
	)
  
  
