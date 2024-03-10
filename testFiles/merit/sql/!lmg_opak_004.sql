:!UTF-8
select 
	0 as LP,
	KH_KOD as KontrKod, 
	KH_SKR as KontrSkr, 
	MAG as MagSymbol, 
	INDEKS as MatIndeks, 
	NAZWA as MatNaz, 
	sum(case PLUS when 'T' then IL when 'N' then 0 end)  as IloscPrzy,
 	sum(case PLUS when 'N' then IL when 'T' then 0 end)  as IloscWyd,
	sum(case PLUS when 'T' then WAR when 'N' then 0 end)  as WarPrzy,
 	sum(case PLUS when 'N' then WAR when 'T' then 0 end)  as WarWyd,
	sum(case PLUS when 'N' then -IL when 'T' then IL end)  as BilIlosc,
	sum(case PLUS when 'N' then -WAR when 'T' then WAR end)  as BilWar
from 
	:_a
group by
	KH_KOD,KH_SKR,MAG,INDEKS,NAZWA

