:!UTF-8

select
   0 as LP,
   POLWO.SYM,
   POLWO.DATA,
   OSOBA.NAZWISKO,
   OSOBA.PIERWSZE,
   OSOBA.DRUGIE,
   P.T,
   MGRP.KOD as MGRP,
   PWOPOZ.IL
from PWOPOZ join POLWO join P join OSOBA join MGRP
where POLWO.AKCEPT='T' and POLWO.DATA_G is null

