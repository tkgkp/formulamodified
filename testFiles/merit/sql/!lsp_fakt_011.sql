:!UTF-8
select 
	0 as LP,
	FAKS.USER as Operator,
	FAKS.DW DokDataWyst,
	FAKS.SYM as DokSymbol,
	FAKS.NETTO as Netto,
	FAKS.VAT as Vat,
	FAKS.BRUTTO as Brutto
from  
	@FAKS
where 
	FAKS.ODDZ=':_a' 
	and ((FAKS.DW between to_date(:_b) and to_date(:_c)) or (to_date(:_b) is null and to_date(:_c) is null))
	and FAKS.SZ='S'
	and FAKS.KZ='' and FAKS.ZEST_AKC='N' and FAKS.STAT_REJ<>'A'
	and :_d
order by
	 2,3

