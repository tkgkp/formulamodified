:!UTF-8
select 
	0 as LP,
 	FAKS.SYM as DokSymbol,
	case
		when :_f.PKWIU2<>'' and FAKS.DW<to_date('2011-01-01') then :_f.PKWIU2
		when FAKS.DW>=to_date('2011-1-1') or FAKS.DW<to_date('2011-1-1') and :_f.PKWIU2='' and ':_g'='N' then :_f.PKWIU1
		else ''
		end as PKWiU,

	FAKS.TZ DokTermPlat,
	SLO.KOD as StawkaVat,
	sum(FAP.WWAL_P) as Netto,
	sum(FAP.VWAL_P) as Vat,
	sum(FAP.BWAL_P) as Brutto
from  
	@FAP 
	join @FAKS using (FAP.FAKS, FAKS.REFERENCE)
	left join M using (FAP.M, M.REFERENCE)
	left join :_f using (:_f.REF,M.REFERENCE)
	left join SLO using (FAP.SV, SLO.REFERENCE)
	left join MPKW using (M.PKWIU, MPKW.REFERENCE)
	left join M_SV using (M_SV.M,M.REFERENCE)
where 
	FAKS.ODDZ=':_b' 
	and ((FAKS.DW between to_date(:_c) and to_date(:_d)) or (to_date(:_c) is null and to_date(:_d) is null ))
	and ((:_f.PKWIU2<>'' and FAKS.DW<to_date('2011-01-01') and :_f.PKWIU2 like '%:_a%' or ':_a' = '') or (:_f.PKWIU1 like '%:_a%' or ':_a' = ''))
	and FAKS.SZ='Z'
	and FAKS.WHERE<>'E'
	and FAKS.ZEST='T' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
	and :_e
	and (M_SV.STATUS='P' or M_SV.STATUS is null)
group by 
	1,FAKS.SYM,
	case
		when :_f.PKWIU2<>'' and FAKS.DW<to_date('2011-01-01') then :_f.PKWIU2
		when FAKS.DW>=to_date('2011-1-1') or FAKS.DW<to_date('2011-1-1') and :_f.PKWIU2='' and ':_g'='N' then :_f.PKWIU1
		else ''
		end,
	FAKS.TZ,SLO.KOD
order by 
	2

