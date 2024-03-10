:!UTF-8
/* Srodki bez dokumentu OT od ... do ... */

select 
0 as LP,
SRST.NRI as "Numer inwentarzowy", 
SRST.NST as Nazwa, 
SRST.DE as "Data eksploatacji", 
ODD.OD as "Jednostka Księgowa" 
from SRST
join SRSR using (SRST.SRSR, SRSR.REFERENCE) 
join ODD using (SRST.ODD, ODD.REFERENCE)
where 
(ODD.OD = ':_a' or ':_a' ='' or ':_a'='%')
and SRSR.Z = 'N'
and SRSR.DOKPRZ IS NULL
and SRST.DE between to_date(:_b) and to_date(:_c)
and (SRST.GRP='N' or SRST.KIND='N') 
and SRST.R like ':_d%'
group by ODD.OD, SRST.NRI, SRST.NST, SRST.DE
order by "Numer inwentarzowy"


