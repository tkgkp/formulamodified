:!UTF-8
select
	0 as LP,
	KH.KOD as KOD,
	ZK_N.ZAM_KL as Customer_order_number,
	ZK_N.DP as order_date,
                     ZK_N.DT as delivery_date,
	M.KTM as KTM,
	TRANSLAT.T as Customer_article_number,
	ZK_P.ILZ as ordered_quantity,
	SUM(ZK_RP.ILR) as purchase_order_quantity,
	ZK_P.CENA as order_price_per_unit,
	ZK_P.ILP as quantity_released,
	FAKS.KRS as rate_currency
from
	@ZK_RP
	join @ZK_RN using (ZK_RP.N,ZK_RN.reference)
	join @ZK_N using (ZK_RN.N,ZK_N.reference)
	join @ZK_P using (ZK_RP.P,ZK_P.reference)
	join KH using (ZK_N.KH,KH.reference)
	join M using (ZK_RP.M,M.reference)
	left join TRANSLAT using (TRANSLAT.M,M.reference)
	join @FAKS using (ZK_RN.FAKS,FAKS.reference)
	left join SLO using (TRANSLAT.JEZYK,SLO.reference)
where
	ZK_N.DT between to_date(:_a) and to_date(:_b)
	and SLO.KOD='ANG'
group by
	KH.KOD,ZK_N.ZAM_KL,ZK_N.DP,M.KTM,TRANSLAT.T,ZK_P.ILZ,ZK_P.CENA,ZK_P.ILP,ZK_N.DT,FAKS.KRS
order by
	2,5,3