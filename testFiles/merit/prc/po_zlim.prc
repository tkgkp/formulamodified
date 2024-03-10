:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzeżone
#=======================================================================================================================
# Nazwa pliku: po_zlim.prc [12.46]
# Utworzony: 11.06.2015
# Autor: WH
#=======================================================================================================================
# Zawartość: Procedury do obsługi limitów surowcowych zleceń
#=======================================================================================================================

proc get_spli_zlims

desc
   Zwraca limity które zostaną usunięte w wyniku scalenia podziału
end desc

params
   PL_SPLIT:='' STRING[16], Ref SQL podziału
end params

sql
   select
      '1234567890123456' as REF,
      ' ' as LIM,
      '                                                   ' as KTM,
      '                                                                                          ' as KTM_NAZ,
      cast (0 as REAL_TYPE) as ILOSC,
      '          ' as JM,
      0 as NR,
      '                                                    ' as ZGH,
      '                                                    ' as OPER,
      ' ' as KOR,
      '                                                                                                         ' as UWAGI,
      cast (0 as REAL_TYPE) as SR,
      cast (0 as REAL_TYPE) as SRC,
      cast (0 as REAL_TYPE) as SD
   from SYSLOG
   where 0=1
   order by ZGH,OPER,NR,KTM,LIM DESC
end sql

formula
   _ndx_old:=:RS.index('?');
   _ndx:=:RS.ndx_tmp(,,'REF',,);

   :RS.index(_ndx);
   ZLIM.cntx_psh();
   PL_SPLIT.cntx_psh();
   PL_OPER.cntx_psh();
   PL_OPER.index('PL_SPLIT');
   PL_SPLIT.clear();
   PL_OPER.clear();
   {? PL_SPLIT.seek(:PL_SPLIT)
   || exec('openmask','zl_common',PL_SPLIT.PL_PART().ZL);

#     Dodaje limity powiązane z PL_SPLITEM
      ZLIM.index('PL_SPLIT');
      ZLIM.prefix(PL_SPLIT.ref());
      {? ZLIM.first()
      || {!
         |? :RS.blank();
            exec('zlim2rs','po_plan',:RS);

            {? exec('korekta_after','zl_limit')>0
            || :RS.UWAGI:='Istnieją korekty limitów wykonane po podziale planu!'
            ?};
            :RS.add();
            ZLIM.next()
         !}
      ?};


#     Dodaje wszystkie limity z operacji które zostaną usunięte
      ZLIM.index('ZGP_NM');
      _tab:=exec('merge_list','po_split');
      _tab.clear();
      {? _tab.first()
      || {!
         |? {? PL_OPER.seek(_tab.PL_OPER)
            || {? PL_OPER.ZGP<>null() & PL_OPER.UID_SRC<>''
               || ZLIM.prefix(PL_OPER.ZGP);
                  {? ZLIM.first()
                  || {!
                     |?
                        {? ZLIM.PL_SPLIT<>null()
                        ||

#                          Jeśli limit nie miał żadnego podziału to nie zostanie usunięty,
#                          tylko zostanie przesunięty
                           :RS.prefix($ZLIM.ref());
                           {? :RS.size()=0
                           ||
                              :RS.blank();

                              exec('zlim2rs','po_plan',:RS);

                              {? exec('korekta_after','zl_limit')>0
                              || :RS.UWAGI:='Istnieją korekty limitów wykonane po podziale planu!'
                              ?};
                              :RS.add()
                           ?};
                           ZLIM.next()
                        ?}
                     !}
                  ?}
               ?}
            ?};
            _tab.next()
         !}
      ?};
      ZLIM.clear()
   ?};
   PL_OPER.cntx_pop();
   PL_SPLIT.cntx_pop();
   ZLIM.cntx_pop();
   :RS.index(_ndx_old)
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_zgp_zlims

desc
   Zwraca limity należące do pozycji przewodnika
end desc

params
   ZGP:='' STRING[16], Ref SQL pozycji przewodnika
end params

sql
   select
      '1234567890123456' as REF,
      ' ' as LIM,
      '                                                   ' as KTM,
      '                                                                                          ' as KTM_NAZ,
      cast (0 as REAL_TYPE) as ILOSC,
      '          ' as JM,
      0 as NR,
      '                                                    ' as ZGH,
      '                                                    ' as OPER,
      ' ' as KOR,
      '                                                                                                         ' as UWAGI,
      cast (0 as REAL_TYPE) as SR,
      cast (0 as REAL_TYPE) as SRC,
      cast (0 as REAL_TYPE) as SD
   from SYSLOG
   where 0=1
   order by ZGH,LIM DESC,OPER,NR,KTM
end sql

formula
   _ndx_old:=:RS.index('?');
   _ndx:=:RS.ndx_tmp(,,'REF',,);

   :RS.index(_ndx);
   ZLIM.cntx_psh();
   ZGP.cntx_psh();
   ZGP.clear();
   {? ZGP.seek(:ZGP)
   ||
      exec('openmask','zl_common',ZGP.ZL);
      ZLIM.index('ZGP_KM');
#     Limity
      ZLIM.prefix(ZGP.ref(),'T',0);
      {? ZLIM.first()
      || {!
         |? :RS.blank();
            exec('zlim2rs','po_plan',:RS);
            :RS.add();
            ZLIM.next()
         !}
      ?};

#     Nielimity
      ZLIM.prefix(ZGP.ref(),'N');
      {? ZLIM.first()
      || {!
         |? :RS.blank();
            exec('zlim2rs','po_plan',:RS);
            :RS.add();
            ZLIM.next()
         !}
      ?}
   ?};
   ZGP.cntx_pop();
   ZLIM.cntx_pop();
   :RS.index(_ndx_old)
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 10cfa1e7c6acdbe7f0201d5df2b74e746db9ef74c1899547b7c37d81fcce2dd7992dd2655d53f7f93dfb7267ae0f42320b7d1467abf42057ce79ed5677864a89594bf5477d2935686335837e526fa414112be309fa9f70880d5f7065c39e0dc5a1fb70cd5d2c665e6ddce55a925e3b552b8ac4e4bda6284ac152e325484f8eac
