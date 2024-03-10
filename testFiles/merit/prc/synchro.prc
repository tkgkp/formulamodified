:!UTF-8
proc sync_sql

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: Mario [12.10]
:: OPIS: przygotowywanie danych na podstawie tabeli SYNC - zostana zwrocone dane zwiazane z zalogowana firma
::       oraz rekordy bez wypelnionej firmy
::       {call sync@synchro('MOBIL','KH')}
::   WE: [_a] - przeznaczenie danych np. OLAP, MOBIL, LOTUS
::       [_b] - jakiej tabeli dotycza dane, jezeli chcemy dla konkretnej tabeli
::       [_c] - ilosc rekordow w wyniku, podajemy jezeli chcemy okreslic max liczbe wierszy w wyniku, 0 - zwroci
::              wszyskie rekordy
::       [_d] - gdy maja zostac zwrocone rekordy dla firmy (podajmy kod firmy), gdy maja byc zwrocone dane z wszystkich
::              firm (podajemy kod 'ALL'), gdy nie podamy parametru zostanie ustawiona firma wg wykorzystywanego
::              polaczenia ODBC
::       [_e] - Numer replikacji danych, parametr jest sprawdzany czy dla przeznaczenia danych istnieje replika
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   pd:='MOBIL'  String[20],Przeznaczenie danych
   tab:='' String[8], Akronim tabeli
   il_rec:=0 Integer, Ilosc rekordow w wyniku
   fir:='' String[3], Kod firmy
   repl:=0 Integer, Numer replikacji
   replik:='' String[20], pomocnicza
end params

formula
{? :fir=''
|| :fir:=__Firma
?};
{? :repl<>0
|| SYNC_REP.index('PDNR');
   SYNC_REP.prefix(exec('FindInSet','#table','SYNC_PD','SYM',:pd,:pd),:repl);
   {? SYNC_REP.first()
   || :replik:=$SYNC_REP.ref()
   || :replik:='x'
   ?}
|| :replik:=''
?}
end formula

sql
   select
      SPACE(255) TR1,
      SPACE(255) TR2,
      SPACE(255) TR3,
      SPACE(255) TR4,
      SPACE(255) TR5,
      SPACE(255) TR6,
      SPACE(255) TR7,
      SPACE(255) TR8,
      SPACE(255) TR9,
      SPACE(255) TR10,
      TR,
      ID, REF, ACR, RODZ, FIRMA, LP, STATUS, R_IDADD
   from
      SYNC
      join SYNC_PD
   where
      SYNC.WGIDPUT<>'T'
      and SYNC_PD.SYM=:pd
      and (SYNC.ACR =:tab or :tab='')
      and (SYNC.FIRMA=:fir or SYNC.FIRMA='' or :fir='ALL')
      and (SYNC.SYNC_REP=:replik or :replik='')
   order by ID
end sql

formula
   _my_lp:=0;
   :RS.clear();
   {? :RS.first()
   ||
      {!
      |?
         {? :RS.LP>1
         ||
            _wyn:={? :RS.del(,1)=3 || 0 || 1 ?}

         |? {? :il_rec>0 || _my_lp=:il_rec || 0 ?}
         ||
            _wyn:={? :RS.del(,1)=3 || 0 || 1 ?}
         ||
            {? :RS.FIRMA='' || SYNC.use('synd___') || SYNC.use('synd'+:RS.FIRMA) ?};
            SYNC.index('ID');
            SYNC.prefix(:RS.ID);
            {? SYNC.first()
            ||
               :RS.TR:='';
               _ii:=0;
               {!
               |?
                  _ii+=1;
                  :RS[_ii]:=SYNC.TR;
                  :RS.TR+=SYNC.TR;
                  _ii<=10 & SYNC.next()
               !}
            ?};
            _my_lp+=1;
            :RS.put;
            _wyn:=:RS.next()
         ?};
         _wyn
      !}
   ?}
end formula

end proc


proc sync_del

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: Mario [12.10]
:: OPIS: usuwa zapisy z tabeli synchronizacji spełniający warunek SYNC.ID=:id
::       i zapisy wcześniejsze dotyczące rekordu wskazanego w SYNC.REF
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   id String[20], Identyfikator
   pd String[20], Przeznaczenie danych
end params

sql
   select ' ' as wyn from FIRMA where 1=0
end sql

formula
   _sync_pd:=exec('FindInSet','#table','SYNC_PD','SYM',:pd,:pd);
   _maski:=SYNC.names();
   _stamp:=$SYNC.tm_stamp();
   {? _maski.first & +_stamp=+:id
   ||
      {!
      |?
         SYNC.use(_maski.NAME);
         SYNC.index('ID');
         SYNC.prefix(:id);
         {? SYNC.first()
         ||
            {? SYNC.WGIDPUT<>'T'
            ||
               _ref:=SYNC.REF;
               {!
               |?
# usuwa zapisy spełniające warunek SYNC.ID=:id
                  SYNC.del()
               !};
               {? _ref<>''
               ||
                  SYNC.index('REF');
                  SYNC.prefix(_ref);
                  {? SYNC.first()
                  ||
                     {!
                     |?
                        {? SYNC.ID<:id & SYNC.SYNC_PD=_sync_pd
                        ||
# usuwa wcześniejsze zapisy dotyczące rekordu podanego w SYNC.REF
                           _next:=SYNC.del()
                        ||
                           _next:=SYNC.next()
                        ?};
                        _next
                     !}
                  ?}
               ?}
            ?}
         ?};
         _maski.next
      !}
   ?}
end formula

end proc


proc sync_id_del

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: Mario [17.00]
:: OPIS: usuwa zapis z tabeli synchronizacji, usuwa ID i wszystkie poprzednie wystapienia
::   WE:  _a  - identyfikator rekordu
::        _b  - przeznaczenie danych np. OLAP, MOBIL, LOTUS
::        _c  - Numer repliki danych, parametr jest sprawdzany czy dla przeznaczenia danych istnieje replika
::       [_d] - Czy pokazywać wszystkie usunięte rekordy (1), czy tylko ich liczbę (0 - domyślnie)
::       [_e] - Akronim tabeli
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   id String[20],Identyfikator
   pd:='MOBIL' String[20],Przeznaczenie danych
   repl:=0 Integer, Numer repliki
   show:=0 Integer, Pokazywać wszystkie usunięte rekordy
   acr:='' STRING, Akronim tabeli
end params

sql
   select SPACE(45) as MESSAGE, SPACE(16) as ID from FIRMA where 1=0
end sql

formula
   _sync_pd:=exec('FindInSet','#table','SYNC_PD','SYM',:pd,:pd);
   _czyrepl:=~:repl | exec('FindInSet','#table','SYNC_REP','PDNR',:repl,_sync_pd)<>null();
   _stamp:=$SYNC.tm_stamp();
   _maski:=SYNC.names();
   _size:=0;
   {? _czyrepl & _maski.first() & +$_stamp=+:id
   ||
      {!
      |?
         SYNC.use(_maski.NAME);
         {? :repl=0 & :acr=''
         || SYNC.index('PDSYMNR');
            SYNC.prefix(:pd,)
         |? :repl<>0 & :acr=''
         || SYNC.index('PDSYMNR');
            SYNC.prefix(:pd,:repl)
         |? :repl=0 & :acr<>''
         || SYNC.index('PDSYMANR');
            SYNC.prefix(:pd,:acr,)
         || SYNC.index('PDSYMANR');
            SYNC.prefix(:pd,:acr,:repl)
         ?};
         {? SYNC.first()
         ||
            {!
            |?
               {? SYNC.ID<=:id & SYNC.WGIDPUT<>'T'
               ||
                  {? :show
                  ||
                     :RS.MESSAGE:='Usunięto';
                     :RS.ID:=SYNC.ID;
                     :RS.add()
                  ?};
                  _size+=1;
                  _next:=SYNC.del()
               ||
                  _next:=0
               ?};
               _next
            !}
         ?};
         _maski.next()
      !}
   ?};
   {? ~:show | _size=0
   ||
      :RS.MESSAGE:='Rekordy usunięte: '+$_size;
      :RS.ID:='';
      :RS.add()
   ?}
end formula

end proc


proc wyslrepl

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [17.00]
:: OPIS: wyslanie wszystkich zapisow dla okreslonej replikacji
::   WE: [_a] - przeznaczenie danych 'MOBIL'(domyslnie) ,etc.
::       [_b] - numer replikacji (domyslnie 0-tzn. wszystkie)
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  pd:='MOBIL' String[20], Przeznaczenie danych
  repl:=0 Integer, Numer replikacji
end params

formula
  {? ~:repl
  || SYNC_REP.index('PDSYM');
     SYNC_REP.prefix(:pd,);
     {? SYNC_REP.first()
     || {!
        |? exec('wysl_sync_all','synchro',:pd,SYNC_REP.NR);
           SYNC_REP.next()
        !}
     ?}
  || exec('wysl_sync_all','synchro',:pd,:repl)
  ?}
end formula

sql
  select
    count(*)
  from EANN
  where 2=1
end sql

end proc


