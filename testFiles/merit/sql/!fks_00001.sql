:!UTF-8
/* Dokumenty zrodlowe biezacego roku wg rejestru i zakresu dat zapisu */

select
/*+MASK_FILTER(DOK,':_b')*/
0 as LP,
ODD.OD as JEDN_KSIĘGOWA,
REJ.KOD as REJESTR,
DOK.NR as NR_W_REJ,
DOK.DTW as D_ZAPKS,
DOK.DOP as D_OPERAC,
DOK.NK as SYMBOL,
DOK_REJ.NAZ as RODZ_DOK,
DOK.DTO as D_WYSTAW,
DOK.DAKC as D_AKCEPT,
DOK.DKS as D_KSIEG,
DOK.TR as OPIS_DOK,
SLO.TR as POCHODZ,
DOK.A as AKCEPT,
DOK.ZP as KSIEG_P,
DOK.ZK as KSIEG_K
from @DOK
join REJ using (DOK.REJ,REJ.REFERENCE)
join DOK_REJ using (DOK.DOK_REJ,DOK_REJ.REFERENCE)
join ODD using (DOK.ODD,ODD.REFERENCE)
left join SLO using (DOK.WYS,SLO.REFERENCE)
where
REJ.KOD=':_c' and
DOK.DTW between to_date(:_d) and to_date(:_e) and
(':_a'='wszystkie' or ODD.OD=':_a')
order by
JEDN_KSIĘGOWA,REJESTR,D_ZAPKS,NR_W_REJ

