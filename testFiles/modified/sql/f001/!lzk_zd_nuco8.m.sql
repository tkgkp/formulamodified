:!UTF-8
select
	0 			as LP
	,ZD_NAG.SYM		as "Symbol"
	,ZD_NAG.ZAM_DST		as "Zamówienie dostawcy"
	,TO_STRING(ZD_NAG.DATA)	as "Data zamówienia"
	,TO_STRING(ZD_NAG.DTPREAL)	as "Data planowana"
	,USERS.KOD			as "Operator"
	,ZD_NAG.STAN		as "Kod_stanu"
	,TO_STRING(ZD_NAG.R)		as "Rok"
	,TO_STRING(ZD_NAG.M)		as "Miesiąc"
	,TO_STRING(ZD_NAG.K)		as "Kwartał"
	,MG.SYM			as "Magazyn"
	,COUNT(ZD_POZ.ZD_NAG) 	as "Ile_pozycji"
	,KH.KOD			as "Dostawca_kod"
	,KH.NAZ			as "Dostawca"
	,waluta.KOD			as "Waluta"
	,SUM(ZD_POZ.WAR)		as "Wartość_PLN"
	,SUM(ZD_POZ.IL*ZD_POZ.CWAL)	as "Wartość_wal"
	,CASE
	     WHEN ZD_NAG.STAN='-'	THEN 'Archiwalne'
	     WHEN ZD_NAG.STAN='N'	THEN 'Nowe'
	     WHEN ZD_NAG.STAN='A'	THEN 'Do realizacji'
	     WHEN ZD_NAG.STAN='O'	THEN 'Bez akceptacji zapotrzebowania'
	     WHEN ZD_NAG.STAN='C'	THEN 'Częściowo zrealizowane'
	     WHEN ZD_NAG.STAN='M'	THEN 'Zamknięte'
	     WHEN ZD_NAG.STAN='Q'	THEN 'Odrzucone zapotrzebowanie'
	     WHEN ZD_NAG.STAN='Z'	THEN 'Zrealizowane'
	     ELSE			     ''
	 END			as "Status"
from
	 @ZD_NAG
	left outer join @ZD_POZ using(ZD_POZ.ZD_NAG, ZD_NAG.reference)
	left outer join MG using(ZD_NAG.MG, MG.reference)
	left outer join SLO waluta using(ZD_NAG.WAL, waluta.reference)
	left outer join KH using(ZD_NAG.KH, KH.reference)
	left outer join USERS using(ZD_NAG.US, USERS.reference)
where
	(ZD_NAG.DATA BETWEEN TO_DATE(:_a) AND TO_DATE(:_b))	/*data zamowienia od do*/
	AND	:_c				/*kontrahent dostawca*/

group by
	 ZD_NAG.SYM
	,ZD_NAG.ZAM_DST
	,ZD_NAG.DATA
	,ZD_NAG.DTPREAL
	,USERS.KOD
	,ZD_NAG.STAN
	,ZD_NAG.R
	,ZD_NAG.M
	,ZD_NAG.K
	,MG.SYM
	,KH.KOD
	,KH.NAZ
	,waluta.KOD
	
