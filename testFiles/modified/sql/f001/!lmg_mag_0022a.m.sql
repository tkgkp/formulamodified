:!UTF-8
select
 0 as LP,
      ZL.SYM zlecenie,
      ZL.OD,
      ZL.DO,
      ZL.DTR,
      to_string(ZL.IL) il_plan,
      to_string(ZL.ILWYK) il_wykonana,
      TYPYDOK.T typ_dok,
      ND.NR nr,
      ND.SYM as dokument,
      ND.D data_dok,
      M.KTM as KTM,
      case 
        when TYPYDOK.T='RP' then DK.WAR 
        else 0
      end WAR_RP,
      case 
        when TYPYDOK.T<>'RP' 
        then case when DK.PLUS='T' then -DK.WAR
                       else DK.WAR
                       end
        else 0
      end WAR_RW,
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
  and  ND.D<=to_date(:_c)
order by 2

