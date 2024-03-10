:!UTF-8
select distinct
       0 as LP,
       GPOD.KOD as Punkt,
       GPODPOZ.PESEL as Pesel_KodKontrahenta
       from GPODPOZ
            join GPOD using(GPODPOZ.GPOD,GPOD.reference)
       where :_c and GPODPOZ.D>=to_date(:_a) and GPODPOZ.D<=to_date(:_b) and  WAGA>0
       group by GPOD.KOD,GPODPOZ.PESEL
       order by 2,3


