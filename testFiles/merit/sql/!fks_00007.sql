:!UTF-8
/* Rozrachunki dla maski kont */

select
0 as LP,
OP.AN as KONTO,
OP.SYM as SYMBOL,
OP.WN as OBR_WN,
OP.MA as OBR_MA,
SLO.KOD as WALUTA,
OP.TZ as D_PŁATN,
KH.NAZ as KONTRAH,
OP.TYP as TYP,
ODD.OD as JEDN_KSIĘGOWA
from OP
left join KH using (OP.KH,KH.REFERENCE)
join ODD using (OP.ODD,ODD.REFERENCE)
join SLO using (OP.WAL,SLO.REFERENCE)
where
OP.AN like ':_b' and
(':_a'='wszystkie' or ODD.OD=':_a')
:_c
order by
KONTO

