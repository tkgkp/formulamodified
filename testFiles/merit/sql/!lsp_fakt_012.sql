:!UTF-8
select
   0 as LP,
   FAKS.DW DokDataWyst,
   FAKS.SYM as DokSymbol,
   FAKS.DW as ParDataWyst,
   FAKS.SYM as ParSym,
   FAKS.NETTO as Netto,
   FAKS.VAT as Vat,
   FAKS.BRUTTO as Brutto
from
   @FAKS
   join TYPYSP using (FAKS.T, TYPYSP.REFERENCE)
where
   FAKS.ODDZ=':_a'
   and ((FAKS.DW between to_date(:_b) and to_date(:_c)) or (to_date(:_b) is null and to_date(:_c) is null))
   and FAKS.SZ='S'
   and FAKS.SYMF<>''
   and TYPYSP.PAR<>'T'
   and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
   and :_d
order by
   2,3

