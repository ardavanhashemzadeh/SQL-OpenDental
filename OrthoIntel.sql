-- Patients with Ortho Start Codes
SELECT DISTINCT patnum FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")

-- Count of patients with Ortho Start codes
SELECT COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode IN ("INVSR", "INVSX", "D8060", "D8080", "D8090")

-- Patients with completed Ortho tx (based on code D8680)
SELECT DISTINCT patnum FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode="D8680"

-- Count of patients with completed Ortho tx (based on code D8680)
SELECT COUNT(DISTINCT patnum) FROM procedurelog JOIN procedurecode USING(codenum) WHERE procstatus=2 AND proccode=”D8680”
