:!UTF-8
/* Dekrety biezacego roku dla zakresu kont */

select
/*+MASK_FILTER(POZ,':_b') MASK_FILTER(DOK,':_c')*/
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
DOK.DTW as D_ZAPKS,
DOK.DOP as D_OPERAC,
DOK.NK as SYMBOL
from @POZ
join @DOK using (POZ.DOK,DOK.REFERENCE)
join REJ using (DOK.REJ,REJ.REFERENCE)
join ODD using (REJ.ODD,ODD.REFERENCE)
left join SLO using (POZ.WAL,SLO.REFERENCE)
where
POZ.KON between ':_d' and ':_e' and
(':_a'='wszystkie' or ODD.OD=':_a')
order by
KONTO,JEDN_KSIĘGOWA,REJESTR,D_ZAPKS,NR_W_REJ

