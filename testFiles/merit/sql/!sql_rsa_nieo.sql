:!UTF-8
select
   OSOBA, IP, RN, OD, DO, DK,
   KSW.KOD as SW, KCH.KOD as CH,
   STD*(NK-DN-DK-OP*0.25) as KW,
   0 KOR

from
   N join
   P join
   R left join
   S_ZUS as KSW using(N.KDSW,KSW.REFERENCE) left join
   S_ZUS as KCH using(N.KDCH,KCH.REFERENCE)

where
   N.KOR='N' and
   P.FIRMA=:_f and
   ((RN not in (:_d) and LT in (:_c)) or
   (RN in (:_e) and OD<=to_date(:_b) and to_date(:_a)<=OD))