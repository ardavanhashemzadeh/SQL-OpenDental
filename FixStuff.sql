-- Recon

SELECT ProcCode, AbbrDesc, TreatArea, PaintType, GraphicColor FROM procedurecode
WHERE AbbrDesc LIKE '%missing%' OR AbbrDesc LIKE '%fuji%';
