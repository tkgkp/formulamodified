:!UTF-8
select
	0 as "Lp",
	KH.KOD as "Kod kontrahenta",
	KH.SKR as "Nazwa kontrahenta",
	ZD_NAG.SYM as "Symbol zamowienia",
	ZD_NAG.DATA as "Data zamowienia",
	ZD_NAG.DTPREAL as "Planowana data realizacji",
	ZDP_NAG.D_REA as "Potwierdzona data dostawy",
	M.KTM as "KTM",
	M.N as "Nazwa",
	ZD_POZ.IL as "Ilosc zamowiona",
	ZD_POZ.IL_ZRE as "Ilosc zrealizowana",
	ZD_POZ.IL_POZ as "Ilosc pozostala",
	ZDP_POZ.IL as "Ilosc potwierdzona",
	JM.KOD as "Jm"
from
	ZDP_POZ
	join ZDP_NAG using (ZDP_POZ.ZDP_NAG,ZDP_NAG.reference)
	join ZD_POZ using (ZDP_POZ.ZD_POZ,ZD_POZ.reference)
	join ZD_NAG using (ZD_POZ.ZD_NAG,ZD_NAG.reference)
	join KH using (ZD_NAG.KH,KH.reference)
	join M using (ZD_POZ.M,M.reference)
	join JM using (M.J,JM.reference)
where
	ZDP_NAG.AKC = 'T'
	and ZD_POZ.IL_POZ > 0
	and ZDP_POZ.IL > 0
	and (ZD_NAG.STAN <> 'M' and ZD_NAG.STAN <> 'Z' and ZD_NAG.STAN <> '-')
group by
	1,KH.KOD,KH.SKR,ZD_NAG.SYM,ZD_NAG.DATA,ZD_NAG.DTPREAL,ZDP_NAG.D_REA,M.KTM,M.N,ZD_POZ.IL,ZD_POZ.IL_ZRE,ZD_POZ.IL_POZ,ZDP_POZ.IL,JM.KOD
order by
	"Kod kontrahenta","Data zamowienia","Symbol zamowienia","KTM"
