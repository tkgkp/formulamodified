:!UTF-8
/* Dekrety biezacego okresu dla zakresu kont */

select
0 as LP,
POZ.KON as KONTO,
WN,
MA,
SLO.KOD as WALUTA,
POZ.SUMW as KWOTA_W,
POZ.KURS as KURS,
ODD.OD as JEDN_KSIĘGOWA,
REJ.KOD as REJESTR,
DOK.NR as NR_W_REJ,
DOK.NK as SYMBOL
from POZ
join DOK using (POZ.DOK,DOK.REFERENCE)
join REJ using (DOK.REJ,REJ.REFERENCE)
join ODD using (REJ.ODD,ODD.REFERENCE)
left join SLO using (POZ.WAL,SLO.REFERENCE)
where
POZ.KON between ':_b' and ':_c' and
(':_a'='wszystkie' or ODD.OD=':_a')
order by
KONTO

