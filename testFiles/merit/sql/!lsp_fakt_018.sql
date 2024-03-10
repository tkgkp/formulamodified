:!UTF-8
select
	0 as LP,
	KRAJE.NAZ as KRAJ,
	KRAJE.SYM as KRAJ_SYMBOL,
	M.KTM as INDEKS, 
	M.N as NAZWA,
	FAP.IL as ILOSC,
	JM.KOD as JEDNOSTKA,
	FAKS.DO as D_DOSTAWY,
	FAKS.D as D_SPRZEDAZY,
	FAP.WWAL as W_NETTO,
	WAL_SLO.KOD as WALUTA,
	SV_SLO.KOD as STAWKA_VAT,
	FAP.WV as W_VAT,
	FAKS.SYM as F_SYMBOL,
	FAKS.DW as D_WYSTAWIENIA,
	FAKS.NAZ as MG_KRAJ,
	FAP.REFERENCE as FAP_REF
	
from
	@FAKS
	join @FAP using (FAP.FAKS, FAKS.REFERENCE) 
	left join KRAJE using (KRAJE.REFERENCE, FAKS.KRAJ_VAT)
	join M using (M.REFERENCE, FAP.M)
	join JM using (JM.REFERENCE, FAP.JM)
	join SLO SV_SLO using (SV_SLO .REFERENCE, FAP.SV) 
	join SLO WAL_SLO using (WAL_SLO.REFERENCE, FAKS.WAL)
	left join JPK_SLO  using (JPK_SLO.REFERENCE, FAKS.PROC)

where
	:_c
	and
	(
	FAKS.KRAJ_VAT is not null or FAKS.KOR in ( 
	select 
		FAKS.SYM
	from 
		FAKS 
		join KRAJE using (KRAJE.REFERENCE, FAKS.KRAJ_VAT)
	)
	)
	and (FAKS.DW>= to_date(:_a) or to_date(:_a) is null)
	and (FAKS.DW<= to_date(:_b) or to_date(:_b) is null)