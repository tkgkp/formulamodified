:!UTF-8
/* Amortyzacja roczna podatkowa środków */

select 
    0 as LP,
    SRST.NRI as NUMER_INW,
    substr(SRST.NST,1,40) as NAZWA,
    TAM.GR as GRUPA, 
    ODD.OD as JEDN_KS, 
    MA.K as METODA, 
    SRST.ROK as ROK,
    sum(SRST.AMOP) as AMORT_POD
from SRST 
    join ODD using (SRST.ODD, ODD.REFERENCE) 
    left join MA using (SRST.MP, MA.REFERENCE)
    left join TAM using (SRST.GR, TAM.REFERENCE)
where 
    (':_a'='wszystkie' or ODD.OD=':_a')
    and MA.K like ':_b%'
    and SRST.R like ':_c%'
group by 
    ODD.OD, SRST.NRI, SRST.ROK, SRST.NST, ODD.OD, MA.K, TAM.GR
order by 
    JEDN_KS, NUMER_INW, ROK

