:!UTF-8
select 0 as LP,
FAKS.DW Data,
FAKS.SYM,
MGR.KOD Grupa,
HAN.NAZ Handloweic,
KH.KOD "Kod KH",
KH.NAZ Kontrahent,
M.KTM Kod_towaru,
M.N Nazwa,
QGRP1.GRP1 GRP1,
QGRP2.GRP2 GRP2,
QGRP3.GRP3 GRP3,
QGRP4.GRP4 GRP4,
QGRP5.GRP5 Rodzaj,
QGRP6.GRP6 Brand,
FAP.IL Ilość,
FAP.WN Wartość_PLN,
SLO.KOD Wal_handl,
FAP.WWAL Wartość_w_wal
from FAP
   left join FAKS using (FAP.FAKS,FAKS.REFERENCE)
   left join M using (FAP.M,M.REFERENCE)
   left join MGR using (M.MGR,MGR.REFERENCE)
   left join HAN using (FAKS.HAN,HAN.REFERENCE)
   left join KH using (FAKS.KH,KH.REFERENCE)
   left join QGRP1 using (M.GRP1,QGRP1.REFERENCE)
   left join QGRP2 using (M.GRP2,QGRP2.REFERENCE)
   left join QGRP3 using (M.GRP3,QGRP3.REFERENCE)
   left join QGRP4 using (M.GRP4,QGRP4.REFERENCE)
   left join QGRP5 using (M.GRP5,QGRP5.REFERENCE)
   left join QGRP6 using (M.GRP6,QGRP6.REFERENCE)
   left join SLO using(FAKS.WAL,SLO.REFERENCE)
where substr(to_string(FAKS.DW),1,4)=to_string(:_a)
order by 2,3,4,5,6,7,8,9