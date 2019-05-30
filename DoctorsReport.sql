
-- Ardavan Hashemzadeh
-- May 29th 2019
-- Doctor Driven, Preventative, and Total Production and Collection

SELECT abbr AS Provider,
pl.procdate AS 'DateOfService',
DAYNAME(pl.procdate) AS 'Weekday',
Location,
ROUND(SUM(procfee),2) AS 'TotalProduction',
ROUND(SUM(IFNULL(inspayamt,0)+IFNULL(splitamt,0)),2) AS 'TotalCollection',
ROUND(SUM(CASE WHEN Prevention.codenum IS NOT NULL THEN procfee END),2) AS 'PreventionProduction',
ROUND(SUM(CASE WHEN Prevention.codenum IS NOT NULL THEN IFNULL(inspayamt,0)+IFNULL(splitamt,0) ELSE 0 END),2) AS 'PreventionCollection',
ROUND(SUM(CASE WHEN DoctorDrivenTx.codenum IS NOT NULL THEN procfee END),2) AS 'DoctorDrivenProduction',
ROUND(SUM(CASE WHEN DoctorDrivenTx.codenum IS NOT NULL THEN IFNULL(inspayamt,0)+IFNULL(splitamt,0) ELSE 0 END),2) AS 'DoctorDrivenCollection'

FROM procedurelog pl JOIN provider p USING (provnum)
LEFT JOIN claimproc cp USING (procnum)
LEFT JOIN paysplit ps USING (procnum)
LEFT JOIN (SELECT codenum FROM procedurecode WHERE proccode IN ('D0601','D0602','D0603','D0210','D0220','D0230','D0240','D0250','D0260','D0270','D0272','D0274','D0277','D0290','D0310','D0320','D0321','D0322','D0330','D0340','D0350','D0415','D0425','D0470','D1110','D1120','D1201','D1203','D1204','D1206','D1208','D1205','D1310','D1320','D1330','D1351','D1510','D1515','D1520','D1525','D1550','D4341','D4342','D4343','D4381','D4910','D4920','D5936','D5937','D5986','D6985','D7997','D8210','D8692','D9430','D9440','D9450','D9630','D9910','D9911','D9940','D9941','D9950','D9972','D9973','D9993','D9994')) Prevention USING (codenum)
LEFT JOIN (SELECT codenum FROM procedurecode WHERE proccode IN ('D0120','D0140','D0145','D0150','D0160','D0170','D0180','D0460','D0472','D0473','D0474','D0480','D0502','D0999','D1352','D1354','D2140','D2150','D2160','D2161','D2330','D2331','D2332','D2335','D2390','D2391','D2392','D2393','D2394','D2410','D2420','D2430','D2510','D2520','D2530','D2542','D2543','D2544','D2610','D2620','D2630','D2642','D2643','D2644','D2650','D2651','D2652','D2662','D2663','D2664','D2710','D2720','D2721','D2722','D2740','D2750','D2751','D2752','D2780','D2781','D2782','D2783','D2790','D2791','D2792','D2799','D2910','D2920','D2929','D2930','D2931','D2932','D2933','2335','D2950','D2951','D2952','D2953','D2954','D2955','D2957','D2960','D2961','D2962','D2970','D2980','D2999','D3110','D3120','D3220','D3221','D3230','D3240','D3310','D3320','D3330','D3331','D3332','D3333','D3346','D3347','D3348','D3351','D3352','D3353','D3410','D3421','D3425','D3426','D3430','D3450','D3460','D3470','D3910','D3920','D3950','D3999','D4210','D4211','D4240','D4241','D4245','D4249','D4260','D4261','D4263','D4264','D4265','D4266','D4267','D4268','D4270','D4271','D4273','D4274','D4275','D4276','D4320','D4321','D4999','D5110','D5120','D5130','D5140','D5211','D5212','D5213','D5214','D5281','D5410','D5411','D5421','D5422','D5510','D5520','D5610','D5620','D5630','D5640','D5650','D5660','D5670','D5671','D5710','D5711','D5720','D5721','D5730','D5731','D5740','D5741','D5750','D5751','D5760','D5761','D5810','D5811','D5820','D5821','D5850','D5851','D5860','D5861','D5862','D5867','D5875','D5899','D5913','D5914','D5915','D5916','D5919','D5922','D5923','D5924','D5925','D5926','D5927','D5928','D5929','D5931','D5932','D5933','D5934','D5935','D5951','D5952','D5953','D5954','D5955','D5958','D5959','D5960','D5982','D5983','D5984','D5985','D5987','D5988','D5999','D6010','D6020','D6040','D6050','D6053','D6054','D6055','D6056','D6057','D6058','D6059','D6060','D6061','D6062','D6063','D6064','D6065','D6066','D6067','D6068','D6069','D6070','D6071','D6072','D6073','D6074','D6075','D6076','D6077','D6078','D6079','D6080','D6090','D6095','D6100','D6199','D6210','D6211','D6212','D6240','D6241','D6242','D6245','D6250','D6251','D6252','D6253','D6545','D6548','D6600','D6601','D6602','D6603','D6604','D6605','D6606','D6607','D6608','D6609','D6610','D6611','D6612','D6613','D6614','D6615','D6720','D6721','D6722','D6740','D6750','D6751','D6752','D6780','D6781','D6782','D6783','D6790','D6791','D6792','D6793','D6920','D6930','D6950','D6970','D6971','D6972','D6973','D6976','D6977','D6980','D6999','D7111','D7140','D7210','D7220','D7230','D7240','D7241','D7250','D7260','D7261','D7270','D7272','D7280','D7281','D7282','D7285','D7286','D7287','D7290','D7291','D7310','D7320','D7340','D7350','D7410','D7411','D7412','D7413','D7414','D7415','D7440','D7441','D7450','D7451','D7460','D7461','D7465','D7471','D7472','D7473','D7485','D7490','D7510','D7520','D7530','D7540','D7550','D7560','D7610','D7620','D7630','D7640','D7650','D7660','D7670','D7671','D7680','D7710','D7720','D7730','D7740','D7750','D7760','D7770','D7771','D7780','D7810','D7820','D7830','D7840','D7850','D7852','D7856','D7858','D7860','D7865','D7870','D7871','D7873','D7874','D7875','D7876','D7877','D7880','D7899','D7910','D7911','D7912','D7920','D7940','D7941','D7943','D7944','D7945','D7946','D7947','D7948','D7949','D7950','D7955','D7960','D7970','D7971','D7972','D7980','D7981','D7982','D7983','D7990','D7991','D7995','D7996','D7999','D8010','D8020','D8030','D8040','D8050','D8060','D8070','D8080','D8090','D8220','D8680','D8690','D8691','D8999','D9110','D9210','D9211','D9212','D9215','D9220','D9221','D9230','D9241','D9242','D9248','D9310','D9420','D9610','D9920','D9930','D9951','D9952','D9970','D9971','D9974','D9999')) DoctorDrivenTx USING (codenum),
(SELECT valuestring AS Location FROM preference WHERE prefname='PracticeTitle') Practice

WHERE procstatus=2
GROUP BY pl.procdate
ORDER BY pl.procdate
