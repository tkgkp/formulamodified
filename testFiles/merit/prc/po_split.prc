:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzeżone
#=======================================================================================================================
# Nazwa pliku: po_split.prc [12.46]
# Utworzony: 15.05.2015
# Autor: WH
#=======================================================================================================================
# Zawartość: Procedury do obsługi dzielenia i scalania pozycji planu operacyjnego
#=======================================================================================================================

proc can_split

desc
   Sprawdza czy daną pozycję planu można podzielić
end desc

params
   PL_OZ:='' String[16], Ref sql pozycji planu którą sprawdzić
end params

sql
   select
/*1*/   0 as RESULT
   from SYSLOG
   where 1=0
end sql

formula
   _can_continue:=0;
   PL_OZ.cntx_psh();
   PL_OZ.clear();
   {? PL_OZ.seek(:PL_OZ)
   || {? ~exec('splittable','po_split',PL_OZ.PL_OPER)
      || PL_OZ.PL_OPER();
         KOMM.add(
            'Operacja \'%1 — %2\' ma stałą normę czasową — nie może być podzielona.'@
            [PL_OPER.SYMBOL,PL_OPER.OPIS],2,,1
         )
      || _can_continue:=1
      ?}
   || KOMM.add('Nie znaleziono pozycji planu: '+:PL_OZ,2,,1)
   ?};
   PL_OZ.cntx_pop();
   :RS.RESULT:=_can_continue;
   :RS.add();
   ~~
end formula

end proc


proc can_merge

desc
   Sprawdza czy daną pozycję planu można scalić
end desc

params
   PL_OZ:='' String[16], Ref sql pozycji planu którą sprawdzić
end params

sql
   select
/*1*/   0 as RESULT
   from SYSLOG
   where 1=0
end sql

formula
   _can_continue:=1;
   ZLIM.cntx_psh();
   ZGP.cntx_psh();
   ZGH.cntx_psh();
   PL_WYK.cntx_psh();
   PL_WYK.index('PL_OPER');
   PL_OPER.cntx_psh();
   PL_OZ.cntx_psh();
   PL_OZ.clear();
   {? PL_OZ.seek(:PL_OZ)
   || PL_OZ.PL_OPER();
      {? PL_OPER.PL_SPLIT<>null()
      ||
         _tab:=exec('merge_list','po_split',PL_OPER.PL_SPLIT);
         _tab.clear();
         {? _tab.last()
         || {!
            |? _ploper:=exec('FindAndGet','#table',PL_OPER,_tab.PL_OPER,,,null());
               PL_OPER.clear();
               {? PL_OPER.seek(_ploper)
               ||
                  {? PL_OPER.UID_SRC<>''
                  ||
#                    Badam czy operacja źródłowa znajduje się na liście operacji które są scalane,
#                    jeśli tak to badam czy operacja scalana ma jakieś wykonania
                     _tab.cntx_psh();
                     _tab.prefix(PL_OPER.UID_SRC);
                     {? _tab.first()
                     ||
                        _what:=PL_OPER.SYMBOL+' '+PL_OPER.OPIS;
                        PL_WYK.prefix(PL_OPER.ref());
                        {? PL_WYK.size()>0
                        || _can_continue:=0;
                            KOMM.add('Operacja : '+_what+' posiada wykonania, jej scalenie z inną operacją niedozwolone.',2,,1)
                        ?};
#                       Badam czy limity do pozycji przewodnika mają jakieś pobrania
                        {? PL_OPER.ZGP<>null()
                        || exec('openmask','zl_common',PL_OPER.ZGP().NRZLP().ZLEC);
                           ZLIM.index('ZGP_NM');
                           ZLIM.prefix(PL_OPER.ZGP);
                           {? ZLIM.first()
                           || {!
                              |? {? ZLIM.KOR=0
                                 || _il_dk:=exec('ilosc_dk','zl_limit',ZLIM.ref());
                                    {? _il_dk>0
                                    || _can_continue:=0;
                                       _msg:='';
                                       {? ZLIM.LIMIT='T'
                                       || _msg:='Limit: '+ZLIM.KTM().KTM+' posiada już pobrania, scalenie operacji niedozwolone.'
                                       || _msg:='Surowiec nielimitowany: '+ZLIM.KTM().KTM+' posiada już pobrania, scalenie operacji niedozwolone.'
                                       ?};
                                       KOMM.add(_msg,2,,1)
                                    ?}
                                 ?};
                                 ZLIM.next()
                              !}
                           ?}
                        ?}
                     ?};
                     _tab.cntx_pop()
                  ?}
               ?};
               _tab.prev()
            !}
         ?};
         {? _can_continue>0
         ||
            exec('openmask','zl_common',PL_OPER.PL_SPLIT().PL_PART().ZL);
            _tab_zlim:=exec('merge_list_zlim','po_split',PL_OPER.PL_SPLIT);
            _tab_zlim.clear();
            {? _tab_zlim.first()
            || {!
               |? ZLIM.clear();
                  {? ZLIM.seek(_tab_zlim.ZLIM)
                  ||
                     {? ZLIM.KOR=0
                     ||
                        _il_dk:=exec('ilosc_dk','zl_limit',ZLIM.ref());
                        {? _il_dk>0
                        || _can_continue:=0;
                           _msg:='';
                           {? ZLIM.LIMIT='T'
                           || _msg:='Limit: '+ZLIM.KTM().KTM+' posiada już pobrania, scalenie operacji niedozwolone.'
                           || _msg:='Surowiec nielimitowany: '+ZLIM.KTM().KTM+' posiada już pobrania, scalenie operacji niedozwolone.'
                           ?};
                           KOMM.add(_msg,2,,1)
                        ?}
                     ?}
                  ?};
                  _tab_zlim.next()
               !}
            ?}
         ?}
      || _can_continue:=0;
         KOMM.add('Operacja : '+PL_OPER.SYMBOL+' '+PL_OPER.OPIS+' nie należy do żadnego podziału.',2,,1)
      ?};
      :RS.RESULT:=_can_continue;
      :RS.add()
   || KOMM.add('Nie znaleziono pozycji planu: '+:PL_OZ,2,,1)
   ?};
   PL_OZ.cntx_pop();
   PL_OPER.cntx_pop();
   PL_WYK.cntx_pop();
   ZLIM.cntx_pop();
   ZGP.cntx_pop();
   ZGH.cntx_pop();
   ~~
