/* Ardavan Hashemzadeh */

/* Print Printer Prefrences Per PC */
SELECT CompName, PrintSit, PrinterName, DisplayPrompt  FROM printer NATURAL JOIN computer;

/* Prompt for Printer */
UPDATE printer SET DisplayPrompt=1;

/* Add Missing Prefrences */
INSERT INTO printer(ComputerNum, PrintSit, PrinterName, DisplayPrompt)
SELECT c.ComputerNum, 0 AS PrintSit, '' AS PrinterName, 1 AS DisplayPrompt
FROM computer c LEFT JOIN printer p ON c.ComputerNum=p.ComputerNum
WHERE p.ComputerNum IS NULL
AND LastHeartBeat >= DATE_SUB(NOW(), INTERVAL 1 MONTH);
