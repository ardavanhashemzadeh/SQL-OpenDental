-- Ardavan Hashemzadeh
-- June 3rd 2019
-- Add some codes to a quickbutton category

SET @category="Exams/Cleanings/Xrays";

SET @but1="Fuji Sealant";
SET @but2="Fuji Filling";
SET @but3="Missing Sealant";
SET @but4="Missing Filling";

SET @but1proc1="D1351F";
SET @but2proc1="D2940F";
SET @but3proc1="N1351";
SET @but4proc1="N2940";

SET @defnum=(SELECT defnum FROM definition WHERE category=26 AND itemname LIKE CONCAT(%,@category,%) LIMIT 1);

INSERT INTO procbutton(Description, ItemOrder, Category)
VALUES(@but1,0,@defnum);
INSERT INTO procbutton(Description, ItemOrder, Category)
VALUES(@but2,0,@defnum);
INSERT INTO procbutton(Description, ItemOrder, Category)
VALUES(@but3,0,@defnum);
INSERT INTO procbutton(Description, ItemOrder, Category)
VALUES(@but4,0,@defnum);

SET @but1num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but1 LIMIT 1);
SET @but2num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but2 LIMIT 1);
SET @but3num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but3 LIMIT 1);
SET @but4num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but4 LIMIT 1);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but1num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but1proc1 LIMIT 1);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but2num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but2proc1 LIMIT 1);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but3num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but3proc1 LIMIT 1);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but4num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but4proc1 LIMIT 1);
