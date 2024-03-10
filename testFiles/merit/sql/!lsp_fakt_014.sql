:!UTF-8
select
	0 as LP,
	DW as Data,
	SYM as Symbol,
	KOD as KontrKod,
	SKR as KontrSkr,
	KTM as MatUslIndeks,
	N as MatUslNazwa,
	KR as KwotaRabatu
from
	:_c
order by
	2,3,4,6

