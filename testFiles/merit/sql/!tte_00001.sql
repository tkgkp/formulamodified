:!UTF-8
/* Zlecenia,
   Parametry:
    _a - stan zlecenia  (* - wszystkie stany zlecen)
    _b - powołane od  (może być 0000/00/00, wtedy tylko do)
    _c - powołane do (może być 0000/00/00, wtedy tylko od)
    _d - WP (warsztatowe/produkcyjne)  (* - wszystkie)
    _e - Rodzaj(Proste/Złożone) (* - wszystkie)
    _f - JORG  (* - wszystkie)
    _g - dla kontrahenta (* - wszystkie)
*/

select
 0 as LP,
 ZL.SYM as Symbol,
 ZL.OPIS as Opis,
 ZL.OD as Od,
 ZL.DO as Do,
 ZL.STAN as Stan,
 ZL.RODZAJ as Rodzaj,
 SLO.KOD as Wydział,
 KH.KOD as Kontrahent

from ZL
 join ZTP using (ZL.TYP, ZTP.REFERENCE)
  left join SLO using (ZL.JORG, SLO.REFERENCE)
   left join KH using (ZL.KH, KH.REFERENCE)

where
      (ZL.STAN like UPPER(':_a')) and
      ((ZL.OD between to_date(:_b) and to_date(:_c)) or
       (:_b='0000-0-0' and :_c='0000-0-0') or
       (ZL.OD>to_date(:_b) and :_c='0000-0-0') or
       (ZL.OD<to_date(:_c) and :_b='0000-0-0')
      ) and
      (ZTP.WP like ':_d') and
      (ZL.RODZAJ like ':_e') and
      ((SLO.KOD like ':_f') or (':_f'='%' and SLO.KOD is null)) and
      ((KH.KOD like ':_g') or (':_g'='%' and KH.KOD is null))

order by Symbol

