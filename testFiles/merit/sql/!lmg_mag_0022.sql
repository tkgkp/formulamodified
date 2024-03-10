:!UTF-8
select
 0 as LP,
      ZL.SYM zlecenie,
      TYPYDOK.T typ_dok,
      ND.NR nr,
      ND.SYM as dokument,
      ND.D data_dok,
      M.KTM as KTM,
      DK.WAR wartosc,
      DK.IL ilosc,
      JM.KOD jm,
      case
        when J2.KOD<>'' then DK.IL
        else 0
      end ilosc2,
      J2.KOD jm2
from @DK
      join @ND
      join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
      join MG using (ND.MAG,MG.REFERENCE)
      join ZL using (DK.ZL,ZL.REFERENCE)
      join M using(DK.M,M.REFERENCE)
      join JM using(M.J,JM.REFERENCE)
      left join JM J2 using(M.J2,J2.REFERENCE)

where MG.SYM = ':_b'
  and (upper(ZL.SYM) like upper(':_a%') or ':_a'='')

order by 2

