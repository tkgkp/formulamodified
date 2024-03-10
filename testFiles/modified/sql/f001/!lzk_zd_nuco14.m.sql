:!UTF-8
SELECT
0 as LP,
M.KTM as "KTM surowca głównego",
M.N as "Nazwa surowca głównego",
KHDOST.KOD as "Dostawca surowca głównego",
KHDOST.NAZ as "Nazwa dostawcy surowca głównego",
MKODK.KTM as "KTM zamiennika",
MKODK.N as "Nazwa zamiennika",
KH.KOD as "Dostawca zamiennika", 
KH.NAZ as "Nazwa dostawcy zamiennika"
FROM MKODK
JOIN M USING(MKODK.M,M.REFERENCE)
JOIN KH USING(MKODK.KH,KH.REFERENCE)
LEFT JOIN MDOST USING(MKODK.M,MDOST.M)
LEFT JOIN KH AS KHDOST USING(MDOST.KH,KHDOST.REFERENCE)
WHERE M.KTM LIKE '07%'
AND MDOST.D = 'T'
AND MKODK.KTM like '%-%-%'
ORDER BY 2,3,4,5,6,7,8,9