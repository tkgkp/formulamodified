:!UTF-8
/* Parametry:
    _a - data przyjęcia reklamacji od (może być 0000/00/00, wtedy od dowolnej daty)
    _b - data przyjęcia reklamacji do (może być 0000/00/00, wtedy do dowonlej daty)
*/
select
   0 as LP,
   REK_N.SYM as "Symbol reklamacji",
   REK_R.KOD as "Rodzaj reklamacji",
   KH.SKR as "Kontrahent",
   KH_ODB.NAZ as "Odbiorca",
   KH_OSOB.IMIE || ' ' || KH_OSOB.NAZWISKO as "Osoba kontaktowa",
   NVL(M.KTM,'') as "Towar",
   REK_N.DP as "Data powołania",
   REK_N.DZ as "Data zakończenia",
   REK_N.DX as "Data zamknięcia",
   substr(to_string(REK_N.DP),1,7) as "Miesiąc",
   substr(to_string(REK_N.DP),1,4) as "Rok",
   1 as "Liczba reklamacji",
   (cast(NVL(REK_N.DZ,SYSDATE) as REAL_TYPE)
     -cast(REK_N.DP as REAL_TYPE)
     +1
   ) as "Czas rozpatrzenia (dni)",
   CASE WHEN REK_N.DZ=TO_DATE('0000/00/00')
   THEN 0
   ELSE (cast(NVL(REK_N.DX,SYSDATE) as REAL_TYPE)
        -cast(REK_N.DZ as REAL_TYPE)
        +1)
   END as "Czas realizacji (dni)",
  sum(REK_N.KOSZT) as "Koszty"
from
   REK_N
   left join REK_R
   left join KH
   join M
   left join KH_ODB using (REK_N.KH_ODB,KH_ODB.REFERENCE)
   left join KH_OSOB using (REK_N.KH_OSOB,KH_OSOB.REFERENCE)
where
   (REK_N.SZ='S')
   and ((REK_N.DP between to_date(:_a) and to_date(:_b)) or
   (:_a='0000-0-0' and :_b='0000-0-0') or
   (REK_N.DP>to_date(:_a) and :_b='0000-0-0') or
   (REK_N.DP<to_date(:_b) and :_a='0000-0-0'))
   and :_c
   and :_d
group by
    REK_N.SYM,REK_R.KOD,REK_N.DP, REK_N.DZ,REK_N.DX,KH.SKR,M.KTM,KH_ODB.NAZ,KH_OSOB.IMIE || ' ' || KH_OSOB.NAZWISKO
order by 3,5
