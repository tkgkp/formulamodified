:!UTF-8
select
	0 as LP,
	KH.KOD as KontrKod,
	KH.SKR as KontrSkr,
	ZD_NAG.SYM as ZamSymbol,
	ZD_NAG.DATA as ZamDataPrzyjecia,
	ZD_NAG.DTPREAL as PlanDataReal,
	ZD_RN.DR as DataReal,
	CAST(ZD_RN.DR as REAL_TYPE) - CAST(ZD_NAG.DTPREAL as REAL_TYPE) as IlDniPoPlanDataReal,
	M.KTM as MatIndeks,
	JM.KOD as Jm,
	ZD_RP.IL_ZRE as IlZre,
	M.N as MatNaz,
	ZD_NAG.STAT_REJ as StatRej
from
	@ZD_RP
	join @ZD_RN using (ZD_RP.ZD_RN,ZD_RN.reference)
	join @ZD_NAG using (ZD_RN.ZD_NAG,ZD_NAG.reference)
	join KH using (ZD_NAG.KH,KH.reference)
	join M using (ZD_RP.M,M.reference)
	join JM using (M.J,JM.reference)
where
	(ZD_RN.DR between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null)
order by
	KontrKod,ZamSymbol,ZamDataPrzyjecia,PlanDataReal

