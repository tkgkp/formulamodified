:!UTF-8
/*
  Grupowanie analiz zleceń wg grup towarowych

  Parametry: _a - stan zlecenia  (N,H,O,Z,* - wszystkie)
             _b - numer roku  (np. 2007 musi być wypełnione)
             _c - numer okresu (musi być wypełnione)
             _d - Analiza/Zlecenie (1/0 musi być wypełnione)
             _d,_e,_f,_g - numery rubryk (musi być wypełnione)
*/

select
 0 as LP,
 MGR.KOD as Grupa,
 ANRUB.NR as Rubryka,
 ANRUB.OPIS as Opis,
 sum (ANZP.WAR) as Wartość,
 avg (ANZP.WAR) as Średnia
from ANZP
 join ANRUB using (ANZP.RUBR, ANRUB.REFERENCE)
  join ANZH using (ANZP.NRA, ANZH.REFERENCE)
   join ZL using (ANZH.ZLEC, ZL.REFERENCE)
    join M using (ZL.KTM, M.REFERENCE)
     join MGR using (M.MGR, MGR.REFERENCE)
      join ANWAR using(ANZH.OPC, ANWAR.REFERENCE)
       join OKR using (ANZH.OKR, OKR.REFERENCE)
where (ZL.STAN like UPPER(':_a'))
      and OKR.ROK=:_b and OKR.MC=:_c
      and (ANRUB.NR=:_e or ANRUB.NR=:_f or ANRUB.NR=:_g or ANRUB.NR=:_h)
      and ((ZL.DEF_OPCA=ANWAR.REFERENCE and ':_d'='1') or (ZL.DEF_OPCK=ANWAR.REFERENCE and ':_d'='0'))
group by MGR.KOD, ANRUB.NR, ANRUB.OPIS

