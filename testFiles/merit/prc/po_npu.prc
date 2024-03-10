:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzeżone
#=======================================================================================================================
# Nazwa pliku: po_zlim.prc [12.46]
# Utworzony: 11.06.2015
# Autor: WH
#=======================================================================================================================
# Zawartość: Procedury do obsługi NPU
#=======================================================================================================================

proc get_zgp_npus

desc
   Zwraca NPU należące do pozycji przewodnika
end desc

params
   ZGP:='' STRING[16], Ref SQL pozycji przewodnika
   TOPER:='' STRING[16], Ref SQL pozycji przewodnika
end params

sql
   select
      '1234567890123456' as REF,
      '                                                   ' as KTM,
      '                                                                                          ' as KTM_NAZ,
      '                                                   ' as GRUPA,
      '                       ' as KIND,
      cast (0 as REAL_TYPE) as ILOSC,
      '          ' as JM,
      cast (0 as REAL_TYPE) as ZXJM,
      cast (0 as REAL_TYPE) as ZH
   from SYSLOG
   where 0=1
   order by GRUPA,KTM
end sql

formula
   _ndx_old:=:RS.index('?');
   _ndx:=:RS.ndx_tmp(,,'REF',,);

   :RS.index(_ndx);
   TACTTLS.cntx_psh();

   TOPER.cntx_psh();
   TOPER.prefix();
   ZGP.cntx_psh();
   ZGP.clear();

   _tktl:=null();
   _toper:=null();
   {? :ZGP<>''
   ||
      {? ZGP.seek(:ZGP)
      ||
         exec('openmask','zl_common',ZGP.ZL);
         TACTTLS.index('AKNROP');

         _tktl:=ZGP.ZL().TKTL;
         {? _tktl=null()
         || _tktl:=ZGP.ZL().KTL
         ?};
         _toper:=ZGP.TOPER
      ?}
   |? :TOPER<>''
   || {? TOPER.seek(:TOPER)
      || _tktl:=TOPER.NRK;
         _toper:=TOPER.ref()
      ?}
   ?};
   {? _tktl<>null & _toper<>null()
   ||
      TACTTLS.index('AKNROP');
      TACTTLS.prefix('T',_tktl,_toper);
      {? TACTTLS.first()
      || {!
         |? :RS.blank();
            exec('npu2rs','po_plan',:RS);
            :RS.add();
            TACTTLS.next()
         !}
      ?};
      TACTTLS.prefix('T',_tktl,null());
      {? TACTTLS.first()
      || {!
         |? :RS.blank();
            exec('npu2rs','po_plan',:RS);
            :RS.add();
            TACTTLS.next()
         !}
      ?}
   ?};
   ZGP.cntx_pop();
   TOPER.cntx_pop();
   TACTTLS.cntx_pop();
   :RS.index(_ndx_old)
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 043aec9dcd0c36888c8fafd670197248291cb7926e1eac90a452d92060f434a5ed51440a4dbdcde434d8996788f4e57f6dfa3ecd391800322b8709f20f305116a3d3f0a480746a8c6fb6a4c610f175093d20774ae5031b28ad5201d5a2d4dc9f0eb3afd9cc1573f8c68541276a0bb965779b861d9c6d19a488b205f4a02a7ce9
