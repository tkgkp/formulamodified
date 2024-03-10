:!UTF-8
/* Zestawienie korekt nagłówkowych w bieżącym okresie */

select
/*+MASK_FILTER(DOK,':_b')*/
0 as LP,
'Kor. nagłówkowa' as TR,
ODD.OD as JEDN_KSIĘGOWA,
REJ.KOD as REJESTR,
DOK.NR as NR_W_REJ,
DOK.NK as SYMBOL,
DOK.DTW as D_ZAPKS,
DOK.DOP as D_OPERAC,
DOK.DTO as D_WYSTAW,
DOK.KH_FULL as KONTRAHENT,
SUBSTR(to_string(OKRO_F.POCZ),1,7) as OKRES_VAT,
DOK.REFERENCE as REF
from DOK
join REJ using (DOK.REJ,REJ.REFERENCE)
join DOK_REJ using (DOK.DOK_REJ,DOK_REJ.REFERENCE)
join ODD using (DOK.ODD,ODD.REFERENCE)
left join SLO using (DOK.WYS,SLO.REFERENCE)
left join OKRO_F using (DOK.OKRVAT,OKRO_F.REFERENCE)
where
DOK_REJ.KOR_NAG='T' and
DOK.DOP between to_date(:_c) and to_date(:_d) and
(':_a'='wszystkie' or ODD.OD=':_a')
union all

select
/*+MASK_FILTER(DOK,':_b')*/
0 as LP,
' - Dok. źródłowy' as TR,
ODD.OD as JEDN_KSIĘGOWA,
REJ.KOD as REJESTR,
DOK.NR as NR_W_REJ,
DOK.NK as SYMBOL,
DOK.DTW as D_ZAPKS,
DOK.DOP as D_OPERAC,
DOK.DTO as D_WYSTAW,
DOK.KH_FULL as KONTRAHENT,
SUBSTR(to_string(OKRO_F.POCZ),1,7) as OKRES_VAT,
DOK.KN as REF
from DOK
join REJ using (DOK.REJ,REJ.REFERENCE)
join DOK_REJ using (DOK.DOK_REJ,DOK_REJ.REFERENCE)
join ODD using (DOK.ODD,ODD.REFERENCE)
left join SLO using (DOK.WYS,SLO.REFERENCE)
left join OKRO_F using (DOK.OKRVAT,OKRO_F.REFERENCE)
where
DOK_REJ.KOR_NAG<>'T' AND DOK.KN<>'' and
(':_a'='wszystkie' or ODD.OD=':_a')

union all

select
0 as LP,
' - Dok. źródłowy' as TR,
ODD.OD as JEDN_KSIĘGOWA,
' ' as REJESTR,
0 as NR_W_REJ,
DOKN.NK1 as SYMBOL,
DOKN.DTW1 as D_ZAPKS,
DOKN.DOP1 as D_OPERAC,
DOKN.DTO1 as D_WYSTAW,
DOKN.KH_FULL1 as KONTRAHENT,
SUBSTR(to_string(OKRO_F.POCZ),1,7) as OKRES_VAT,
DOKN.KN as REF
from DOKN
left join SLO using (DOKN.WYS1,SLO.REFERENCE)
left join OKRO_F using (DOKN.OKRVAT1,OKRO_F.REFERENCE)
join ODD using (DOKN.ODD,ODD.REFERENCE)
where
(':_a'='wszystkie' or ODD.OD=':_a')
order by
REF,TR DESC
