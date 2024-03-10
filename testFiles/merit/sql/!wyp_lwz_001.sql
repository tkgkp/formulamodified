:!UTF-8

select
   0 as LP,
   ODZAM.DATA_W,
   ODZAM.SYM,
   MGRP.KOD as MGRP,
   M.KTM,
   M.N,
   ODZAMPT.IL,
   OSOBA.NAZWISKO,
   OSOBA.PIERWSZE,
   OSOBA.DRUGIE,
   P.T,
   DK_C.WAR01 as "Wartość 01",
   DK_C.WAR02 as "Wartość 02",
   DK_C.WAR03 as "Wartość 03",
   DK_C.WAR04 as "Wartość 04",
   DK_C.WAR05 as "Wartość 05",
   DK_C.WAR06 as "Wartość 06",
   DK_C.WAR07 as "Wartość 07",
   DK_C.WAR08 as "Wartość 08",
   DK_C.WAR09 as "Wartość 09",
   DK_C.WAR10 as "Wartość 10"
from ODZAMPT
   join ODZAM using (ODZAMPT.ODZAM, ODZAM.REFERENCE)
   join MGRP using(ODZAMPT.MGRP, MGRP.REFERENCE)
   join P using (ODZAMPT.P, P.REFERENCE)
   join OSOBA using(P.OSOBA,OSOBA.REFERENCE)
   left join M using (ODZAMPT.M, M.REFERENCE)
   left join DK_C using (ODZAMPT.DK_C, DK_C.REFERENCE)
where
   ODZAM.STAN='T'

