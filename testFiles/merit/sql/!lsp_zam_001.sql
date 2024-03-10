:!UTF-8
select
	0 as LP,
	KH.KOD as KontrKod,
	KH.SKR as KontrSkr,
	ZK_N.SYM as ZamSym,
	ZK_N.DP as ZamDataPrzyjecia,
	ZK_N.DT as PlanDataReal,
	ZK_RN.DR as DataReal,
	CAST(ZK_RN.DR as REAL_TYPE) - CAST(ZK_N.DT as REAL_TYPE) as IlDniPoPlanDataReal,
	M.KTM as MatIndeks,
	JM.KOD as Jm,
	ZK_RP.ILR as IlZre,
	M.N as MatNaz,
	ZK_N.STAT_REJ as StatRej
from
	@ZK_RP
	join @ZK_RN using (ZK_RP.N,ZK_RN.reference)
	join @ZK_N using (ZK_RN.N,ZK_N.reference)
	join KH using (ZK_N.KH,KH.reference)
	join M using (ZK_RP.M,M.reference)
	join JM using (M.J,JM.reference)
where
	(ZK_RN.DR between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null)
order by
	KontrKod,ZamSym,ZamDataPrzyjecia,PlanDataReal

