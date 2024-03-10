:!UTF-8
select   P.OSOBA, R.RN, lower(KORN.LT) LT, sum(KOR.POD) POD, sum(KOR.SKL) SKL
from     KOR join KORN join R join P
where    KORN.RU=:_a and KORN.MU=:_b and P.FIRMA=:_c
group by lower(KORN.LT), P.OSOBA, R.RN
order by 3