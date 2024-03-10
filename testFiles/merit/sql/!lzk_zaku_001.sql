:!UTF-8
select 
	0 as LP,
	KH.KOD||' '||KH.NAZ KontrKodNaz,
	FAKS.SYM DokSymbol,
	FAKS.NETTO Netto,
	FAKS.VAT Vat,
	FAKS.BRUTTO Brutto
from  
	@FAKS 
	join KH using (FAKS.KH,KH.REFERENCE)
where 
	(KH.KOD = ':_a' or ':_a' ='')
	and FAKS.ODDZ = ':_b'
	and (FAKS.DW between to_date(:_c) and to_date(:_d) or (to_date(:_c) is null and to_date(:_d) is null))
	and FAKS.SZ='Z'
	and FAKS.WHERE<>'E'
	and FAKS.ZEST='T' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
	and :_e
order by 
	2,3