proc delerepl

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [17.00]
:: OPIS: wyslanie wszystkich zapisow dla okreslonej replikacji
::   WE: [_a] - przeznaczenie danych 'MOBIL'(domyslnie) ,etc.
::       [_b] - numer replikacji (domyslnie 0-tzn. wszystkie)
::----------------------------------------------------------------------------------------------------------------------
end desc

params
  pd:='MOBIL' String[20], Przeznaczenie danych
  repl:=0 Integer, Numer replikacji
end params

sql
   select 0 as wyn from FIRMA where 1=0
end sql

formula
   _wyn:=0;
   _sync_pd:=exec('FindInSet','#table','SYNC_PD','SYM',:pd,:pd);
   _czyrepl:=~:repl | exec('FindInSet','#table','SYNC_REP','PDNR',:repl,_sync_pd)<>null();
   _msk:=SYNC.names();
   _msk.clear();
   {? _czyrepl & _msk.first()
   ||
      {!
      |? SYNC.use(_msk.NAME);
         SYNC.index('PDSYMNR');
         {? ~:repl || SYNC.prefix(:pd) || SYNC.prefix(:pd,:repl) ?};
         {? SYNC.first()
         ||
            {!
            |? {? SYNC.WGIDPUT<>'T'
               ||
                  _wyn+=1;
                  SYNC.del()
               ||
                  SYNC.next()
               ?}
            !}
         ?};
         _msk.next
      !}
   ?};
   obj_del(_msk);
   :RS.clear();
   :RS.blank();
   :RS.WYN:=_wyn;
   :RS.add(1)
end formula

end proc


proc tabmobil

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: [rr] [17.00]
:: OPIS: wyslanie struktury tabel dla MOBIL
::----------------------------------------------------------------------------------------------------------------------
end desc

sql
   select
      SPACE(20) ID,
      SPACE(16) REF,
      SPACE(8) ACR,
      SPACE(3) RODZ,
      SPACE(3) FIRMA,
      SYNC.LP,
      TR,
      STATUS, R_IDADD
   from SYNC
      where 1=0
end sql

formula
  {? var_pres('__Synch')=-1 || __Synch:=obj_new(@.CLASS.SYNCHOBJ) ?};
  _mob:=exec('FindInSet','#table','SYNC_PD','SYM','MOBIL','MOBIL');
  {? _mob<>null()
  || _tab:=sql('select distinct '+
                 'SYNC_DEF.ACR_TAB as TAB '+
               'from SYNC_DEF '+
                 'where SYNC_DEF.SYNC_PD=:_a\ and SYNC_DEF.ACR_TAB<>\'MOBIL\'',_mob);
     _tab.clear();
     {? _tab.first()
     || _lp:=0;
        {!
        |? SYNC_DEF.index('PDTAB');
           SYNC_DEF.prefix(_tab.TAB,_mob,'T');
           {? SYNC_DEF.first
           || __Synch.set(_mob,'tab',_tab.TAB);
              {!
              |? {? SYNC_DEF.AKT='T' || __Synch.line(SYNC_DEF.TYP+SYNC_DEF.ACR_FLD,'') ?};
                 SYNC_DEF.next()
              !};
              _lp+=1;
              :RS.clear();
              :RS.blank();
              :RS.ID:=$SYNC.tm_stamp();
              :RS.FIRMA:='';
              :RS.REF:=_tab.TAB;
              :RS.LP:=_lp;
              :RS.TR:='';
              _len:=__Synch.wsk;
              {! _i:=1.._len
              |!
                  :RS.TR+=__Synch.tabela[_i]
              !};
              :RS.STATUS:=SYNC.STATUS;
              :RS.R_IDADD:=SYNC.R_IDADD;
              :RS.ACR:=_tab.TAB;
              :RS.RODZ:='tab';
              :RS.add(1)
           ?};
           _tab.next()
        !}
     ?}
   ?}

end formula

end proc


proc sync

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: Mario [12.41]
:: OPIS: przygotowywanie danych na podstawie tabeli SYNC - zostana zwrocone dane zwiazane z zalogowana firma
::       oraz rekordy bez wypelnionej firmy
::       {call sync@synchro('MOBIL','KH')}
::   WE: _a - przeznaczenie danych np. OLAP, MOBIL, LOTUS
::       _b - ilosc rekordow w wyniku, podajemy jezeli chcemy okreslic max liczbe wierszy w wyniku
::       _c - gdy maja zostac zwrocone rekordy dla firmy (podajmy kod firmy), gdy nie podamy parametru zostanie
::             ustawiona firma wg wykorzystywanego polaczenia ODBC
::       _d - Numer replikacji danych, parametr jest sprawdzany czy dla przeznaczenia danych istnieje replika
::
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   pd:='MOBIL' String[20], Przeznaczenie danych
   il_rec Integer, Ilość rekordów w wyniku
   fir:='' String[3], Kod firmy
   repl Integer, Numer replikacji
end params

formula
   {? :fir=''
   || :fir:=__Firma
   ?}
end formula

sql
   select
      SPACE(255) TR1,
      SPACE(255) TR2,
      SPACE(255) TR3,
      SPACE(255) TR4,
      SPACE(255) TR5,
      SPACE(255) TR6,
      SPACE(255) TR7,
      SPACE(255) TR8,
      SPACE(255) TR9,
      SPACE(255) TR10,
      TR,
      ID, REF, ACR, RODZ, FIRMA, LP, STATUS, R_IDADD
   from
      SYNC
   where
      1=0
   order by
      ID
end sql

formula
   _break:=0;
   _mob:=exec('FindInSet','#table','SYNC_PD','SYM',:pd,:pd);

   {? _mob<>null()
   ||
      {? :il_rec>0
      ||
         _ilosc:=0;

         {! _ii:=1..2
         |!
            {? _ii=1 || SYNC.use('synd___') || SYNC.use('synd'+:fir) ?};
            SYNC.index('PDSYMNR');
            SYNC.prefix(:pd,:repl,1);
            {? SYNC.first()
            ||
               {!
               |?
                  {? SYNC.WGIDPUT<>'T'
                  ||
                     _ilosc+=1;

                     _id:=SYNC.ID;
                     SYNC.cntx_psh();
                     SYNC.index('ID');
                     SYNC.prefix(_id);
                     {? SYNC.first()
                     ||
                        :RS.clear();
                        :RS.blank();
                        :RS.ID:=SYNC.ID;
                        :RS.REF:=SYNC.REF;
                        :RS.ACR:=SYNC.ACR;
                        :RS.RODZ:=SYNC.RODZ;
                        :RS.FIRMA:={? _ii=1 || '___' || :fir ?};
                        :RS.LP:=SYNC.LP;
                        :RS.STATUS:=SYNC.STATUS;
                        :RS.R_IDADD:=SYNC.R_IDADD;
                        :RS.TR:='';
                        _ii:=0;
                        {!
                        |?
                           _ii+=1;
                           :RS[_ii]:=SYNC.TR;
                           :RS.TR+=SYNC.TR;
                           _ii<=10 & SYNC.next()
                        !};
                        {? ~:RS.add(1) || _break:=1 ?}
                     ?};
                     SYNC.cntx_pop()
                  ?};
                  ~_break & SYNC.next() & _ilosc<:il_rec
               !}
            ?};
            _ilosc:=0
         !};
         _ilosc:=0;
         {? :RS.first()
         ||
            {!
            |?
               _ilosc+=1;
               {? :il_rec>=_ilosc
               || _wyn:=:RS.next()
               || _wyn:=:RS.del(,1);
                  {? _wyn=2 || _wyn:=1 || _wyn:=0 ?}
               ?};
               _wyn
            !}
         ?}
      ?}
   ?}
end formula

end proc


proc kompresuj

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: Mario [12.41]
:: OPIS: analiza SYNC i usunięcie nieznaczących put
::       proc_exe('kompresuj@synchro',:pd,:repl)
::   WE: _a - przeznaczenie danych np. OLAP, MOBIL, LOTUS
::       _b - Numer replikacji danych, parametr jest sprawdzany czy dla przeznaczenia danych istnieje replika
::       _c - gdy maja zostac zwrocone rekordy dla firmy (podajmy kod firmy), gdy nie podamy parametru zostanie
::             ustawiona firma wg wykorzystywanego polaczenia ODBC
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   pd:='MOBIL' String[20],Przeznaczenie danych
   repl Integer, Numer replikacji
   fir:='001' String[3], Kod firmy
   show:=0 Integer, Pokazywać wszystkie usunięte rekordy
end params

formula
   {? :fir=''
   || :fir:=__Firma
   ?}
end formula

sql
   select SPACE(45) as MESSAGE, SPACE(16) as ID from FIRMA where 1=0
end sql

