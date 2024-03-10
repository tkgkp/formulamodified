:!UTF-8
/* Roczne zestawienie wg klas, grup i stawek VAT */

select
0 as LP,
KVAT.SYM as KLASA_VAT,
SLO_GR.KOD as GR_PODAT,
SLO_ST.KOD as STAWKA,
sum(SUM2) as NETTO,
sum(VAT) as PODATEK
from PVAT left join SLO as SLO_GR using (PVAT.GRVAT, SLO_GR.REFERENCE)
left join SLO as SLO_ST using (PVAT.STVAT, SLO_ST.REFERENCE)
join DVAT using (PVAT.DVAT, DVAT.REFERENCE)
join RVAT using (DVAT.RVAT, RVAT.REFERENCE)
join KVAT using (RVAT.KVAT, KVAT.REFERENCE)
join SLO as SLO_KR using (DVAT.KRAJ, SLO_KR.REFERENCE)
join SLO as SLO_WAL using (DVAT.WAL, SLO_WAL.REFERENCE)
join ODD using (DVAT.ODD, ODD.REFERENCE)
where SLO_KR.KOD=':_b' and
SLO_WAL.KOD=':_c' and
(':_a'='wszystkie' or ODD.OD=':_a')
group by KVAT.SYM, SLO_GR.KOD, SLO_ST.KOD

