:!UTF-8
/* Ksiegowania dla maski kont */

select
0 as LP,
/*ODD.OD as JEDN_KSIĘGOWA,*/
REJ.KOD as REJESTR,
DOK.NR as NR_W_REJ,
POZ.POZ as POZ,
DOK.KH_FULL as KONTRAHENT,
DOK.NIP,
DOK.DTW as D_ZAPKS,
DOK.DOP as D_OPERAC,
POZ.KON as KONTO,
case POZ.STR when 'Wn' then POZ.SUM end as WN,
case POZ.STR when 'Ma' then POZ.SUM end as MA,
SLO.KOD as WALUTA,
POZ.SUMW as KWOTA_W,
POZ.KURS as KURS,
DOK.NK as SYMBOL,
DOK.TR as OPIS,
DOK.NRDZ as NR_W_DZ
from POZ
join DOK using (POZ.DOK,DOK.REFERENCE)
join REJ using (DOK.REJ,REJ.REFERENCE)
join ODD using (REJ.ODD,ODD.REFERENCE)
left join SLO using (POZ.WAL,SLO.REFERENCE)
where
DOK.ZP='T' and POZ.KON like ':_b' and
(':_a'='wszystkie' or ODD.OD=':_a')
:_c
order by
KONTO

