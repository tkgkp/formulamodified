:!UTF-8
select
	0 as "Lp",
	KH.KOD as "Kod klienta",
	KH.SKR as "Nazwa klienta",
	ZK_N.NR as "Numer zam",
	ZK_N.SYM as "Symbol zam",
	ZK_N.DP as "Data zlozenia zam",
	ZK_N.DT as "Planowany termin realizacji",
	M.KTM as "KTM",
	M.N as "Nazwa",
	JM.KOD as "Jednostka",
	ZK_P.ILZ as "Ilosc zamawiana",
	ZK_P.ILP as "Ilosc pozostala do realizacji",
	SM.SD as "Aktualnie dostępne"
from
	@ZK_P
	join @ZK_N using (ZK_P.N,ZK_N.reference)
	join KH using (ZK_N.KH,KH.reference)
	join M using (ZK_P.M,M.reference)
	join JM using (M.J,JM.reference)
	join MG using (ZK_P.MG,MG.reference)
	join SM using(SM.M,M.reference)
where
	ZK_N.A = 'A' AND ZK_P.ILP != 0 AND SM.MAG = ZK_P.MG
group by 1,KH.KOD,KH.SKR,ZK_N.NR,ZK_N.SYM,ZK_N.DP,ZK_N.DT,M.KTM,M.N,JM.KOD,ZK_P.ILZ,ZK_P.ILP,SM.SD
order by
	2,4,6,8