end formula

end proc


proc split

desc
   Dzieli podaną pozycję planu, lub tworzy nową ścieżkę od podanej pozycji planu
end desc

params
   PL_OZ:=''            String[16], Ref sql pozycji planu od której zacząć dzielenie
   IL_OLD:=0            REAL, Ilość jaką pozostawić na starym kawałku
   IL_NEW:=0            REAL, Ilość jaką tworzyć na nowych kawałkach
   DUR_OLD:=0           REAL, Czas w milisekundach jaki pozostawić na starym kawałku
   DUR_NEW:=0           REAL, Czas w milisekundach jaki tworzyć na nowych kawałkach
   MODE:=''             String[6], Tryb dzielenia: SINGLE - dzieli tylko podaną pozycję planu, PATH - tworzy nową ścieżkę
   DIR:=0               INTEGER, Kierunek dzielenia w przypadku tworzenia nowej ścieżki
   COLOROLD:=''         String[11], Kolor starej pozycji planu
   COLORNEW:=''         String[11], Kolor nowych pozycji planu
end params

sql
   select
/*1*/   '1234567890123456' as REF
   from SYSLOG
   where 1=0
end sql

formula
   PL_OZ.cntx_psh();
   PL_OZ.clear();
   PL_PART.cntx_psh();
   ZL.cntx_psh();
   {? PL_OZ.seek(:PL_OZ)
   ||
      _dur_old:=:DUR_OLD/1000/60;
      _dur_new:=:DUR_NEW/1000/60;

      _args:=exec('split_a','po_split');
      _args.PL_OPER:=PL_OZ.PL_OPER;
      _args.IL_OLD:=:IL_OLD;
      _args.IL_NEW:=:IL_NEW;
      _args.DUR_OLD:=_dur_old;
      _args.DUR_NEW:=_dur_new;
      _args.MODE:=:MODE;
      _args.DIR:=:DIR;
      _args.COLOROLD:=:COLOROLD;
      _args.COLORNEW:=:COLORNEW;

      {? PL_OZ.PL_OPER().ZGP<>null()
      || _args.ZL:=PL_OPER.ZGP().ZL
      || _args.ZL:=PL_OPER.PL_PART().ZL
      ?};

      :RS.blank();
      :RS.REF:=$exec('split','po_split',_args);
      :RS.add()
   || KOMM.add('Nie znaleziono pozycji planu: '+:PL_OZ)
   ?};
   PL_OZ.cntx_pop();
   PL_PART.cntx_pop();
   ZL.cntx_pop();
   ~~
end formula

end proc


proc merge

desc
   Scala podany podział
end desc

params
   PL_SPLIT:=''         String[16], Ref sql danego podziału
end params

sql
   select
/*1*/   0 as RESULT,
/*2*/   '1234567890123456' as PLOZ,
/*3*/   '1234567890123456' as PLPART
   from SYSLOG
   where 1=0
end sql

formula
   PL_OZ.cntx_psh(); PL_OZ.clear();
   PL_OPER.cntx_psh();
   PL_SPLIT.cntx_psh();
   PL_SPLIT.clear();
   {? PL_SPLIT.seek(:PL_SPLIT)
   ||
      _tab:=exec('merge','po_split',PL_SPLIT.ref());
      _tab.tab.clear();
      {? _tab.tab.first()
      || {!
         |?
            :RS.blank();
            :RS.PLOZ:=_tab.tab.SQL;
            {? :RS.PLOZ<>''
            || {? PL_OZ.seek(:RS.PLOZ)
               || :RS.PLPART:=$PL_OZ.PL_OPER().PL_PART
               ?}
            ?};
            :RS.add();
            _tab.tab.next()
         !}
      ?}
   || KOMM.add('Nie znaleziono podziału: '+:PL_SPLIT)
   ?};
   PL_OPER.cntx_pop();
   PL_SPLIT.cntx_pop();
   PL_OZ.cntx_pop();
   ~~
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 8c7e0d2284190cf74b0432fc17115f471948a48ea70f0694283339651732f25771cd44eadf41f8aaaa63caab92322d40a07164cc7075c0307853196b77496f37d32ebd1ecc3420f22326e2f19d6f9f9780e535d0875aabbbd3bb5562f75118b3325b467cea296c925373876553d82afa10e0e9b49d4f9457115458148d5be636
