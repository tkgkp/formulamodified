:!UTF-8
SELECT 0 as LP, M.KTM as "Indeks produktu", M.N as "Nazwa produktu", M2.KTM as "Indeks opakowania", M2.N as "Nazwa opakowania", M_OPAKOW.POJ as "Pojemność opakowania"
FROM M
LEFT JOIN M_OPAKOW USING(M_OPAKOW.M,M.REFERENCE)
LEFT JOIN M as M2 USING(M_OPAKOW.OPAKOW,M2.REFERENCE)
WHERE M.A = 'T' AND
M_OPAKOW.OPAKOW IS NOT NULL
ORDER BY 2,3,4,5
