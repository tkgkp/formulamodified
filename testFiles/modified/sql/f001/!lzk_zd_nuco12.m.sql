:!UTF-8
SELECT 0 as LP,M.KTM as "KTM",M.N as "Nazwa towaru",KH.KOD as "Kod Kontrahenta",KH.NAZ_P as "Nazwa Kontrahenta",MDOST.D as "Czy domyślny",MDOST.ILDNI as "Dni na realizacje zamówienia", CN.KOD as "Kod taryfy CN", CN.OPIS as "Opisy kodu CN"
FROM MDOST
JOIN M using (MDOST.M,M.reference)
JOIN KH using (MDOST.KH,KH.reference)
JOIN CNM using (CNM.M,M.reference)
JOIN CN using (CNM.CN,CN.reference)
ORDER BY "KTM"
