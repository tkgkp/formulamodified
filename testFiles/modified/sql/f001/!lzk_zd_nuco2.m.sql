:!UTF-8
select
	0 as LP,
	KH.KOD as KontrKod,
	KH.SKR as KontrSkr,
	ZDP_NAG.SYM as PotwSym,
	ZD_NAG.DATA as ZamDataPrzyjecia,
	ZDP_NAG.D_WYS as PotwDataWysylki,
	ZDP_NAG.D_REA as PotwDataDostawy,
	ZD_RN.DR as DataReal,
	CAST(ZDP_NAG.D_WYS as REAL_TYPE) - CAST(ZD_RN.DR as REAL_TYPE) as IlDniDoPotwDataWysylki,
	M.KTM as MatIndeks,
	JM.KOD as Jm,
	ZDP_POZ.IL as PotwIl,
	ZD_RP.IL_ZRE as IlZre,
	M.N as NatNaz
from
	@ZDP_POZ
	join @ZDP_NAG using (ZDP_POZ.ZDP_NAG,ZDP_NAG.reference)
	join @ZD_POZ using (ZDP_POZ.ZD_POZ,ZD_POZ.reference)
	join @ZD_NAG using (ZD_POZ.ZD_NAG,ZD_NAG.reference)
	join KH using (ZD_NAG.KH,KH.reference)
	join M using (ZD_POZ.M,M.reference)
	join JM using (M.J,JM.reference)
	left join @ZD_RP using(ZD_RP.ZDP_POZ,ZDP_POZ.reference)
	left join @ZD_RN using (ZD_RP.ZD_RN,ZD_RN.reference)
where
	ZDP_NAG.AKC = 'T'
	and ((ZDP_NAG.D_WYS between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null))
order by
	KontrKod,PotwSym,ZamDataPrzyjecia,PotwDataWysylki
