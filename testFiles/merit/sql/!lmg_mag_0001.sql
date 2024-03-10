:!UTF-8
select 
 0 as LP,
      ZL.SYM ZlecSymbol,
      TYPYDOK.T DokTyp,
      ND.NR DokNr,
      ND.SYM DokSymbol,
      ND.D DokData,
      sum(DK.WAR) WarMag,
      ND.Z DokAkc

from @DK
      join @ND using (DK.N,ND.REFERENCE)
      join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join ZL using (DK.ZL, ZL.REFERENCE)

where MG.SYM = ':_b'
  and (upper(ZL.SYM) like upper(':_a') or ':_a'='')
  and (ND.D>= to_date(:_c) or to_date(:_c) is null)
  and (ND.D<= to_date(:_d) or to_date(:_d) is null)
group by
      ZL.SYM,TYPYDOK.T,ND.NR,ND.SYM,ND.D,ND.Z
order by 2

