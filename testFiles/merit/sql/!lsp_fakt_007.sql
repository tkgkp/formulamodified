:!UTF-8
select
	0 as LP,
	GRKH.KOD KontrGrupaKod,
	sum(FAKS.NETTO) NettoSuma,
	avg(FAKS.NETTO) NettoSrednia,
	max(FAKS.NETTO) NettoMax,
	min(FAKS.NETTO) NettoMin,
	count(*) IIosc
from  
	@FAKS
	join KH using (FAKS.KH, KH.REFERENCE)
	left join GRKH using (KH.GRKH, GRKH.REFERENCE)
	join TYPYSP using (FAKS.T, TYPYSP.REFERENCE)
	left join TYPYSP TYPYSPFP using (FAKS.SYMF_T,TYPYSPFP.REFERENCE)
where 
	FAKS.ODDZ = ':_a'
	and ((FAKS.DW between to_date(:_b) and to_date(:_c)) or (to_date(:_b) is null and to_date(:_c) is null))
	and FAKS.SZ='S'
	and FAKS.ZEST='T' and FAKS.KZ='' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
	and :_e
group by 
	GRKH.KOD
having 
	sum(FAKS.NETTO)>':_d'
order by 
	2