formula
   _size:=0;
   _mob:=exec('FindInSet','#table','SYNC_PD','SYM',:pd,:pd);

   {? _mob<>null()
   ||
      _il_rec:=0;

      {! _ii:=1..2
      |!
         {? _ii=1 || SYNC.use('synd___') || SYNC.use('synd'+:fir) ?};
         _ind:=SYNC.ndx_tmp('',,'SYNC_PD','SYM',,'SYNC_REP','NR',,'LP',,,'REF',,,'ID',,1);
         SYNC.index(_ind);
         SYNC.prefix(:pd,:repl,1);

         {? SYNC.first()
         ||

            {!
            |?
               _ref_sql:=SYNC.REF;
               SYNC.cntx_psh();
               SYNC.prefix(:pd,:repl,1,_ref_sql);
               _put:=0;
               {? SYNC.first()
               ||
                  {!
                  |?
                     {? _put=0
                     || _put:=1;
                        SYNC.next()
                     |? _put=1
                     ||
                        _id:=SYNC.ID;
                        _wdel:=SYNC.del(,1);
                        {? :show
                        || :RS.MESSAGE:='Usunięto';
                           :RS.ID:=SYNC.ID;
                           :RS.add()
                        ?};
                        _size+=1;
                        {? _wdel=2 || _next:=1 || _next:=0 ?};
                        SYNC.cntx_psh();
                        SYNC.index('ID');
                        SYNC.prefix(_id);
                        {? SYNC.first
                        ||
                           {!
                           |? {? :show
                              || :RS.MESSAGE:='Usunięto';
                                 :RS.ID:=SYNC.ID;
                                 :RS.add()
                              ?};
                              _size+=1;
                              SYNC.del
                           !}
                        ?};
                        SYNC.cntx_pop();
                        _next
                     ||
                        SYNC.next
                     ?}
                  !}
               ?};
               SYNC.cntx_pop();
               SYNC.next
            !}
         ?};
         SYNC.ndx_drop(_ind)
      !}
   ?};
   {? ~:show | _size=0
   || :RS.MESSAGE:='Rekordy usunięte: '+$_size;
      :RS.add()
   ?}
end formula

end proc


proc new_sync

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: AWI [20.14]
::  MOD: MicKoc 15.03.2023
:: OPIS: przygotowywanie danych na podstawie tabeli SYNC - zostana zwrocone dane zwiazane z zalogowana firma
::       oraz rekordy bez wypelnionej firmy
::       {call sync@synchro('MOBIL','KH')}
::
::       UWAGA!
::          Kopia "proc new_sync_es" na potrzeby ograniczenia zasilania do zakresu lat
::          W przypadku błędów/rozwoju itp uwzględnić w obu: new_sync i new_sync_es
::
::   WE: _a - przeznaczenie danych np. ABSTOREB2B, ABSTOREB2C, ELASTIC, QLIK
::       _b - numer replikacji danych, parametr jest sprawdzany czy dla przeznaczenia danych istnieje replika
::       [_c] - akronim tabeli
::       _d - ilosc rekordow w wyniku, podajemy jezeli chcemy okreslic max liczbe wierszy w wyniku
::       _e - gdy maja zostac zwrocone rekordy dla firmy (podajmy kod firmy), gdy nie podamy parametru zostanie
::            ustawiona firma wg wykorzystywanego polaczenia ODBC
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   pd String[20], Przeznaczenie danych
   repl Integer, Numer replikacji
   tab:='' String[8], Akronim tabeli
   il_rec:=1000 Integer, Ilość rekordów w wyniku
   fir:='' String[3], Kod firmy
   id_sync:='' String[31], maksymalny znacznik czasowy pobieranych danych
end params

formula
   {? :fir=''
   || :fir:=__Firma
   ?};
   {? :il_rec>1000000
   || :il_rec:=1000000
   ?}
end formula

sql
   select
      SPACE(255) TR1,
      SPACE(255) TR2,
      SPACE(255) TR3,
      SPACE(255) TR4,
      SPACE(255) TR5,
      SPACE(255) TR6,
      SPACE(255) TR7,
      SPACE(255) TR8,
      SPACE(255) TR9,
      SPACE(255) TR10,
      TR,
      ID, REF, ACR, RODZ, FIRMA, LP, STATUS, R_IDADD, R_IDPUT, IDSYNC
   from SYNC
   where 1=0
   order by ID
end sql

