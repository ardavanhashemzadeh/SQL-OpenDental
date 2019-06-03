-- Ardavan Hashemzadeh
-- June 3rd 2019
-- Add some codes to a quickbutton category

SET @category="Caries Risk";

SET @feesched="HealthFirst";

SET @but1="Low Caries Risk";
SET @but2="Moderate Caries Risk";
SET @but3="High Caries Risk";

SET @but1proc1="D0601";
SET @but2proc1="D0602";
SET @but3proc1="D0603";

SET @img1="iVBORw0KGgoAAAANSUhEUgAAABQAAAAUAQMAAAC3R49OAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAZQTFRFAAAA////pdmf3QAAAEZJREFUGNNj+M//geHHxw8M3/99YHj/v4Dh/v8NDHs+X2DYnXsBTNf/fwDB6yH0/v9Aub8XGPb+vsBwj30DWA9IL8gMoFkAkDwwFA0cWcAAAAAASUVORK5CYII=";
SET @img2="iVBORw0KGgoAAAANSUhEUgAAABQAAAAUAQMAAAC3R49OAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAZQTFRFAAAA////pdmf3QAAAAlwSFlzAAAOwgAADsIBFShKgAAAAEFJREFUGNNj+M//geHHxw8M3/99YHj/v4Dh/v8NDHs+X2DYnXsBTNf/fwDB6yH0/v8XwHgP8wWwWpAekF6QGUCzAIz4MBpOEmb4AAAAAElFTkSuQmCC";
SET @img3="iVBORw0KGgoAAAANSUhEUgAAABQAAAAUAQMAAAC3R49OAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAZQTFRFAAAA////pdmf3QAAAAlwSFlzAAAOwgAADsIBFShKgAAAAEhJREFUGNNj+M//geHHxw8M3/99YHj/v4Dh/v8NDHs+X2DYnXsBTNf/fwDB6yH0/v8XGPaxX2DY+/sCw+2/G8B6QHpBZgDNAgCIpDAUzlrhIwAAAABJRU5ErkJggg==";

/* Delete existing procedure buttons and category */
DELETE pbi, pb, d FROM procbuttonitem pbi
JOIN procbutton pb ON pbi.procbuttonnum=pb.procbuttonnum
JOIN definition d ON pb.category=d.defnum
WHERE d.itemname LIKE @category;

INSERT INTO definition(category,itemorder,itemname)
SELECT * FROM (SELECT 26,1+MAX(ItemOrder),@category FROM definition WHERE category=26) a
WHERE (SELECT defnum FROM definition WHERE category=26 AND itemname LIKE CONCAT("%",@category,"%")) IS NULL;

UPDATE definition SET itemname=@category WHERE category=26 AND itemname LIKE CONCAT("%",@category,"%");

SET @defnum=(SELECT defnum FROM definition WHERE category=26 AND itemname=@category LIMIT 1);

INSERT INTO procbutton(Description, ItemOrder, Category, ButtonImage)
VALUES(@but1,0,@defnum,@img1);
INSERT INTO procbutton(Description, ItemOrder, Category, ButtonImage)
VALUES(@but2,1,@defnum,@img2);
INSERT INTO procbutton(Description, ItemOrder, Category, ButtonImage)
VALUES(@but3,2,@defnum,@img3);

SET @but1num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but1 LIMIT 1);
SET @but2num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but2 LIMIT 1);
SET @but3num=(SELECT ProcButtonNum FROM procbutton WHERE description=@but3 LIMIT 1);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but1num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but1proc1 LIMIT 1);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but2num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but2proc1 LIMIT 1);

INSERT INTO procbuttonitem(ProcButtonNum, CodeNum)
SELECT @but3num, (SELECT CodeNum FROM procedurecode WHERE ProcCode=@but3proc1 LIMIT 1);

SELECT d.ItemName AS Category, pb.Description, pc.proccode FROM procbuttonitem pbi
JOIN procbutton pb ON pbi.procbuttonnum=pb.procbuttonnum
JOIN definition d ON pb.category=d.defnum
JOIN procedurecode pc ON pc.codenum=pbi.codenum
WHERE d.itemname LIKE @category
ORDER BY d.ItemName, pb.Description, pc.ProcCode;
