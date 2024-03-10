:!UTF-8
select
	0 as LP,
	M.KTM as MatIndeks,
	M.N as MatNaz,
	case when MST1.MIN<>0 then MST1.MIN else MST2.MIN end as NormaMin,
	case when MST1.MAX<>0 then MST1.MAX else MST2.MAX end as NormaMax
from
	M
	left join :_b MST1 using (MST1.M,M.reference)
   left join :_c MST2 using (MST2.M,M.reference)
order by
   2