formula
   _top:=100;
   :RS.clear();
   _pd:=exec('FindInSet','#table','SYNC_PD','SYM',:pd,:pd,,,,null());
   _repl:=null();
   _idsync:=
      {? :id_sync<>''
      ||
         :id_sync
      ||
         exec('time_ident','synchro')
      ?};
   {? _pd<>null()
   ||
      _firma:=exec('FindInSet','#table','FIRMA','SYMBOL',:fir);
#     _replakt - sprawdzenie aktywności repliki jeśli jest podana w parametrze :repl
      _replakt:='N';
      {? :repl
      ||
         SYNC_REP.cntx_psh();
         SYNC_REP.index('PDNR');
         SYNC_REP.prefix(_pd,:repl);
         {? SYNC_REP.first()
         ||
            _repl:=SYNC_REP.ref();
            _replakt:=SYNC_REP.AKT
         ?};
         SYNC_REP.cntx_pop()
      ?};
# IDPUT'y pobranych wcześniej danych
      SYNCNIDP.cntx_psh();
      SYNCNIDP.index('FREP_ACR');
      SYNCNIDP.prefix(:fir,_pd,_repl);
#     _Tab - tabela z zapisami tabel synchronizowanych wg IDPUT
      _Tab:=tab_tmp(1
         ,'ACR','STRING[8]','Akronim tabeli'
         ,'DEL','INTEGER','Czy kasować dane w wyniku?'
         ,'IDPUTOD','IDTIME','IDPUTOD'
         ,'IDADDOD','IDTIME','IDADDOD');
#     _Tab_idp - tabela przechowująca ostatnio odczytane IDPUT'y
      _Tab_idp:=tab_tmp(1
         ,'ACR','STRING[8]','Akronim tabeli'
         ,'IDPUT','IDTIME','IDPUT'
         ,'IDADD','IDTIME','IDADD');
#
      {? :il_rec>0 & (:repl=0 | _replakt='T')
      ||
         _ilosc:=0;
#        indeksy :RS
         _rs_ndx1:=:RS.index('?');
         _rs_ndx2:=:RS.ndx_tmp(,,'ACR',,,'R_IDPUT',,);
# IDPUT, IDADD początkowy
         _idputod:='';
         _idaddod:='';
# IDPUT końcowy
         _idputdo:=_idsync;
# tabele synchronizowane wg IDPUT
         SYNC_DEF.cntx_psh();
         SYNC_DEF.index('PDNR');
         SYNC_DEF.prefix(_pd);
         _loop:=SYNC_DEF.first();
         {!
         |? _loop
         |!
            {? SYNC_DEF.WGIDPUT='T'
                  &
               (:tab='' | SYNC_DEF.ACR_TAB=:tab)
                  &
               ~_Tab.find_key(SYNC_DEF.ACR_TAB)
            ||
               _Tab.ACR:=SYNC_DEF.ACR_TAB;
               _Tab.DEL:=0;
               _Tab.add()
            ?};
            _loop:=SYNC_DEF.next()
         !};
#
# początek iteracji po tabelach z uwzględnieniem zapisów pomocniczych w SYNC
#
         _loop:=_Tab.first();
         {!
         |? _loop
         |!
# tabela
            _acr:=_Tab.ACR;
            _TAB:=($_acr)();
            _idp_acr:=_TAB.idput_acr();
            _ok:=_idp_acr<>'';
#           _stop - 0/1 czy zatrzymać przetwarzanie?
            _stop:=0;
# definicja synchro tabeli
            SYNC_DEF.index('PDTAB');
            SYNC_DEF.prefix(_acr,_pd,'T');
            {? _ok & SYNC_DEF.first()
            ||
#              ustawienia globalne
#              _fir - T/N - dane jednofirmowe
               _fir:=SYNC_DEF.FIR;
#              _syncfir - czy synchronizować firmę
               _syncfir:=0;
               {? _fir='N'
               ||
                  SYNC_FIR.cntx_psh();
                  SYNC_FIR.index('PDTAB');
                  SYNC_FIR.prefix(_pd,_acr,_acr,:fir);
                  _syncfir:=SYNC_FIR.first();
                  SYNC_FIR.cntx_pop()
               ?};
# IDPUT początkowy
               {? SYNCNIDP.find_key(_acr,)
               ||
                  _idputod:=SYNCNIDP.IDPUT;
                  _idaddod:=SYNCNIDP.IDADDOD;
                  SYNCNIDP.IDSYNC:=_idsync;
                  SYNCNIDP.put()
               ||
                  _idputod:='';
                  _idaddod:='';
                  SYNCNIDP.blank();
                  SYNCNIDP.FIRMA:=:fir;
                  SYNCNIDP.SYNC_PD:=_pd;
                  SYNCNIDP.SYNC_REP:=_repl;
                  SYNCNIDP.ACR:=_acr;
                  SYNCNIDP.IDSYNC:=_idsync;
                  SYNCNIDP.add()
               ?};
               _Tab.IDPUTOD:=_idputod;
               _Tab.IDADDOD:=_idaddod;
               _Tab.put();
               {? SYNCNIDP.r_lock(1,1,1)
               ||
#                 odblokowanie rekordów tabeli SYNCNIDP na końcu procedury
                  _loop:=1;
                  {!
                  |? _loop
                  |!
# _TABREK - analizowane rekordy - dodane i poprawione
                     _TABREK:=sql('
                        select top :_a
                           REFERENCE REF,
                           :_c IDPUT
                        from
                           @:_b
                        where
                           :_b.:_c>'':_d'' and :_b.:_c<'':_e''
                        order by
                           2,1
                     '
                     ,_top,_TAB,_idp_acr,_idputod,_idputdo);
# _SYNCREK - analizowane rekordy - usunięte
                     _SYNCREK:=sql('
                        select top :_a
                           SYNC.R_IDPUT IDPUT,
                           SYNC.IDADD IDADD,
                           REF TAB_REF,
                           REFERENCE REF,
                           ID ID
                        from
                           @SYNC
                        where
                           (SYNC.REFERENCE like ''synd\\_\\_\\_%'' escape ''\\'' or SYNC.REFERENCE like ''synd:_b%'')
                           and SYNC.SYNC_PD=:_c and SYNC.ACR='':_d'' and (SYNC.SYNC_REP=:_e or SYNC.SYNC_REP is null)
                           and SYNC.RODZ=''del'' and SYNC.LP=1
                           and (SYNC.R_IDPUT='':_f'' and SYNC.IDADD>'':_g'' or SYNC.R_IDPUT>'':_f'')
                           and SYNC.R_IDPUT<'':_h''
                        order by
                           1,2
                     '
                     ,_top,:fir,_pd,_acr,_repl,_idputod,_idaddod,_idputdo);
# !!! Tworzenie indeksu poniżej związane jest z błędem systemowym - zapytanie powyżej
# nieprawidłowo buduje / ustawia indeks (order by 1,2).
_SYNCREK.index(_SYNCREK.ndx_tmp(,,'IDPUT',,,'IDADD',,));
# !!!
# iterujemy po rekordach tabeli _TABREK i rekordach tabeli __SYNCREK zawierające się w przedziale czasowym wyznaczonym
# przez kolejne rekordy tabeli _TABREK
# jeśli tabela _TABREK jest pusta iterujemy tylko po rekordach tabeli __SYNCREK
# rekordy analizowane są do chwili osiągnięcia ilości oczekiwanych rekordów w wyniku lub jeśli znacznik czasowy
# analizowanego rekordu przekroczy znacznik do którego pobierane są rekordy (_idputdo)
# tabele z rekordami do analizy _TABREK, _SYNCREK zasilane są paczkami maksymalnie po _top rekordów dla każdej z tabel
                     _TAB.cntx_psh();
                     _tab_first:=_TABREK.first();
                     _loop:=_tab_first | _SYNCREK.first();
                     {? ~_loop
                     ||
# aktualizacja _Tab
#                       brak rekordów do analizy w okresie do _idputdo
                        _Tab.IDPUTOD:=_idputdo;
                        _Tab.IDADDOD:='';
                        _Tab.put()
                     ?};
                     {? _loop
                     ||
                        _lastloop:=0;
                        {!
                        |? _loop
                        |!
                           _ref:={? _tab_first || _TABREK.REF || _SYNCREK.TAB_REF ?};
                           _TAB.use(ref_name(_ref));
                           _TAB.cntx_psh();
                           _TAB.prefix();
                           _TAB.seek(_ref);
#                          _save - 0/1 - czy zapisywać do :RS
                           _save:=0;
#                          nr repliki dla rekordu
                           _replrek:={? SYNC_DEF.FLD_REP<>'' || ($(SYNC_DEF.ACR_TAB+'.'+SYNC_DEF.FLD_REP))() || 0 ?};
                           {? :repl
                           ||
#                             podano replikę w parametrach procedury
                              {? _replrek=0 | _replrek=:repl
                              ||
#                                brak nr replik w rekordzie
#                                lub nr repliki w rekordzie zgodny z podaną w parametrach procedury
                                 _save:=1
                              ?}
                           ||
#                             nie podano repliki w parametrach procedury
                              _save:=1
                           ?};
                           {? _save
                           ||
                              _idput:={? _tab_first || _TAB.idput_value() || _idputdo  ?};
# begin: dodanie do :RS danych o usuniętych rekordach (zapisy z SYNC)
                              _loop:={? _idputod='' || _SYNCREK.first() || _SYNCREK.find_ge(_idputod,_idaddod) ?};
                              {!
                              |? _loop
                              |!
                                 SYNC.cntx_psh();
                                 SYNC.use(ref_name(_SYNCREK.REF));
                                 SYNC.prefix();
                                 {? ~SYNC.seek(_SYNCREK.REF)   || _stop:=1
                                 |? ~SYNC.r_lock(1,1,1)        || _stop:=1
                                 |? SYNC.IDADD=_idaddod        || SYNC.r_unlock()
                                 |? SYNC.R_IDPUT>_idput        || SYNC.r_unlock(); _loop:=0
                                 ||
                                    SYNC.cntx_psh();
                                    SYNC.index('ID');
                                    SYNC.prefix(_SYNCREK.ID);
                                    {? SYNC.first()
                                    ||
                                       :RS.blank();
                                       :RS.ID:=SYNC.ID;
                                       :RS.REF:=SYNC.REF;
                                       :RS.ACR:=SYNC.ACR;
                                       :RS.RODZ:=SYNC.RODZ;
                                       :RS.FIRMA:={? SYNC.name()+3='___' || '___' || :fir ?};
                                       :RS.LP:=SYNC.LP;
                                       _ii:=0;
                                       {!
                                       |?
                                          _ii+=1;
                                          :RS[_ii]:=SYNC.TR;
                                          :RS.TR+=SYNC.TR;
                                          SYNC.IDSYNC:=_idsync;
                                          {? ~SYNC.put() || _stop:=1 ?};
                                          _stop=0 & _ii<=10 & SYNC.next()
                                       !};
                                       :RS.STATUS:=SYNC.STATUS;
                                       :RS.R_IDADD:=SYNC.R_IDADD;
                                       :RS.R_IDPUT:=SYNC.R_IDPUT;
                                       :RS.IDSYNC:=_idsync;
# dopisanie do :RS - del
                                       {? _stop | ~:RS.add()
                                       ||
                                          _stop:=1
                                       ||
                                          _ilosc+=1;
# aktualizacja _Tab_idp
                                          {? _Tab_idp.find_key(_acr,)
                                          ||
                                             {? SYNC.R_IDPUT>_Tab_idp.IDPUT
                                             ||
                                                _Tab_idp.IDPUT:=SYNC.R_IDPUT;
                                                _Tab_idp.IDADD:=SYNC.IDADD;
                                                _Tab_idp.put()
                                             ?}
                                          ||
                                             _Tab_idp.ACR:=_acr;
                                             _Tab_idp.IDPUT:=SYNC.R_IDPUT;
                                             _Tab_idp.IDADD:=SYNC.IDADD;
                                             _Tab_idp.add()
                                          ?};
                                          _idputod:=_Tab_idp.IDPUT;
                                          _idaddod:=_Tab_idp.IDADD
                                       ?}
                                    ?};
                                    SYNC.cntx_pop();
                                    SYNC.r_unlock()
                                 ?};
                                 SYNC.cntx_pop();
                                 _loop:=_loop & _stop=0 & _ilosc<:il_rec & _SYNCREK.next()
                              !};
                              _idput:={? _tab_first || _TAB.idput_value() || _idputdo  ?};
# end: dodanie do :RS danych o usuniętych rekordach (zapisy z SYNC)
                              {? _ilosc>=:il_rec | _tab_first=0
                              ||
                                 _loop:=0

                              |? _stop=0 & _idputod<_idput & _idput<=_idputdo
                              ||
# dane do synchronizacji
                                 _tr:='';
# blokada rekordu
                                 {? ~_TAB.r_lock(1,1,1)
                                 ||
                                    _stop:=1

                                 |? SYNC_DEF.WAR_FORM<>'' & ($(SYNC_DEF.WAR_FORM))('put',:fir,_firma)=0
                                 ||
# rekord nie spełnia warunku więc go pomijamy
                                    _TAB.r_unlock();
# aktualizacja _Tab_idp
                                    {? _Tab_idp.find_key(_acr,)
                                    ||
                                       {? _idput>_Tab_idp.IDPUT
                                       ||
                                          _Tab_idp.IDPUT:=_idput;
                                          _Tab_idp.IDADD:='';
                                          _Tab_idp.put()
                                       ?}
                                    ?};
# aktualizacja _Tab
                                    _Tab.IDPUTOD:=_idput;
                                    _Tab.IDADDOD:='';
                                    _Tab.put();
                                    _idputod:=_Tab.IDPUTOD;
                                    _idaddod:=_Tab.IDADDOD
                                 ||
# __Synch.save(0)
                                    _TAB.cntx_psh();
                                    _loop:=SYNC_DEF.first();
                                    {!
                                    |? _loop
                                    |!
                                       _wart:=($(SYNC_DEF.FORM))();
                                       _typ:=type_of(_wart);
                                       {? _typ=1 | _typ=2 | _typ=4 || _wart:=form(_wart,,,'9.') ?};
                                       _wart:=SYNC_DEF.TYP+SYNC_DEF.ACR_FLD+':'+_wart;
                                       _wart:=gsub(_wart,';',':');
                                       _wart+=';';
                                       _tr+=_wart;
                                       _loop:=SYNC_DEF.next()
                                    !};
                                    _TAB.cntx_pop();
# savebody
                                    _id:=$FIRMA.tm_stamp();
                                    :RS.blank();
                                    :RS.TR:=_tr;
                                    {? _tr<>''
                                    ||
                                       _ii:=0;
                                       {!
                                       |?
                                          _ii+=1;
                                          :RS[_ii]:=255+_tr;
                                          _tr:=255-_tr;
                                          _tr<>'' & _ii<=10
                                       !};
                                       {? _tr<>''
                                       ||
                                          :RS[_ii]:=:RS[_ii]-4;
                                          :RS[_ii]+='...;'
                                       ?}
                                    ?};
                                    :RS.ID:=_id;
                                    :RS.REF:=$_TAB.ref();
                                    :RS.ACR:=_acr;
                                    :RS.RODZ:='put';
                                    :RS.FIRMA:={? _fir='T' || :fir || '___' ?};
                                    :RS.LP:=1;
                                    :RS.STATUS:='';
                                    :RS.R_IDADD:=_TAB.idadd_value();
                                    :RS.R_IDPUT:=_idput;
                                    :RS.IDSYNC:=_idsync;
# dopisanie do :RS - put
                                    {? ~:RS.add()
                                    ||
                                       _stop:=1
                                    ||
                                       _ilosc+=1;
# aktualizacja _Tab_idp
                                       {? _Tab_idp.find_key(_acr,)
                                       ||
                                          {? _idput>_Tab_idp.IDPUT
                                          ||
                                             _Tab_idp.IDPUT:=_idput;
                                             _Tab_idp.IDADD:='';
                                             _Tab_idp.put()
                                          ?}
                                       ||
                                          _Tab_idp.ACR:=_acr;
                                          _Tab_idp.IDPUT:=_idput;
                                          _Tab_idp.IDADD:='';
                                          _Tab_idp.add()
                                       ?};
                                       _idputod:=_Tab_idp.IDPUT;
                                       _idaddod:=_Tab_idp.IDADD;
                                       {? _syncfir
                                       ||
                                          _id:=$FIRMA.tm_stamp();
                                          :RS.ID:=_id;
                                          :RS.FIRMA:=:fir;
# dopisanie do :RS - put
                                          {? ~:RS.add() || _stop:=1 || _ilosc+=1 ?}
                                       ?}
                                    ?};
                                    _TAB.r_unlock()
                                 ?}
                              ?};
                              _loop:=_stop=0 & _TABREK.next()
                           ?};
                           _TAB.cntx_pop()
                        !}
                     ?};
                     _TAB.cntx_pop();
                     {? _stop=0 & _ilosc<:il_rec
                     ||
                        _loop:=
                           {? _idputod=''
                           || _SYNCREK.first()
                           || _TABREK.first()
                                 |
                              _SYNCREK.find_ge(_idputod,_idaddod) & (_SYNCREK.IDPUT>_idputod | _SYNCREK.IDADD>_idaddod)
                           ?}
                     ?};
                     obj_del(_TABREK);
                     obj_del(_SYNCREK)
                  !}
               ?}
            ?};
            obj_del(_TAB);
            _loop:=_ilosc<:il_rec & _Tab.next()
         !};
#
# koniec iteracji po tabelach z uwzględnieniem zapisów pomocniczych w SYNC
#
         SYNC_DEF.cntx_pop()
      ?};
# odpisanie IDPUT - dla tabel, które są zwracane w wyniku
      _loop:=_Tab_idp.first();
      {!
      |? _loop
      |!
         SYNCNIDP.index('FREP_ACR');
         SYNCNIDP.prefix(:fir,_pd,_repl,_Tab_idp.ACR,);
         {? SYNCNIDP.first()
         ||
            SYNCNIDP.IDPUTMP:=_Tab_idp.IDPUT;
            SYNCNIDP.IDADDTMP:=_Tab_idp.IDADD;
            SYNCNIDP.put()
         ?};
         _loop:=_Tab_idp.next()
      !};
# odpisanie IDPUT - dla tabel, które nie są zwracane w wyniku
      _loop:=_Tab.first();
      {!
      |? _loop
      |!
         {? _Tab.DEL=0 & ~_Tab_idp.find_key(_Tab.ACR,)
         ||
            SYNCNIDP.index('FREP_ACR');
            SYNCNIDP.prefix(:fir,_pd,_repl,_Tab.ACR,);
            {? SYNCNIDP.first()
            ||
               SYNCNIDP.IDPUTMP:=_Tab.IDPUTOD;
               SYNCNIDP.IDADDTMP:=_Tab.IDADDOD;
               SYNCNIDP.IDPUT:=SYNCNIDP.IDPUTMP;
               SYNCNIDP.IDADDOD:=SYNCNIDP.IDADDTMP;
               SYNCNIDP.put()
            ?}
         ?};
         _loop:=_Tab.next()
      !};
      SYNCNIDP.cntx_pop();
      unlock_r();
# pobranie reszty danych dotychczasową procedurą
      :RS.prefix();
      _size:=:RS.size();
      :il_rec:=:il_rec-_size;
      {? :il_rec>=0
      ||
         _SYNC:=
            {? :tab=''
            || proc_exec('sync@synchro',:pd,:il_rec,:fir,:repl)
            || proc_exec('sync_sql@synchro',:pd,:tab,:il_rec,:fir,:repl)
            ?};
         _loop:=_SYNC.first();
         {!
         |? _loop
         |!
            :RS.blank();
            :RS.TR1:=_SYNC.TR1;
            :RS.TR2:=_SYNC.TR2;
            :RS.TR3:=_SYNC.TR3;
            :RS.TR4:=_SYNC.TR4;
            :RS.TR5:=_SYNC.TR5;
            :RS.TR6:=_SYNC.TR6;
            :RS.TR7:=_SYNC.TR7;
            :RS.TR8:=_SYNC.TR8;
            :RS.TR9:=_SYNC.TR9;
            :RS.TR10:=_SYNC.TR10;
            :RS.TR:=_SYNC.TR;
            :RS.ID:=_SYNC.ID;
            :RS.REF:=_SYNC.REF;
            :RS.ACR:=_SYNC.ACR;
            :RS.RODZ:=_SYNC.RODZ;
            :RS.FIRMA:=_SYNC.FIRMA;
            :RS.LP:=_SYNC.LP;
            :RS.STATUS:=_SYNC.STATUS;
            :RS.R_IDADD:=_SYNC.R_IDADD;
            :RS.R_IDPUT:='';
            :RS.IDSYNC:=_idsync;
# dopisanie do :RS
            :RS.add();
            _loop:=_SYNC.next()
         !}
      ?}
   ?}
