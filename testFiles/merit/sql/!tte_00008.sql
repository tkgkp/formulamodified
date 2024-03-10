:!UTF-8
/*
  Grupowanie analiz zleceń wg towarów
  (Tylko analizy domyślne dla zlecenia)
  Parametry: _a - stan zlecenia (N,H,O,Z,* - wszystkie typy)
             _b - numer roku (musi być wypełnione)
             _c - numer okresu (musi być wypełnione)
             _d - analiza/kalkulacja (1/0) (musi być wypełnione)
             _e,_f,_g,_h - numery rubryk (muszą być wypełnione)
*/

select
 0 as LP,
 M.KTM as KTM,
 M.N as Nazwa,
 ANRUB.NR as Rubryka,
 ANRUB.OPIS as Opis,
 sum (ANZP.WAR) as Wartość,
 avg (ANZP.WAR) as Średnia,
 min (ANZP.WAR) as Minimum,
 max (ANZP.WAR) as Maksimum
from ANZP
 join ANRUB using (ANZP.RUBR, ANRUB.REFERENCE)
  join ANZH using (ANZP.NRA, ANZH.REFERENCE)
   join ZL using (ANZH.ZLEC, ZL.REFERENCE)
    join M using (ZL.KTM, M.REFERENCE)
     join ANWAR using(ANZH.OPC, ANWAR.REFERENCE)
      join OKR using (ANZH.OKR, OKR.REFERENCE)
where (ZL.STAN like UPPER(':_a'))
      and OKR.ROK=:_b and OKR.MC=:_c
      and (ANRUB.NR=:_e or ANRUB.NR=:_f or ANRUB.NR=:_g or ANRUB.NR=:_h)
      and ((ZL.DEF_OPCA=ANWAR.REFERENCE and ':_d'='1') or (ZL.DEF_OPCK=ANWAR.REFERENCE and ':_d'='0'))
group by M.KTM, M.N, ANRUB.NR, ANRUB.OPIS
order by KTM, Rubryka


