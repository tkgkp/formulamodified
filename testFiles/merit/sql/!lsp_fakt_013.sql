:!UTF-8
select
	0 as LP,
	FAKS.TZP as KorPrzyczyna,
	FAKS.DW as KorDataWyst,
	FAKS.SYM as KorSym,
	KH.KOD as KontrKod,
	KH.SKR as KontrSkr,
	M.KTM as MatUslIndeks,
	M.N as MatUslNazwa,
	FAP.WWAL_P as Netto,
	FAP.VWAL_P as Vat,
	FAP.BWAL_P as Brutto
from
	@FAP
	join @FAKS using (FAP.FAKS,FAKS.reference)
	join KH using (FAKS.KH,KH.reference)
	join TYPYSP using (FAKS.T,TYPYSP.reference)
	left join M using (FAP.M,M.reference)
where
	FAKS.ODDZ = ':_a'
	and FAKS.SZ = 'S'
	and TYPYSP.KOR = 'T'
	and ((FAKS.DW between to_date(:_b) and to_date(:_c)) or (to_date(:_b) is null and to_date(:_c) is null))
	and FAKS.ZEST = 'T' and FAKS.ZEST_AKC = 'T' and FAKS.STAT_REJ<>'A'
	and :_d

