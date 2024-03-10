:!UTF-8
select
 0 as LP,
 OFE.SYM as "Symbol oferty",
 OFE.DU as "Data utworzenia",
 KH.NAZ as "Kontrahent",
 ZK_N.SYM as "Symbol zamówienia",
 OFE.NET as "Wartość netto oferty",
 case
  when OFE.A='A' then 'Aktywna'
  else 'W archiwum'
 end as "Status oferty"
 
from
 @ZK_N
 join OFE using (ZK_N.OFE,OFE.reference)
 left join KH using (OFE.KH,KH.reference)
 
where
 ((OFE.DU between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null)) and
 (substr(':_c',1,1)=OFE.A or substr(':_c',1,1)='W')
 
order by "Data utworzenia","Kontrahent","Symbol zamówienia"

