:!UTF-8
/* Rejestry sprzedaży VAT */

select
0 as LP,
DVAT.NIP as NIP,
DVAT.KH as KONTRAH,
RVAT.SYM as REJ_VAT,
DVAT.NR as NUMER,
DVAT.SYM1 as SYMBOL,
DVAT.DAT1 as D_ZAPKS,
DVAT.DAT5 as D_OPERAC,
ODD.OD as JEDN_KSIĘGOWA,
REJ.KOD as REJESTR,
DOK.NR as NR_W_REJ
from DVAT
join RVAT using (DVAT.RVAT,RVAT.REFERENCE)
join KVAT using (RVAT.KVAT,KVAT.REFERENCE)
join DOK using (DVAT.DOK,DOK.REFERENCE)
join REJ using (DOK.REJ,REJ.REFERENCE)
join ODD using (REJ.ODD,ODD.REFERENCE)
where
lower(KVAT.SYM) like 'sprz%' and
DVAT.NIP like ':_b' and
(':_a'='wszystkie' or ODD.OD=':_a')
order by
REJ_VAT,NUMER

