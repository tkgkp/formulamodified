:!UTF-8
select
	LP,
	D StanNaDzien,
	KH KontrKod,
	KH_ODB OdbKod,
	KTM MatIndeks,
	N MatNaz,
	N_SK StanKNaszych,
	N_WK WartKNaszych,
	KH_SK StanKKontr,
	KH_WK WartKKontr,
	N_SBK StanBKNaszych,
	KH_SBK StanBKKontr,
	JM Jm
from
	 :_c
order by
	2,3,4,5

