:!UTF-8
select 0 as LP,
         ZD_NAG.STAN "STAN",
         ZD_NAG.SYM as "ZAMÓWIENIE" ,
	 ZD_NAG.DATA as "DATA ZAMÓWIENIA", 
         KH.KOD as KOD , 
         KH.NAZ as KONTRAHENT , 
         ZD_POZ.POZ as LINIA ,
         M.KTM as KTM , M.N as PRODUKT , 
        ZD_POZ.IL "ILOŚĆ ZAM." , 
        ZD_POZ.IL_POZ as "ILOŚĆ POZOST." ,
        ZD_POZ.CENA as CENA , 
        ZD_POZ.WAR as WARTOŚĆ , 
        ZD_POZ.CWAL as CENA_WAL,
        ZD_POZ.CWAL*ZD_POZ.IL WART_WAL,
        SLO.KOD as WAL , 
        USERS.DANE as DANE
from @ZD_POZ
   left join @ZD_NAG using (ZD_POZ.ZD_NAG,ZD_NAG.REFERENCE)
   left join KH using (ZD_NAG.KH,KH.REFERENCE)
   left join M using (ZD_POZ.M,M.REFERENCE)
   left join SLO using (ZD_POZ.WAL,SLO.REFERENCE)
   left join USERS using (ZD_NAG.US,USERS.REFERENCE)
where ( ZD_NAG.STAN like '%:_b%' ) and ( M.KTM like '%:_a%' or ':_a'='')
order by 7,4
