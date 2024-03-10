:!UTF-8
select
   0 as LP,
   ktm MatIndeks,
   jedn Jm,
   mg MagSymbol,
   max(ost_oper) OstOper,
   sum(ilosc) Ilosc,
   case
      when sum(ilosc)<>0 then sum(wartosc)/sum(ilosc)
      else 0
   end WarMagJedn,
   sum(wartosc) WarMag
from :_c
group by KTM, JEDN, MG
having sum(ilosc)<>0 or sum(wartosc)<>0
order by 2,3