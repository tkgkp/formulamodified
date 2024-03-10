:!UTF-8
select
 0 as LP,
 KH.KOD as "Kod kontrahenta",
 KH.SKR as "Skrót kontrahenta",
 ZD_NAG.SYM as "Symbol zamówienia",
 ZD_NAG.DATA as "Data przyjęcia zamówienia",
 ZD_NAG.DTPREAL as "Planowany termin realizacji",
 M.KTM as "Indeks materiałowy",
 M.N as "Nazwa materiału",
 ZD_POZ.IL_ZAM+ZD_POZ.IL_KOR as "Ilość zamówiona",
 ZD_POZ.IL_ZRE as "Ilość zrealizowana",
 ZD_POZ.IL_POZ as "Ilość pozostała",
 JM.KOD as "Jednostka miary",
 SLO.KOD as Waluta,
 ZD_POZ.CENA as Cena,
 ZD_POZ.WAR as Wartość,
 ZD_NAG.STAT_REJ as StatRej

from
 @ZD_POZ
 join ZD_NAG using (ZD_POZ.ZD_NAG,ZD_NAG.reference)
 left join KH using (ZD_NAG.KH,KH.reference)
 left join M using (ZD_POZ.M,M.reference)
 left join JM using (ZD_POZ.JM,JM.reference)
 left join SLO using (ZD_POZ.WAL,SLO.reference)

where
 ((ZD_NAG.DATA between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null))
 and ZD_NAG.TRN='T'

order by
 "Kod kontrahenta","Symbol zamówienia","Data przyjęcia zamówienia","Planowany termin realizacji"

