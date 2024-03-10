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
	:_a
	and FAKS.ODDZ = ':_b'
	and ((FAKS.DW between to_date(:_c) and to_date(:_d)) or (FAKS.DW>=to_date(:_c) and to_date(:_d) is null) or (to_date(:_c) is null  and FAKS.DW<=to_date(:_d)) or (to_date(:_c) is null  and to_date(:_d)is null))
	and ((FAKS.D between to_date(:_e) and to_date(:_f)) or (FAKS.D>=to_date(:_e) and to_date(:_f) is null) or (to_date(:_e) is null  and FAKS.D<=to_date(:_f)) or (to_date(:_e) is null  and to_date(:_f)is null))
	and ((FAKS.TZ between to_date(:_g) and to_date(:_h)) or (FAKS.TZ>=to_date(:_g) and to_date(:_h) is null) or (to_date(:_g) is null  and FAKS.TZ<=to_date(:_h)) or (to_date(:_g) is null  and to_date(:_h)is null))
	and FAKS.ZEST='T' and FAKS.KZ = '' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
	and FAKS.SZ='S'
	and :_i
order by
	2,3

