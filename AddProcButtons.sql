/* Ardavan Hashemzadeh
   February 16 2018
   Add procedure buttons and parent category to OpenDental
*/

SET @category="SDF/SMART/Hall";

SET @but1="Silver Diamine - not billed";
SET @but2="Silver Diamine - Billed";
SET @but3="Silver Diamine - Arrested";

SET @but1proc1="D1354D";
SET @but2proc1="D1354";
SET @but3proc1="D1354A";

INSERT INTO definition(category,itemorder,itemname)
SELECT * FROM (SELECT 26,1+MAX(ItemOrder),@category FROM definition WHERE category=26) a
WHERE (SELECT defnum FROM definition WHERE category=26 AND itemname=@category LIMIT 1) IS NULL;

SET @defnum=(SELECT defnum FROM definition WHERE category=26 AND itemname=@category LIMIT 1);

INSERT INTO procbutton(Description, ItemOrder, Category)
SELECT (@but1,0,@defnum);
INSERT INTO procbutton(Description, ItemOrder, Category)
VALUES(@but2,1,@defnum);
INSERT INTO procbutton(Description, ItemOrder, Category)
VALUES(@but3,2,@defnum);

SET @but1num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but1);
SET @but2num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but2);
SET @but3num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but3);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but1num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but1);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but2num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but2);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but3num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but3);
