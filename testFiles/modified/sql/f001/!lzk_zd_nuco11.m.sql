:!UTF-8
SELECT 0 as LP,M.KTM as "KTM",M.N as "Nazwa towaru",KH.KOD as "Kod Kontrahenta",KH.NAZ_P as "Nazwa Kontrahenta",MDOST.D as "Czy domyślny",MDOST.ILDNI as "Dni na realizacje zamówienia"
FROM MDOST
JOIN M using (MDOST.M,M.reference)
JOIN KH using (MDOST.KH,KH.reference)
WHERE M.KTM LIKE '07%'
ORDER BY "KTM"