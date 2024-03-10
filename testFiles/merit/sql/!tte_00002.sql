:!UTF-8
/* Karty technologiczne,
   Parametry:
    _a = kod grupy (* - wszystkie),
    _b = WPM (W,P,S,* - wszystkie),
    _c = Typ karty (* - wszystkie)
    _d = ktm (* - wszystkie),
    _e = archiwalna (T,N,* - wszystkie)
*/

select
 0 as LP,
 MGR.KOD as Grupa,
 TKTL.NRK as Technologia,
 TKTL.WER as Wersja,
 TKTL.STAN as Stan,
 TKTL.OPIS as Opis,
 TPKTL.TYP as Typ,
 TKTL.ARCH as Archiwalna,
 M.KTM as Produkt,
 M.N as Nazwa,
 case when substr(TKTL.REFERENCE,7,2)='__' then '  ' else '20' || substr(TKTL.REFERENCE,7,2) end as "Rok arch."

from @TKTL
 join M using(TKTL.KTM, M.REFERENCE)
  join MGR using(M.MGR, MGR.REFERENCE)
   join TPKTL using(TKTL.TYP, TPKTL.REFERENCE)

where (TPKTL.TYP like ':_c') and
      (M.R like UPPER(':_b')) and
      (MGR.KOD like ':_a') and
      (M.KTM like ':_d%') and
      (TKTL.ARCH like ':_e') and
      (TKTL.TORW='T')
order by Technologia, Grupa, Archiwalna

