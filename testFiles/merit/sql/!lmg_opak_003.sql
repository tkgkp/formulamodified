:!UTF-8
select 
	0 as LP,
	GR as Gr,
	KH_KOD as KontrKod, 
	KH_SKR as KontrSkr, 
	MAG as MagSymbol, 
	DATA_ZWR as OpakDataZwr, 
	DOKUMENT as DokSymPoz, 
	INDEKS as MatIndeks, 
	NAZWA as MatNaz, 
	KAUCJA as Kaucja, 
	IL_POZ as Ilosc, 
	WAR_POZ as Wartosc
from 
	:_b
order by 
	2,3,4,5,6,7

