:!UTF-8
/* Roczne zestawienie wg kontrahentów, grup, stawek */

select
0 as LP,
KH as KONTRAH,
SLO_GR.KOD as GR_PODAT,
SLO_ST.KOD as STAWKA,
sum(SUM2) as NETTO,
sum(VAT) as PODATEK
from PVAT
left join SLO as SLO_GR using (PVAT.GRVAT, SLO_GR.REFERENCE)
left join SLO as SLO_ST using (PVAT.STVAT, SLO_ST.REFERENCE)
join DVAT using (PVAT.DVAT, DVAT.REFERENCE)
join ODD using (DVAT.ODD, ODD.REFERENCE)
join SLO as SLO_KR using (DVAT.KRAJ, SLO_KR.REFERENCE)
join SLO as SLO_WAL using (DVAT.WAL, SLO_WAL.REFERENCE)
where SLO_KR.KOD=':_b' and SLO_WAL.KOD=':_c' and SLO_GR.KOD like ':_d%' and KH like ':_e%' and
(':_a'='wszystkie' or ODD.OD=':_a')
group by KH, SLO_GR.KOD, SLO_ST.KOD

