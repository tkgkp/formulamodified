:!UTF-8
select 
	0 as LP,
	KH.KOD KontrKod,
	KH.NAZ KontrNaz,
	KH.MIASTO KontrMiasto,
	KH.UL KontrUlica,
	M.KTM MatUslIndeks,
	M.N NazwaIndeks,
	sum(FAP.IL) Ilosc,
	sum(FAP.WB) Brutto
from  
	@FAP 
	join @FAKS using (FAP.FAKS, FAKS.REFERENCE)
	join KH using (FAKS.KH, KH.REFERENCE)
	join M using (FAP.M, M.REFERENCE)
where 
	(upper(KH.KOD) like upper('%:_a%') or ':_a'='')
	and (upper(KH.NAZ) like upper('%:_b%') or ':_b'='')
	and (upper(KH.MIASTO) like upper('%:_c%')  or ':_c'='')
	and (upper(KH.UL) like upper('%:_d%')  or ':_d'='')
	and (upper(KH.NIP) like upper('%:_e%') or  ':_e'='')
	and FAKS.ODDZ = ':_f'
	and (FAKS.DW>= to_date(:_g) or to_date(:_g) is null)
	and (FAKS.DW<= to_date(:_h) or to_date(:_h) is null)
	and (upper(M.KTM) like upper(':_i%') or ':_i'='')  
	and FAKS.SZ='Z'
	and FAKS.ZEST='T' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
	and :_j
group by 
	KH.KOD, KH.NAZ, KH.MIASTO, KH.UL, M.KTM, M.N
order by 
	2

