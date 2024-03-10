:!UTF-8
select
0 as LP,
QGRP1.GRP1 GRP1,
QGRP2.GRP2 GRP2,
QGRP3.GRP3 GRP3,
QGRP4.GRP4 GRP4,
M.KTM,
sum( case when substr(to_string(FAKS.DW),6,2)='01' then FAP.WN else 0 end) month_01,
sum( case when substr(to_string(FAKS.DW),6,2)='02' then FAP.WN else 0 end) month_02,
sum( case when substr(to_string(FAKS.DW),6,2)='03' then FAP.WN else 0 end) month_03,
sum( case when substr(to_string(FAKS.DW),6,2)='04' then FAP.WN else 0 end) month_04,
sum( case when substr(to_string(FAKS.DW),6,2)='05' then FAP.WN else 0 end) month_05,
sum( case when substr(to_string(FAKS.DW),6,2)='06' then FAP.WN else 0 end) month_06,
sum( case when substr(to_string(FAKS.DW),6,2)='07' then FAP.WN else 0 end) month_07,
sum( case when substr(to_string(FAKS.DW),6,2)='08' then FAP.WN else 0 end) month_08,
sum( case when substr(to_string(FAKS.DW),6,2)='09' then FAP.WN else 0 end) month_09,
sum( case when substr(to_string(FAKS.DW),6,2)='10' then FAP.WN else 0 end) month_10,
sum( case when substr(to_string(FAKS.DW),6,2)='11' then FAP.WN else 0 end) month_11,
sum( case when substr(to_string(FAKS.DW),6,2)='12' then FAP.WN else 0 end) month_12,
sum(FAP.WN) Suma
from FAP
   left join M using (FAP.M,M.REFERENCE)
   left join QGRP1 using (M.GRP1,QGRP1.REFERENCE)
   left join QGRP2 using (M.GRP2,QGRP2.REFERENCE)
   left join QGRP3 using (M.GRP3,QGRP3.REFERENCE)
   left join QGRP4 using (M.GRP4,QGRP4.REFERENCE)
   left join FAKS using (FAP.FAKS,FAKS.REFERENCE)
   left join KH using (FAKS.KH,KH.REFERENCE)
where substr(to_string(FAKS.DW),1,4)=to_string(:_a) and KH.KOD=':_b' 
group by QGRP1.GRP1,QGRP2.GRP2,QGRP3.GRP3,QGRP4.GRP4,M.KTM
order by 2,3,4,5