end formula

end proc


proc new_sync_id_del

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: AWI [20.14]
:: OPIS: usuwa zapis z tabeli synchronizacji, usuwa ID i wszystkie poprzednie wystapienia
::   WE: _a - przeznaczenie danych np. ABSTOREB2B, ABSTOREB2C, ELASTIC, QLIK
::       [_b] - numer repliki danych, parametr jest sprawdzany czy dla przeznaczenia danych istnieje replika
::       [_c] - akronim tabeli
::       [_d] - identyfikator rekordu
::       [_e] - znacznik modyfikacji rekordu
::       [_f] - czy pokazywać wszystkie usunięte rekordy (1), czy tylko ich liczbę (0 - domyślnie)
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   pd String[20],Przeznaczenie danych
   repl:=0 Integer, Numer repliki
   acr:='' STRING, Akronim tabeli
   id:='' String[20],Identyfikator
   idsync:='' STRING[50], Id synchronizacji
   show:=0 Integer, Pokazywać wszystkie usunięte rekordy
   fir:='' String[3], Kod firmy
end params

sql
   select SPACE(45) as MESSAGE, SPACE(31) as ID from FIRMA where 1=0
end sql

formula
   {? :fir=''
   || :fir:=__Firma
   ?};
   _pd:=exec('FindInSet','#table','SYNC_PD','SYM',:pd,:pd);
   _repl:=null();
