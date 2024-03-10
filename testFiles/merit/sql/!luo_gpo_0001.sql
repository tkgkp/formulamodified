:!UTF-8
select 0 as LP,
       GPOD.KOD as Punkt,
       case GPODPOZ.F when 'N' then 'Indywidualny' else 'Firma' end as RodzajKontrahenta,
       ODP.KOD as Kod,
       ODP.NAZ as Nazwa,
       sum(WAGA) as Waga
from GPODPOZ
     left join ODP using (GPODPOZ.ODP, ODP.reference)
     join GPOD using (GPODPOZ.GPOD, GPOD.reference)
where :_c and GPODPOZ.D>=to_date(:_a) and GPODPOZ.D<=to_date(:_b) and WAGA>0
group by ODP.KOD,ODP.NAZ,GPODPOZ.F,GPOD.KOD
