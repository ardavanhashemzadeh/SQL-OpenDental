/* Ardavan Hashemzadeh
   Published July 21 2018
*/

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