#  _replakt - sprawdzenie aktywności repliki jeśli jest podana w parametrze :repl
   _replakt:='N';
   {? :repl
   ||
      SYNC_REP.cntx_psh();
      SYNC_REP.index('PDNR');
      SYNC_REP.prefix(_pd,:repl);
      {? SYNC_REP.first()
      ||
         _repl:=SYNC_REP.ref();
         _replakt:=SYNC_REP.AKT
      ?};
      SYNC_REP.cntx_pop()
   ?};
   _stamp:=$SYNC.tm_stamp();
   _maski:=SYNC.names();
   _size:=0;
   {? :idsync<>''
   ||
      SYNC.cntx_psh();
      SYNCNIDP.cntx_psh();
      SYNCNIDP.index('IDSYNC');
      {? _replakt='T'
      ||
         {? :acr=''
         || SYNCNIDP.prefix(:fir,:idsync,_repl)
         || SYNCNIDP.prefix(:fir,:idsync,_repl,:acr,)
         ?}
      ||
         {? :acr=''
         || SYNCNIDP.prefix(:fir,:idsync,null())
         || SYNCNIDP.prefix(:fir,:idsync,null(),:acr,)
         ?}
      ?};
      _loop:=SYNCNIDP.first();
      {!
      |? _loop
      |!
         {? SYNCNIDP.IDPUT<>SYNCNIDP.IDPUTMP | SYNCNIDP.IDPUT=SYNCNIDP.IDPUTMP & SYNCNIDP.IDADDOD<>SYNCNIDP.IDADDTMP
         ||
            do();
            _loop:=_maski.first();
            {!
            |? _loop
            |!
               SYNC.use(_maski.NAME);
               SYNC.cntx_psh();
               SYNC.index('IDSYNC');
               SYNC.prefix(:idsync);
               _loop:=SYNC.first();
               {!
               |? _loop
               |!
                  _size+=1;
                  {? :show
                  ||
                     :RS.MESSAGE:='Usunięto';
                     :RS.ID:=SYNC.ID;
                     :RS.add()
                  ?};
                  _loop:=SYNC.del()
               !};
               SYNC.cntx_pop();
               _loop:=_maski.next()
            !};
            SYNCNIDP.IDPUT:=SYNCNIDP.IDPUTMP;
            SYNCNIDP.IDADDOD:=SYNCNIDP.IDADDTMP;
            {? SYNCNIDP.put()
            ||
               :RS.MESSAGE:='Tabela %1 zsynchronizowana'[SYNCNIDP.ACR];
               :RS.ID:=SYNCNIDP.IDPUT;
               :RS.add()
            ?};
            end()
         ?};
         _loop:=SYNCNIDP.next()
      !};
      SYNCNIDP.cntx_pop();
      SYNC.cntx_pop()
   ?};
   {? ~:show | _size=0
   ||
      :RS.MESSAGE:='Rekordy usunięte (del wg znacznika czasowego): '+$_size;
      :RS.ID:='';
      :RS.add()
   ?};
# usunięcie danych z SYNC
   _SYNC:=proc_exec('sync_id_del@synchro',:id,:pd,:repl,:show,:acr);
   _loop:=_SYNC.first();
   {!
   |? _loop
   |!
      :RS.blank();
      :RS.MESSAGE:=_SYNC.MESSAGE;
      :RS.ID:=_SYNC.ID;
# dopisanie do :RS
      :RS.add();
      _loop:=_SYNC.next()
   !}
end formula

end proc

proc new_sync_es

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: AWI [20.14]
::  MOD: MicKoc 15.03.2023
:: OPIS: Kopia "proc new_sync" na potrzeby ograniczenia zasilania do zakresu lat
::       UWAGA!
::
::          W przypadku błędów/rozwoju itp uwzględnić w obu: new_sync i new_sync_es
::
::       przygotowywanie danych na podstawie tabeli SYNC - zostana zwrocone dane zwiazane z zalogowana firma
::       oraz rekordy bez wypelnionej firmy
::       {call sync@synchro('MOBIL','KH')}
::   WE: _a - przeznaczenie danych np. ABSTOREB2B, ABSTOREB2C, ELASTIC, QLIK
::       _b - numer replikacji danych, parametr jest sprawdzany czy dla przeznaczenia danych istnieje replika
::       [_c] - akronim tabeli
::       _d - ilosc rekordow w wyniku, podajemy jezeli chcemy okreslic max liczbe wierszy w wyniku
::       _e - gdy maja zostac zwrocone rekordy dla firmy (podajmy kod firmy), gdy nie podamy parametru zostanie
::            ustawiona firma wg wykorzystywanego polaczenia ODBC
::       _f - rok od dla aktualizacji
::       _g - rok do dla aktualizacji
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   pd String[20], Przeznaczenie danych
   repl Integer, Numer replikacji
   tab:='' String[8], Akronim tabeli
   il_rec:=1000 Integer, Ilość rekordów w wyniku
   fir:='' String[3], Kod firmy
   rokOd:=0 Integer, Rok początkowy aktualizacji danych
   rokDo:=0 Integer, Rok końcowy aktualizacji danych
   idStart:='' String[31], Ostatni idput z tabeli
end params

formula
   {? :fir=''
   || :fir:=__Firma
   ?};
   {? :il_rec>1000000
   || :il_rec:=1000000
   ?}
end formula

sql
   select
      SPACE(255) TR1,
      SPACE(255) TR2,
      SPACE(255) TR3,
      SPACE(255) TR4,
      SPACE(255) TR5,
      SPACE(255) TR6,
      SPACE(255) TR7,
      SPACE(255) TR8,
      SPACE(255) TR9,
      SPACE(255) TR10,
      TR,
      ID, REF, ACR, RODZ, FIRMA, LP, STATUS, R_IDADD, R_IDPUT, IDSYNC
   from SYNC
   where 1=0
   order by ID
end sql

