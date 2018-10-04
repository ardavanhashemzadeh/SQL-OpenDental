/* Ardavan Hashemzadeh */

/* Print Printer Prefrences Per PC */
SELECT CompName, PrintSit, PrinterName, DisplayPrompt  FROM printer NATURAL JOIN computer;

/* Prompt for Printer */
UPDATE printer SET DisplayPrompt=1;





/* Add Missing Prefrences */
INSERT INTO printer
