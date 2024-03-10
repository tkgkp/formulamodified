:!UTF-8
select
	0 as LP,
	FAKS.SYM as DokSymbol,
	FAKS.TZ DokTermPlat,
	SLO.KOD as StawkaVat,
	sum(FAP.WWAL_P) as Netto,
	sum(FAP.VWAL_P) as Vat,
	sum(FAP.BWAL_P) as Brutto
from  
	@FAP
	join @FAKS using (FAP.FAKS, FAKS.REFERENCE)
	left join SLO using (FAP.SV, SLO.REFERENCE)
where 
	FAKS.ODDZ=':_b'
	and ((FAKS.DW between to_date(:_c) and to_date(:_d)) or (to_date(:_c) is null and to_date(:_d) is null))
	and (FAKS.SYM like '%:_a%' or ':_a' = '')
	and FAKS.SZ='S'
	and FAKS.ZEST='T' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
	and :_e
group by 
	1,FAKS.SYM,FAKS.TZ,SLO.KOD
order by 
	2