formula
   _top:=100;
   :RS.clear();
   _pd:=exec('FindInSet','#table','SYNC_PD','SYM',:pd,:pd,,,,null());
   _repl:=null();
   _data:=date();
   _czas:=time();
   {? _czas=time(0,0,0)
   ||
      _czas:=time(23,59,58); _data-=1

   |? _czas=time(0,0,1)
   ||
      _czas:=time(23,59,59); _data-=1
   ||
      _czas-=time(0,0,2)
   ?};
   _idsync:=time_ident_to_utc(time_ident(_data,_czas));
   _rok:=obj_new('setRok','IdOd','IdDo');
   _rok.setRok:="
      {? _a>0
      || .IdOd:=time_ident_to_utc(time_ident(date(_a,1,1),time(0,0,0)))
      || .IdOd:=''
      ?};
      {? _b>0
      || .IdDo:=time_ident_to_utc(time_ident(date(_b,12,0),time(23,59,59)))
      || .IdDo:=''
      ?};
      {? .IdOd>_c || .IdOd:=_c ?};
      {? .IdDo>_c || .IdDo:=_c ?};
      {? .IdOd<_d || .IdOd:=_d ?};
      _a>0 | _b>0
   ";
   {? _pd<>null()
   ||
      _firma:=exec('FindInSet','#table','FIRMA','SYMBOL',:fir);
#     _replakt - sprawdzenie aktywności repliki jeśli jest podana w parametrze :repl
      _replakt:='N';
      {? :repl
      ||
         SYNC_REP.cntx_psh();
         SYNC_REP.index('PDNR');
         SYNC_REP.prefix(_pd,:repl);
         {? SYNC_REP.first()
         ||
            _repl:=SYNC_REP.ref();
            _replakt:=SYNC_REP.AKT
         ?};
         SYNC_REP.cntx_pop()
      ?};
# IDPUT'y pobranych wcześniej danych
      SYNCNIDP.cntx_psh();
      SYNCNIDP.index('FREP_ACR');
      SYNCNIDP.prefix(:fir,_pd,_repl);
#     _Tab - tabela z zapisami tabel synchronizowanych wg IDPUT
      _Tab:=tab_tmp(1
         ,'ACR','STRING[8]','Akronim tabeli'
         ,'DEL','INTEGER','Czy kasować dane w wyniku?'
         ,'IDPUTOD','IDTIME','IDPUTOD'
         ,'IDADDOD','IDTIME','IDADDOD');
#     _Tab_idp - tabela przechowująca ostatnio odczytane IDPUT'y
      _Tab_idp:=tab_tmp(1
         ,'ACR','STRING[8]','Akronim tabeli'
         ,'IDPUT','IDTIME','IDPUT'
         ,'IDADD','IDTIME','IDADD');
#
      {? :il_rec>0 & (:repl=0 | _replakt='T')
      ||
         _ilosc:=0;
#        indeksy :RS
         _rs_ndx1:=:RS.index('?');
         _rs_ndx2:=:RS.ndx_tmp(,,'ACR',,,'R_IDPUT',,);
# IDPUT, IDADD początkowy
         _idputod:='';
         _idaddod:='';
# IDPUT końcowy
         _idputdo:=_idsync;
         _rok.setRok(:rokOd,:rokDo,_idsync,:idStart);
# tabele synchronizowane wg IDPUT
         SYNC_DEF.cntx_psh();
         SYNC_DEF.index('PDNR');
         SYNC_DEF.prefix(_pd);
         _loop:=SYNC_DEF.first();
         {!
         |? _loop
         |!
            {? SYNC_DEF.WGIDPUT='T'
                  &
               (:tab='' | SYNC_DEF.ACR_TAB=:tab)
                  &
               ~_Tab.find_key(SYNC_DEF.ACR_TAB)
            ||
               _Tab.ACR:=SYNC_DEF.ACR_TAB;
               _Tab.DEL:=0;
               _Tab.add()
            ?};
            _loop:=SYNC_DEF.next()
         !};
#
# początek iteracji po tabelach z uwzględnieniem zapisów pomocniczych w SYNC
#
         _loop:=_Tab.first();
         {!
         |? _loop
         |!
# tabela
            _acr:=_Tab.ACR;
            _TAB:=($_acr)();
            _idp_acr:=_TAB.idput_acr();
            _ok:=_idp_acr<>'';
#           _stop - 0/1 czy zatrzymać przetwarzanie?
            _stop:=0;
# definicja synchro tabeli
            SYNC_DEF.index('PDTAB');
            SYNC_DEF.prefix(_acr,_pd,'T');
            {? _ok & SYNC_DEF.first()
            ||
#              ustawienia globalne
#              _fir - T/N - dane jednofirmowe
               _fir:=SYNC_DEF.FIR;
#              _syncfir - czy synchronizować firmę
               _syncfir:=0;
               {? _fir='N'
               ||
                  SYNC_FIR.cntx_psh();
                  SYNC_FIR.index('PDTAB');
                  SYNC_FIR.prefix(_pd,_acr,_acr,:fir);
                  _syncfir:=SYNC_FIR.first();
                  SYNC_FIR.cntx_pop()
               ?};
# IDPUT początkowy
               _idputod:=_rok.IdOd;
               _idaddod:=_rok.IdOd;
               _idputdo:=_rok.IdDo;
               {? SYNCNIDP.find_key(_acr,)
               || {? _idputdo>SYNCNIDP.IDSYNC
                  || SYNCNIDP.IDSYNC:=_idputdo;
                     SYNCNIDP.put()
                  ?}
               || SYNCNIDP.blank();
                  SYNCNIDP.FIRMA:=:fir;
                  SYNCNIDP.SYNC_PD:=_pd;
                  SYNCNIDP.SYNC_REP:=_repl;
                  SYNCNIDP.ACR:=_acr;
                  SYNCNIDP.IDSYNC:=_idputdo;
                  SYNCNIDP.add()
               ?};
               _Tab.IDPUTOD:=_idputod;
               _Tab.IDADDOD:=_idaddod;
               _Tab.put();
               {? SYNCNIDP.r_lock(1,1,1)
               ||
#                 odblokowanie rekordów tabeli SYNCNIDP na końcu procedury
                  _loop:=1;
                  {!
                  |? _loop
                  |!
# _TABREK - analizowane rekordy - dodane i poprawione
                     _TABREK:=sql('
                        select top :_a
                           REFERENCE REF,
                           :_c IDPUT
                        from
                           @:_b
                        where
                           :_b.:_c>'':_d'' and :_b.:_c<'':_e''
                        order by
                           2,1
                     '
                     ,_top,_TAB,_idp_acr,_idputod,_idputdo);
# _SYNCREK - analizowane rekordy - usunięte
                     _SYNCREK:=sql('
                        select top :_a
                           SYNC.R_IDPUT IDPUT,
                           SYNC.IDADD IDADD,
                           REF TAB_REF,
                           REFERENCE REF,
                           ID ID
                        from
                           @SYNC
                        where
                           0=1
                        order by
                           1,2
                     '
                     ,_top,:fir,_pd,_acr,_repl,_idputod,_idaddod,_idputdo);
# !!! Tworzenie indeksu poniżej związane jest z błędem systemowym - zapytanie powyżej
# nieprawidłowo buduje / ustawia indeks (order by 1,2).
_SYNCREK.index(_SYNCREK.ndx_tmp(,,'IDPUT',,,'IDADD',,));
# !!!
# iterujemy po rekordach tabeli _TABREK i rekordach tabeli __SYNCREK zawierające się w przedziale czasowym wyznaczonym
# przez kolejne rekordy tabeli _TABREK
# jeśli tabela _TABREK jest pusta iterujemy tylko po rekordach tabeli __SYNCREK
# rekordy analizowane są do chwili osiągnięcia ilości oczekiwanych rekordów w wyniku lub jeśli znacznik czasowy
# analizowanego rekordu przekroczy znacznik do którego pobierane są rekordy (_idputdo)
# tabele z rekordami do analizy _TABREK, _SYNCREK zasilane są paczkami maksymalnie po _top rekordów dla każdej z tabel
                     _TAB.cntx_psh();
                     _tab_first:=_TABREK.first();
                     _loop:=_tab_first | _SYNCREK.first();
                     {? ~_loop
                     ||
# aktualizacja _Tab
#                       brak rekordów do analizy w okresie do _idputdo
                        _Tab.IDPUTOD:=_idputdo;
                        _Tab.IDADDOD:='';
                        _Tab.put()
                     ?};
                     {? _loop
                     ||
                        _lastloop:=0;
                        {!
                        |? _loop
                        |!
                           _ref:={? _tab_first || _TABREK.REF || _SYNCREK.TAB_REF ?};
                           _TAB.use(ref_name(_ref));
                           _TAB.cntx_psh();
                           _TAB.prefix();
                           _TAB.seek(_ref);
#                          _save - 0/1 - czy zapisywać do :RS
                           _save:=0;
#                          nr repliki dla rekordu
                           _replrek:={? SYNC_DEF.FLD_REP<>'' || ($(SYNC_DEF.ACR_TAB+'.'+SYNC_DEF.FLD_REP))() || 0 ?};
                           {? :repl
                           ||
#                             podano replikę w parametrach procedury
                              {? _replrek=0 | _replrek=:repl
                              ||
#                                brak nr replik w rekordzie
#                                lub nr repliki w rekordzie zgodny z podaną w parametrach procedury
                                 _save:=1
                              ?}
                           ||
#                             nie podano repliki w parametrach procedury
                              _save:=1
                           ?};
                           {? _save
                           ||
                              _idput:={? _tab_first || _TAB.idput_value() || _idputdo  ?};
# begin: dodanie do :RS danych o usuniętych rekordach (zapisy z SYNC)
                              _loop:={? _idputod='' || _SYNCREK.first() || _SYNCREK.find_ge(_idputod,_idaddod) ?};
                              {!
                              |? _loop
                              |!
                                 SYNC.cntx_psh();
                                 SYNC.use(ref_name(_SYNCREK.REF));
                                 SYNC.prefix();
                                 {? ~SYNC.seek(_SYNCREK.REF)   || _stop:=1
                                 |? ~SYNC.r_lock(1,1,1)        || _stop:=1
                                 |? SYNC.IDADD=_idaddod        || SYNC.r_unlock()
                                 |? SYNC.R_IDPUT>_idput        || SYNC.r_unlock(); _loop:=0
                                 ||
                                    SYNC.cntx_psh();
                                    SYNC.index('ID');
                                    SYNC.prefix(_SYNCREK.ID);
                                    {? SYNC.first()
                                    ||
                                       :RS.blank();
                                       :RS.ID:=SYNC.ID;
                                       :RS.REF:=SYNC.REF;
                                       :RS.ACR:=SYNC.ACR;
                                       :RS.RODZ:=SYNC.RODZ;
                                       :RS.FIRMA:={? SYNC.name()+3='___' || '___' || :fir ?};
                                       :RS.LP:=SYNC.LP;
                                       _ii:=0;
                                       {!
                                       |?
                                          _ii+=1;
                                          :RS[_ii]:=SYNC.TR;
                                          :RS.TR+=SYNC.TR;
                                          SYNC.IDSYNC:=_idsync;
                                          {? ~SYNC.put() || _stop:=1 ?};
                                          _stop=0 & _ii<=10 & SYNC.next()
                                       !};
                                       :RS.STATUS:=SYNC.STATUS;
                                       :RS.R_IDADD:=SYNC.R_IDADD;
                                       :RS.R_IDPUT:=SYNC.R_IDPUT;
                                       :RS.IDSYNC:=_idsync;
# dopisanie do :RS - del
                                       {? _stop | ~:RS.add()
                                       ||
                                          _stop:=1
                                       ||
                                          _ilosc+=1;
# aktualizacja _Tab_idp
                                          {? _Tab_idp.find_key(_acr,)
                                          ||
                                             {? SYNC.R_IDPUT>_Tab_idp.IDPUT
                                             ||
                                                _Tab_idp.IDPUT:=SYNC.R_IDPUT;
                                                _Tab_idp.IDADD:=SYNC.IDADD;
                                                _Tab_idp.put()
                                             ?}
                                          ||
                                             _Tab_idp.ACR:=_acr;
                                             _Tab_idp.IDPUT:=SYNC.R_IDPUT;
                                             _Tab_idp.IDADD:=SYNC.IDADD;
                                             _Tab_idp.add()
                                          ?};
                                          _idputod:=_Tab_idp.IDPUT;
                                          _idaddod:=_Tab_idp.IDADD
                                       ?}
                                    ?};
                                    SYNC.cntx_pop();
                                    SYNC.r_unlock()
                                 ?};
                                 SYNC.cntx_pop();
                                 _loop:=_loop & _stop=0 & _ilosc<:il_rec & _SYNCREK.next()
                              !};
                              _idput:={? _tab_first || _TAB.idput_value() || _idputdo  ?};
# end: dodanie do :RS danych o usuniętych rekordach (zapisy z SYNC)
                              {? _ilosc>=:il_rec | _tab_first=0
                              ||
                                 _loop:=0

                              |? _stop=0 & _idputod<_idput & _idput<=_idputdo
                              ||
# dane do synchronizacji
                                 _tr:='';
# blokada rekordu
                                 {? ~_TAB.r_lock(1,1,1)
                                 ||
                                    _stop:=1

                                 |? SYNC_DEF.WAR_FORM<>'' & ($(SYNC_DEF.WAR_FORM))('put',:fir,_firma)=0
                                 ||
# rekord nie spełnia warunku więc go pomijamy
                                    _TAB.r_unlock();
# aktualizacja _Tab_idp
                                    {? _Tab_idp.find_key(_acr,)
                                    ||
                                       {? _idput>_Tab_idp.IDPUT
                                       ||
                                          _Tab_idp.IDPUT:=_idput;
                                          _Tab_idp.IDADD:='';
                                          _Tab_idp.put()
                                       ?}
                                    ?};
# aktualizacja _Tab
                                    _Tab.IDPUTOD:=_idput;
                                    _Tab.IDADDOD:='';
                                    _Tab.put();
                                    _idputod:=_Tab.IDPUTOD;
                                    _idaddod:=_Tab.IDADDOD
                                 ||
# __Synch.save(0)
                                    _TAB.cntx_psh();
                                    _loop:=SYNC_DEF.first();
                                    {!
                                    |? _loop
                                    |!
                                       _wart:=($(SYNC_DEF.FORM))();
                                       _typ:=type_of(_wart);
                                       {? _typ=1 | _typ=2 | _typ=4 || _wart:=form(_wart,,,'9.') ?};
                                       _wart:=SYNC_DEF.TYP+SYNC_DEF.ACR_FLD+':'+_wart;
                                       _wart:=gsub(_wart,';',':');
                                       _wart+=';';
                                       _tr+=_wart;
                                       _loop:=SYNC_DEF.next()
                                    !};
                                    _TAB.cntx_pop();
# savebody
                                    _id:=$FIRMA.tm_stamp();
                                    :RS.blank();
                                    :RS.TR:=_tr;
                                    {? _tr<>''
                                    ||
                                       _ii:=0;
                                       {!
                                       |?
                                          _ii+=1;
                                          :RS[_ii]:=255+_tr;
                                          _tr:=255-_tr;
                                          _tr<>'' & _ii<=10
                                       !};
                                       {? _tr<>''
                                       ||
                                          :RS[_ii]:=:RS[_ii]-4;
                                          :RS[_ii]+='...;'
                                       ?}
                                    ?};
                                    :RS.ID:=_id;
                                    :RS.REF:=$_TAB.ref();
                                    :RS.ACR:=_acr;
                                    :RS.RODZ:='put';
                                    :RS.FIRMA:={? _fir='T' || :fir || '___' ?};
                                    :RS.LP:=1;
                                    :RS.STATUS:='';
                                    :RS.R_IDADD:=_TAB.idadd_value();
                                    :RS.R_IDPUT:=_idput;
                                    :RS.IDSYNC:=_idsync;
# dopisanie do :RS - put
                                    {? ~:RS.add()
                                    ||
                                       _stop:=1
                                    ||
                                       _ilosc+=1;
# aktualizacja _Tab_idp
                                       {? _Tab_idp.find_key(_acr,)
                                       ||
                                          {? _idput>_Tab_idp.IDPUT
                                          ||
                                             _Tab_idp.IDPUT:=_idput;
                                             _Tab_idp.IDADD:='';
                                             _Tab_idp.put()
                                          ?}
                                       ||
                                          _Tab_idp.ACR:=_acr;
                                          _Tab_idp.IDPUT:=_idput;
                                          _Tab_idp.IDADD:='';
                                          _Tab_idp.add()
                                       ?};
                                       _idputod:=_Tab_idp.IDPUT;
                                       _idaddod:=_Tab_idp.IDADD;
                                       {? _syncfir
                                       ||
                                          _id:=$FIRMA.tm_stamp();
                                          :RS.ID:=_id;
                                          :RS.FIRMA:=:fir;
# dopisanie do :RS - put
                                          {? ~:RS.add() || _stop:=1 || _ilosc+=1 ?}
                                       ?}
                                    ?};
                                    _TAB.r_unlock()
                                 ?}
                              ?};
                              _loop:=_stop=0 & _TABREK.next()
                           ?};
                           _TAB.cntx_pop()
                        !}
                     ?};
                     _TAB.cntx_pop();
                     {? _stop=0 & _ilosc<:il_rec
                     ||
                        _loop:=
                           {? _idputod=''
                           || _SYNCREK.first()
                           || _TABREK.first()
                                 |
                              _SYNCREK.find_ge(_idputod,_idaddod) & (_SYNCREK.IDPUT>_idputod | _SYNCREK.IDADD>_idaddod)
                           ?}
                     ?};
                     obj_del(_TABREK);
                     obj_del(_SYNCREK)
                  !}
               ?}
            ?};
            obj_del(_TAB);
            _loop:=_ilosc<:il_rec & _Tab.next()
         !};
#
# koniec iteracji po tabelach z uwzględnieniem zapisów pomocniczych w SYNC
#
         SYNC_DEF.cntx_pop()
      ?};
# odpisanie IDPUT - dla tabel, które są zwracane w wyniku
      _loop:=_Tab_idp.first();
      {!
      |? _loop
      |!
         SYNCNIDP.index('FREP_ACR');
         SYNCNIDP.prefix(:fir,_pd,_repl,_Tab_idp.ACR,);
         {? SYNCNIDP.first()
         || _put:=0;
            {? SYNCNIDP.IDPUTMP<_Tab_idp.IDPUT || _put+=1; SYNCNIDP.IDPUTMP:=_Tab_idp.IDPUT ?};
            {? SYNCNIDP.IDADDTMP<_Tab_idp.IDADD || _put+=1; SYNCNIDP.IDADDTMP:=_Tab_idp.IDADD ?};
            {? _put || SYNCNIDP.put() ?}
         ?};
         _loop:=_Tab_idp.next()
      !};
# odpisanie IDPUT - dla tabel, które nie są zwracane w wyniku
      _loop:=_Tab.first();
      {!
      |? _loop
      |!
         {? _Tab.DEL=0 & ~_Tab_idp.find_key(_Tab.ACR,)
         ||
            SYNCNIDP.index('FREP_ACR');
            SYNCNIDP.prefix(:fir,_pd,_repl,_Tab.ACR,);
            {? SYNCNIDP.first()
            || _put:=0;
               {? SYNCNIDP.IDPUTMP<_Tab.IDPUTOD
               || _put+=1;
                  SYNCNIDP.IDPUTMP:=_Tab.IDPUTOD;
                  SYNCNIDP.IDPUT:=SYNCNIDP.IDPUTMP
               ?};
               {? SYNCNIDP.IDADDTMP<_Tab.IDADDOD
               || _put+=1;
                  SYNCNIDP.IDADDTMP:=_Tab.IDADDOD;
                  SYNCNIDP.IDADDOD:=SYNCNIDP.IDADDTMP
               ?};
               {? _put || SYNCNIDP.put() ?}
            ?}
         ?};
         _loop:=_Tab.next()
      !};
      SYNCNIDP.cntx_pop();
      unlock_r();
# pobranie reszty danych dotychczasową procedurą
      :RS.prefix();
      _size:=:RS.size();
      :il_rec:=:il_rec-_size;
      {? :il_rec>=0
      ||
         _SYNC:=
            {? :tab=''
            || proc_exec('sync@synchro',:pd,:il_rec,:fir,:repl)
            || proc_exec('sync_sql@synchro',:pd,:tab,:il_rec,:fir,:repl)
            ?};
         _loop:=_SYNC.first();
         {!
         |? _loop
         |!
            :RS.blank();
            :RS.TR1:=_SYNC.TR1;
            :RS.TR2:=_SYNC.TR2;
            :RS.TR3:=_SYNC.TR3;
            :RS.TR4:=_SYNC.TR4;
            :RS.TR5:=_SYNC.TR5;
            :RS.TR6:=_SYNC.TR6;
            :RS.TR7:=_SYNC.TR7;
            :RS.TR8:=_SYNC.TR8;
            :RS.TR9:=_SYNC.TR9;
            :RS.TR10:=_SYNC.TR10;
            :RS.TR:=_SYNC.TR;
            :RS.ID:=_SYNC.ID;
            :RS.REF:=_SYNC.REF;
            :RS.ACR:=_SYNC.ACR;
            :RS.RODZ:=_SYNC.RODZ;
            :RS.FIRMA:=_SYNC.FIRMA;
            :RS.LP:=_SYNC.LP;
            :RS.STATUS:=_SYNC.STATUS;
            :RS.R_IDADD:=_SYNC.R_IDADD;
            :RS.R_IDPUT:='';
            :RS.IDSYNC:=_idsync;
# dopisanie do :RS
            :RS.add();
            _loop:=_SYNC.next()
         !}
      ?}
   ?}
end formula

end proc

#Sign Version 2.0 jowisz:1045 2024/02/06 19:59:18 bf77f6491aba1ebbb4550cdfefdda69096bf44d8db9680ff92bbc3c8da382b006e252bea7ad0663f5886bdfb2aa6032fd7b40edc13fea49a35ad2350128b459288b1b307789eabe1672836972e4c491145e7ea6a4cc7e50a38a9e899b1dd73924bc3b1304927deb16eaf77a5a7c9d1880d4a6cd1df66878a35e546a06f8602dc
