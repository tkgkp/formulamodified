:!UTF-8
select
	0 as LP,
	KH.KOD||' '||KH.NAZ KontrKodNaz,
	GRKH.KOD KontrGrupaKod,
	sum(FAKS.NETTO) NettoSuma,
	avg(FAKS.NETTO) NettoSrednia,
	max(FAKS.NETTO) NettoMax,
	min(FAKS.NETTO) NettoMin,
	count(*) Ilosc
from  
	@FAKS
	join KH using (FAKS.KH, KH.REFERENCE)
	left join GRKH using (KH.GRKH, GRKH.REFERENCE)
where 
	FAKS.ODDZ = ':_a'
	and ((FAKS.DW between to_date(:_b) and to_date(:_c)) or (to_date(:_c) is null and to_date(:_b) is null))
	and FAKS.SZ='S'
	and FAKS.ZEST='T' and FAKS.KZ='' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
	and :_d
group by 
	KH.KOD,KH.NAZ,GRKH.KOD

UNION ALL

select
	0 as LP,
	'<< SUMA grupy >>' KontrKodNaz,
	GRKH.KOD KontrGrupaKod,
	sum(FAKS.NETTO) NettpSuma,
	avg(FAKS.NETTO) NettoSrednia,
	max(FAKS.NETTO) NettoMax,
	min(FAKS.NETTO) NettoMin,
	count(*) Ilosc
from  
	@FAKS
	join KH using (FAKS.KH, KH.REFERENCE)
	left join GRKH using (KH.GRKH, GRKH.REFERENCE)
where 
	FAKS.ODDZ = ':_a'
	and ((FAKS.DW between to_date(:_b) and to_date(:_c)) or (to_date(:_c) is null and to_date(:_b) is null))
	and FAKS.SZ='S'
	and FAKS.ZEST='T' and FAKS.KZ='' and FAKS.ZEST_AKC='T'
	and :_d
group by 
	GRKH.KOD
order by 
	3,2

