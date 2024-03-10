:!UTF-8
select
   P.OSOBA, P.IP, R.RN, N.OD, N.DO, N.DK,
   KSW.KOD as SW, KCH.KOD as CH,
   N.WART as KW, N.REFERENCE REF, N.RODZAJ

from
   N join
   P join
   R join
   F_ZATR using(P.F_ZATR, F_ZATR.REFERENCE) left join
   S_ZUS as KSW using(N.KDSW,KSW.REFERENCE) left join
   S_ZUS as KCH using(N.KDCH,KCH.REFERENCE)

where
   F_ZATR.KOD='P' and (N.KOR='T' or N.RODZAJ='K') and
   P.FIRMA=:_f and
   ((R.RN not in (:_d) and N.LT in (:_c)) or
   (R.RN in (:_e) and N.OD<=to_date(:_b) and to_date(:_a)<=N.OD))