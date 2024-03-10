:!UTF-8
select
	0 as LP,
	SLO.TR as Przyczyna_korekty,
        ZR_SLO.WAR as Czy_w_bieżącym_mc,
	FAKS.DW as Data_Wystawienia,
	FAKS.SYM as Symbol,
	KH.KOD as Kontr_Kod,
	KH.SKR as Kontr_Skr,
	M.KTM as Indeks_Mat,
	M.N as Nazwa_Mat,
	FAP.WWAL_P as Netto,
	FAP.VWAL_P as Vat,
	FAP.BWAL_P as Brutto                      
from
	@FAP
	join @FAKS using (FAP.FAKS,FAKS.reference)
	join KH using (FAKS.KH,KH.reference)
	join TYPYSP using (FAKS.T,TYPYSP.reference)
	left join M using (FAP.M,M.reference)
                      left join SLO using (FAP.POWKOR, SLO.reference)
                      left join ZR_SLO 
where
	FAKS.ODDZ = ':_a'
	and FAKS.SZ = 'S'
	and TYPYSP.KOR = 'T'
	and ((FAKS.DW between to_date(:_b) and to_date(:_c)) or (to_date(:_b) is null and to_date(:_c) is null))
	and FAKS.ZEST = 'T' and FAKS.ZEST_AKC = 'T' and FAKS.STAT_REJ<>'A'
	and :_d 

