/* Add Carrier to OpenDental
   Ardavan Hashemzadeh
   July 11 2018
*/

SET @CarrierNameLike = "Liberty Dent%",
@CarrierName = "Liberty Dental Plan",
@Address = "P.O. Box 26110",
@Address2 = "Attn: Claims Department",
@City = "Santa Ana",
@State = "CA",
@Zip = "9277-7924",
@Phone = "1(888)355-7924",
@ElectID = "CX083";

INSERT INTO carrier(CarrierName)
SELECT @CarrierName FROM (SELECT "String") FillerTable WHERE (
SELECT CarrierName FROM carrier WHERE CarrierName LIKE @CarrierNameLike LIMIT 1) IS NULL;

UPDATE carrier SET
CarrierName = @CarrierName,
Address = @Address,
Address2 = @Address2,
City = @City,
State = @State,
Zip = @Zip,
Phone = @Phone,
ElectID = @ElectID
WHERE CarrierName LIKE @CarrierNameLike;

SELECT CarrierName, Address, Address2, City, State, Zip, Phone, ElectID
FROM carrier WHERE CarrierName LIKE @CarrierNameLike;
