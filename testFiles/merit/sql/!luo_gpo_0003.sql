:!UTF-8
select 0 as LP,
       GPOD.KOD as Punkt,
       case GPODPOZ.F when 'N' then 'Indywidualny' else 'Firma' end as RodzajKontrahenta,
       ODP.KOD as Kod,
       ODP.NAZ as Nazwa,
       GPODKAT.KAT as Kategoria,
       sum(WAGA) as Waga
from @GPODPOZ left join ODP left join GPODKAT join GPOD using(GPODPOZ.GPOD,GPOD.reference)
where :_c and GPODPOZ.D>=to_date(:_a) and GPODPOZ.D<=to_date(:_b) and WAGA>0
group by ODP.KOD,ODP.NAZ,GPODPOZ.F,GPODKAT.KAT,GPOD.KOD


