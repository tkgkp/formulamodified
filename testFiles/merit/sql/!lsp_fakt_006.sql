:!UTF-8
select
	0 as LP,
	GRKH.KOD KontrGrupaKod,
	KH.KOD||' '||KH.NAZ KontrKodNaz,
	sum(FAKS.NETTO) Netto,
	sum(FAKS.VAT) Vat,
	sum(FAKS.BRUTTO) Brutto
from  
	@FAKS
	join KH using (FAKS.KH,KH.REFERENCE)
	left join GRKH using (KH.GRKH, GRKH.REFERENCE)
where 
	FAKS.ODDZ = ':_a'
	and ((FAKS.DW between to_date(:_b) and to_date(:_c)) or (to_date(:_b) is null and to_date(:_c) is null))
	and (GRKH.KOD like ':_e%' or ':_e'='')
	and FAKS.SZ='S'
	and FAKS.ZEST='T' and FAKS.KZ='' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
	and :_f
group by 
	GRKH.KOD,KH.KOD,KH.NAZ
having 
	sum(FAKS.NETTO)>=:_d
order by 
	4 desc,2,3

