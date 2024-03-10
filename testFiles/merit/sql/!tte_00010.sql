:!UTF-8
/*
 Liczba i wielkość zleceń dla wyrobów i półfabrykatoów:
 Parametry: _a - Wyrób, półfabrykat (W,P, * - wszystkie towary)
            _b - Stan zlecenia (N,O,Z,* - wszystkie stany)
            _c - Grupa towaru (* - wszystkie grupy)
            _d - Kod towaru (* - wszystkie towary)
            _e - Karta technologiczna (* - wszystkie karty technologiczne)
            _f - wersja (* - wszystkie wersje)

*/

select
   0 as LP,
   MGR.KOD as Grupa,
   M.KTM as Produkt,
   M.N as "Nazwa produktu",
   TKTL.NRK as Technologia,
   TKTL.WER as Wersja,
   sum(ZL.IL) as Ilość,
   sum(ZL.ILWYK) as Wykonano,
   count(ZL.REFERENCE) as "Powołano zleceń"

from ZL
   join M using(ZL.KTM,M.REFERENCE) join MGR using(M.MGR,MGR.REFERENCE)
   left join TKTL using(ZL.RKTL,TKTL.REFERENCE)

where
   (ZL.RKTL<>'') and
   (M.R like UPPER(':_a')) and
   (ZL.STAN like UPPER(':_b')) and
   (MGR.KOD like ':_c') and
   (M.KTM like ':_d') and
   (TKTL.NRK like ':_e%') and
   (TKTL.WER like ':_f')

group by MGR.KOD, M.KTM, M.N, TKTL.NRK, TKTL.WER

order by Produkt, Technologia, Wersja

