:!UTF-8
/* Srodki wprowadzone do eksploatacji od ... do ... */

select
0 as LP,
SRSR.NST as NAZWA,
SRSR.NRI as NR_INW,
SRSR.DE as DATA_EKS,
TAM.GR as GRUPA
from SRSR
left join ODD using (SRSR.ODD,ODD.REFERENCE)
join TAM using (SRSR.GR, TAM.REFERENCE)
where
SRSR.DE between to_date(:_b) and to_date(:_c)
and
(ODD.OD = ':_a' or ':_a' ='' or ':_a'='%')
and SRSR.R like ':_d%'
order by
NR_INW

