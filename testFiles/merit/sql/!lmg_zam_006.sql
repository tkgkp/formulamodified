:!UTF-8
select
 0 as LP,
 ZK_N.SYM as "Symbol zamówienia",
 ZK_P.DT as "Planowany termin realizacji",
 M.KTM as "Indeks materiałowy",
 M.N as "Nazwa materiału",
 ZK_P.ILZ as "Ilość zamówiona",
 ZK_P.ILZ-ZK_P.ILP as "Ilość zrealizowana",
 ZK_P.ILP as "Ilość pozostała",
 JM.KOD as "Jednostka miary",
 SLO.KOD as Waluta,
 ZK_P.CENA as Cena,
 ZK_P.NETTO as Wartość,
 ZK_N.STAT_REJ as StatRej

from
 @ZK_P
 join @ZK_N using (ZK_P.N,ZK_N.reference)
 left join M using (ZK_P.M,M.REFERENCE)
 left join JM using (ZK_P.JM,JM.reference)
 left join SLO using (ZK_P.WAL,SLO.reference)

where ZK_P.RODZ='W' and ZK_P.N is not NULL
 and (M.R like UPPER(':_a'))
 and (ZK_P.TRN='T' or ZK_N.TRN='T')

order by "Symbol zamówienia"

