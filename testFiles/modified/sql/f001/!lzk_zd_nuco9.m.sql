:!UTF-8
select
	0 as "Lp",
	KH.KOD as "Kod klienta",
	KH.SKR as "Nazwa klienta",
	ZK_N.NR as "Numer zam",
	ZK_N.SYM as "Symbol zam",
	ZK_N.ZAM_KL as "Symbol zam klienta",
	ZK_N.DP as "Data zlozenia zam",
	ZK_N.DT as "Planowany termin realizacji",
	ZK_N.OP as "Uwagi",
	M.KTM as "KTM",
	M.N as "Nazwa",
	JM.KOD as "Jednostka",
	ZK_P.ILZ as "Ilosc zamawiana",
	ZK_P.ILP as "Ilosc pozostala do realizacji",
	sum(ZK_RP.ILR) as "Ilość w realizacji",
	sum(DK.IL) as "Ilość na WZ",
	sum(DK.IL) - sum(ZK_RP.ILR) as "Różnica WZ vs realizacja",
	ZK_P.NETTO/ZK_P.ILZ as "Cena jednostkowa",
	ZK_P.NETTO as "Wartosc zamawiana"
from
	@ZK_P
	join @ZK_N using (ZK_P.N,ZK_N.reference)
	join KH using (ZK_N.KH,KH.reference)
	join M using (ZK_P.M,M.reference)
	join JM using (M.J,JM.reference)
	left join @ZK_RP using (ZK_RP.P, ZK_P.REFERENCE)
	left join @DK using (DK.ZAM_RP,ZK_RP.REFERENCE)
where
	ZK_N.DP between to_date(:_a) and to_date(:_b)
	and (ZK_N.SYM like '%:_c%' or ':_c' = '')
group by 1,KH.KOD,KH.SKR,ZK_N.NR,ZK_N.SYM,ZK_N.ZAM_KL,ZK_N.DP,ZK_N.DT,ZK_N.OP,M.KTM,M.N,JM.KOD,ZK_P.ILZ,ZK_P.ILP,ZK_P.NETTO
order by
	2,4,6,8
