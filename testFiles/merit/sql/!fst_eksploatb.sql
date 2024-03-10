:!UTF-8
/* Srodki wprowadzone do eksploatacji od ... do ... */

select
0 as LP,
SRST.NST as NAZWA,
SRST.NRI as NR_INW,
SRSR.DE as DATA_EKS,
TAM.GR as GRUPA
from SRST
join SRSR
join ODD using (SRST.ODD,ODD.REFERENCE)
join OKRO_F using (SRST.OKRO_F,OKRO_F.REFERENCE)
join TAM using (SRST.GR,TAM.REFERENCE)
where
SRSR.DE between to_date(:_b) and to_date(:_c)
and
(ODD.OD = ':_a' or ':_a' ='' or ':_a'='%')
and 
OKRO_F.KON=to_date(:_e)
and 
SRST.R like ':_d%'
order by
NR_INW
