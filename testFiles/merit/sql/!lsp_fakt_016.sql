:!UTF-8
select
	0 as LP,
	SLO.TR as PowodKorekty,
	sum(FAP.WWAL_P) as Netto,
	sum(FAP.VWAL_P) as Vat,
	sum(FAP.BWAL_P) as Brutto
from
	@FAP
	join SLO using (FAP.POWKOR,SLO.reference)
	join @FAKS using (FAP.FAKS,FAKS.reference)
	join TYPYSP using (FAKS.T,TYPYSP.reference)
where
	FAKS.ODDZ = ':_a'
	and FAKS.SZ = 'S'
	and TYPYSP.KOR = 'T'
	and ((FAKS.DW between to_date(:_b) and to_date(:_c))or (FAKS.DW>=to_date(:_b) and to_date(:_c) is null) or (to_date(:_b) is null  and FAKS.DW<=to_date(:_c)) or (to_date(:_b) is null  and to_date(:_c)is null))
	and FAKS.ZEST='T' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
	and :_d
group by
	SLO.TR

