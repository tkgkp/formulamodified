:!UTF-8
select 0 as LP,
       GPOD.KOD as Punkt,
       GPODPOZ.IM as Imię,
       GPODPOZ.NAZ as Nazwisko,
       MIA.NAZ as Miasto,
       UL.UL || ' ' || GPODPOZ.NRD as Adres,
       ODP.KOD as Kod,
       ODP.NAZ as Nazwa,
       sum(WAGA) as Waga
from GPODPOZ left join ODP left join GPODKAT join GPOD using(GPODPOZ.GPOD,GPOD.reference)
     left join UL using(GPODPOZ.UL,UL.reference)
     left join MIA using(GPODPOZ.MIA,MIA.reference)
where :_c and GPODPOZ.D>=to_date(:_a) and GPODPOZ.D<=to_date(:_b) and WAGA>0 and ('_%d'='' or ':_d'='%' or GPODPOZ.PESEL=':_d')
group by ODP.KOD,ODP.NAZ,GPODPOZ.F,GPODPOZ.IM,GPODPOZ.NAZ,GPOD.KOD,UL.UL,MIA.NAZ,GPODPOZ.NRD
order by 2,5

