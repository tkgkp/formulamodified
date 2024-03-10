:!UTF-8
select
0 as LP,
PROD_REJ.OK as "Wykonana",
to_string(PROD_REJ.STARTD)||' - '||to_string(PROD_REJ.STARTT) as "Planowanie rozpoczęcie",
UD_SKL.SYMBOL as "Wydział",
M.KTM||' '||M.N as "Produkt",
PROD_REJ.RES_SYM as "Zasób",
PROD_REJ.ILC as "Do wykonania",
PROD_REJ.ILW as "Wykonano",
JM.KOD as "jm",
ZL.SYM as "Zlecenie"
from
PROD_REJ
left join UD_SKL using (PROD_REJ.WYD,UD_SKL.reference)
left join ZL using (PROD_REJ.ZL,ZL.reference)
left join M using (PROD_REJ.M,M.reference)
left join JM using (M.J,JM.reference)
where
PROD_REJ.QZMIANA=to_string(:_a)
and PROD_REJ.STARTD=to_date(:_b)
order by 4,6,3
