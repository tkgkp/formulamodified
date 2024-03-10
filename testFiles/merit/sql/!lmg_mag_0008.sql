:!UTF-8
select
      0 as LP,
      grupa MatGrupaKod,
      ktm MatIndeks,
      jedn Jm,
      sum(ilosc) Ilosc,
      case
         when sum(ilosc)<>0 then sum(wartosc)/sum(ilosc)
         else 0
      end WarMagJedn,
      sum(wartosc) WarMag,
      jedn2 Jm2,
      case
        when jedn2<>'' then sum(ilosc2)
        else 0
      end Ilosc2

from  :_b

group by GRUPA, KTM, JEDN, JEDN2

having sum(ilosc)<>0 or sum(wartosc)<>0

order by 2, 3

