:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: qnuco.prc [22.26]
# Utworzony: 31.01.2024
# Autor: [tp]
# Systemy: Merit-LMG
#=======================================================================================================================
# Zawartosc: Procedury dla potrzeb klienta NUCO
#=======================================================================================================================


proc dostawy

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [tp] [22.26]
:: OPIS: zwraca listę dostaw wraz z dodatkowymi informacjami potrzebnymi do wiekowania zapasów
::
::----------------------------------------------------------------------------------------------------------------------
end desc

params

end params

formula

end formula


sql

select distinct
       DK.PRDK            as PRDK,
       space(16)          as REF_ZD,
       space(16)          as REF_ND,
       space(16)          as REF_KH,
       space(40)          as P_SYM,
       to_date('2000/1/1') as P_D,
       space(50)           as SYM_ZD,
       to_date('2000/1/1') as DT_ZD,
       space(50)           as SYM_RWZL,
       to_date('2000/1/1') as DT_RWZL
from @DK
where DK.PLUS='T'
order by 1

end sql

formula

'Uzupełnienie danych o symbolu zamówienia, dacie RWZL i symbolu RWZL';

_dk:=sql('select DK.REFERENCE as REF_DK,
                 ND.REFERENCE as REF_ND,
                 ND.SYM as P_SYM,
                 DK.DOST as P_D,
                 ND.SYM as P_SYM,
                 ND.KH,
                 DK.ZAM_RP
          from @DK join @ND
          where DK.PLUS=\'T\'
          ');
_dk.index(_dk.ndx_tmp(,,'REF_DK',,));

_rwzl:=sql('select DK.PRDK,
                   ND.D,
                   ND.SYM
                  from @DK
                        join @ND
                        join TYPYDOK
                  where TYPYDOK.T=\'RWZL\'
                  order by 1,2
                  ');
_rwzl.index(_rwzl.ndx_tmp(,,'PRDK',,));

_zd:=sql('select ZD_RP.REFERENCE as REF_ZD,
                        ZD_NAG.DATA,
                        ZD_NAG.SYM
                  from @ZD_RP
                        join @ZD_RN
                        join @ZD_NAG
                  order by 1
                  ');
_zd.index(_zd.ndx_tmp(,,'REF_ZD',,));

{? :RS.first()
|| {!
   |? _temp:=sql('select :_a.REF_ND,
                         :_a.P_SYM,
                         :_a.P_D,
                         :_a.KH,
                         :_a.ZAM_RP
                     from :_a
                     where :_a.REF_DK=\':_b\'
                     ',_dk ,:RS.PRDK);
      {? _temp.first()
      || :RS.REF_ND:=_temp.REF_ND;
         :RS.P_SYM:=_temp.P_SYM;
         :RS.P_D:=_temp.P_D;
         :RS.REF_ZD:=_temp.ZAM_RP;
         :RS.REF_KH:=_temp.KH;
         :RS.put()
      ?};
      &_temp;

      {? :RS.P_D>date(2021,7,31)
      || {? :RS.REF_ZD<>''
         || _temp:=sql('select :_a.DATA,
                            :_a.SYM
                     from :_a
                     where :_a.REF_ZD=\':_b\'
                     ',_zd ,:RS.REF_ZD);
            {? _temp.first()
            || :RS.SYM_ZD:=_temp.SYM;
               :RS.DT_ZD:=_temp.DATA;
                :RS.put()
            ?};
            &_temp
         ?};
         _temp:=sql('select :_a.D,
                            :_a.SYM
                       from :_a
                      where :_a.PRDK=\':_b\'
                    order by 1
                  ', _rwzl, :RS.PRDK);
         {? _temp.first()
         || :RS.SYM_RWZL:=_temp.SYM;
            :RS.DT_RWZL:=_temp.D;
            :RS.put()
         ?};
         &_temp
      ?};

     :RS.next()
   !}
?}

end formula

end proc
