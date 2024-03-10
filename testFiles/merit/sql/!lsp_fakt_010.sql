:!UTF-8
select
	0 as LP,
	FAPOW.KOREKTA as ZalCzyKor,
	FAPOW.ZK_N_SYM as ZamSymbol,
	FAPOW.FAKS_SYM as ZalSymbol,
	to_string(FAPOW.DW) as ZalDataWyst,
	to_string(FAPOW.D) as ZalDataOtrzy,
	KH.SKR as KontrSkr,
	FAPOW.END_SYM as FaktKoncowa,
	FAPOW.WAL as Wal,
	FAPOW.KW as ZalKwota,
	FAPOW.KW_PO_K as ZalKwotaPoKor,
	FAPOW.KW_ROZ as ZalKwotaRozliczona
from
	FAPOW
	join KH using (FAPOW.KH,KH.REFERENCE)
	join @FAKS using (FAPOW.FAKS,FAKS.REFERENCE)
where
	FAKS.SZ='S' and FAKS.STAT_REJ<>'A'	
	and ((FAKS.DW between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null))
	and ((FAKS.D between to_date(:_c) and to_date(:_d)) or (to_date(:_c) is null and to_date(:_d) is null))
	and ((FAKS.TZ between to_date(:_e) and to_date(:_f)) or (to_date(:_e) is null and to_date(:_f) is null))
	and :_g  
	and :_h
order by 
	2,3,7

