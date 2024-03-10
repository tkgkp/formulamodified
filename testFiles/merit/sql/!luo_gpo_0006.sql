:!UTF-8
select 0 as LP,
       GPOD.KOD as Punkt,
       GPODPOZ.D as Data,
       case GPODPOZ.F when 'N' then 'Indywidualny' else 'Firma' end as RodzajKontrahenta,
       ODP.KOD as KodOdpadu,
       ODP.NAZ as NazwaOdpadu,
       GPODKAT.KAT as KategoriaOdpadu,
       GPODGIOS.OP as KategoriaGIOS,
       GPODPOZ.WAGA as WagaNetto,
       KH.NAZ as Kontrahent,
       GPODPOZ.IM as Imię,
       GPODPOZ.NAZ as Nazwisko,
       MIA.NAZ as Miasto,
       UL.UL || ' ' || GPODPOZ.NRD || ' ' || GPODPOZ.LOKAL as Adres,
       GPODPOZ.NRREJ as NumerRejestracyjny,
       GPODPOZ.WB as WagaBrutto,
       GPODPOZ.WT as WagaTara,
       GPODPOZ.SYM as Numer,
       GPODPOZ.AR as Rok,
       GPODPOZ.AM as Miesiąc
from GPODPOZ
     left join ODP using (GPODPOZ.ODP, ODP.reference)
     left join GPODKAT using (GPODPOZ.KAT,GPODKAT.reference)
     left join GPODGIOS using(GPODGIOS.reference,GPODPOZ.GPODGIOS)
     left join KH using (GPODPOZ.KH, KH.reference)
     left join UL using(GPODPOZ.UL,UL.reference)
     left join MIA using(GPODPOZ.MIA,MIA.reference)
     join GPOD using (GPODPOZ.GPOD, GPOD.reference)     
where :_c and GPODPOZ.D>=to_date(:_a) and GPODPOZ.D<=to_date(:_b) and GPODPOZ.WAGA>0
order by 2,3,5
