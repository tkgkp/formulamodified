:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#========================================================================================================================
# Nazwa pliku: po_fins.prc [2011]
# Utworzony: 21.07.2010
# Autor: WH
# Systemy: PROD
#========================================================================================================================
# Zawartosc: Procedury do obslugi kalendarzy dla planowania w javie
#========================================================================================================================

proc getcal

desc
   Zwraca wpisy kalendarza w zadanym okresie
end desc

params
   REF_KAL:=''    STRING[16], Ref SQL kalendarza
   STARTD         DATE,       Data startu
   ENDD           DATE,       Data konca
end params

sql
   select
/*1*/    TO_DATE('2007/04/25') as STARTD,
/*2*/    TO_DATE('2007/04/25') as ENDD,
/*3*/    TO_TIME('0:0:0') as STARTT,
/*4*/    TO_TIME('0:0:0') as ENDT,
/*5*/    ' ' as TYP,
/*6*/    '                                   ' as OPIS,
/*7*/    '1234567890123456789' as STRSTART,
/*8*/    '1234567890123456789' as STREND
   from SYSLOG
   where 0=1
   order by STARTD,STARTT
end sql

formula
   :RS.cntx_psh();
   _ndx:=:RS.ndx_tmp(,,'ENDD',,);
   :RS.index(_ndx);
   KAL_NAZW.cntx_psh();
   KAL_DEF.cntx_psh();
   KAL_DEF.index('KAL_DATA');
   KAL_NAZW.clear();
   {? KAL_NAZW.seek(:REF_KAL)
   ||
      _tm_start:=tm_stamp(:STARTD~1
                          ,:STARTD~2
                          ,:STARTD~3
                          ,0
                          ,0
                          ,0);
      _tm_end:=tm_stamp(:ENDD~1
                       ,:ENDD~2
                       ,:ENDD~3
                       ,0
                       ,0
                       ,0);

      _rule:=" _rs:=_a;

               _result:=1;
               _can_continue:=1;
               _kal_duration:=KAL_DEF.TM_END-KAL_DEF.TM_START;

#              KAL_DEFa z zerowa dlugoscia zawsze dodaje - to jest tzw kal_def weekendowy, swiateczny, jego musze dodac
               {? _kal_duration=0
               || _can_continue:=1
               ||

#                 Musze zrobic prefiks - sprawdzic czy juz w tym dniu konczyl sie kaldef -
#                 jezeli sprawdzenia nie bedzie to przypadek przejscia z trzeciej zmiany na druga
#                 w jednym dniu zwroci dwa kal_defy co jest nieprawidlowe
                  _rs.prefix(KAL_DEF.DATAW);

                  {? _rs.first()
                  ||
                     {!
                     |?
#                       Sprawdzam czy ten juz dodany ma dlugosc wieksza od zera - zerowe w niczym nie przeszkadzaja
                        _rs_duration:=0;
                        _start:=exec('create','#tm_stamp',_rs.STARTD,_rs.STARTT);
                        _end:=exec('create','#tm_stamp',_rs.ENDD,_rs.ENDT);
                        _rs_duration:=_end-_start;
                        {? _rs_duration>0
                        || _can_continue:=0
                        ?};
                        _rs.next() & _can_continue>0
                     !}
                  ||
                     _can_continue:=1
                  ?}
               ?};
               {? _can_continue>0
               ||
                  _rs.cntx_psh();
                  _rs.clear();
                  _rs.blank();
                  _rs.STARTD:=KAL_DEF.DATA;
                  _rs.STARTT:=KAL_DEF.POCZATEK;
                  _rs.ENDD:=KAL_DEF.DATAW;
                  _rs.ENDT:=KAL_DEF.KONIEC;
                  _rs.TYP:=KAL_DEF.TYP;
                  _rs.OPIS:=KAL_DEF.OPIS;
                  _rs.STRSTART:=exec('to_string','#tm_stamp',KAL_DEF.TM_START);
                  _rs.STREND:=exec('to_string','#tm_stamp',KAL_DEF.TM_END);
                  _result:=_rs.add();
                  _rs.cntx_pop()
               ?};
               _result
      ";

      exec('rule4kaldef','po_plan',KAL_NAZW.ref(),_tm_start,_tm_end,_rule,0,:RS);
      ~~
   ?};
   KAL_DEF.cntx_pop();
   KAL_NAZW.cntx_pop();
   :RS.cntx_pop();
   ~~
end formula

end proc


proc cal4view

desc
   Zwraca wpisy kalendarza dla wszystkich zasobow danego widoku w zadanym okresie
end desc

params
   PL_WZOR:=''    String[16], Widok planu
   STARTD         DATE,       Data startu
   ENDD           DATE,       Data konca
end params

sql
   select
/*1*/    TO_DATE('2007/04/25') as STARTD,
/*2*/    TO_DATE('2007/04/25') as ENDD,
/*3*/    TO_TIME('0:0:0') as STARTT,
/*4*/    TO_TIME('0:0:0') as ENDT,
/*5*/    ' ' as TYP,
/*6*/    '                                   ' as OPIS,
/*7*/    '1234567890123456789' as STRSTART,
/*8*/    '1234567890123456789' as STREND,
/*9*/    '1234567890123456' as PLRES
   from SYSLOG
   where 0=1
   order by STARTD,STARTT
end sql

formula
   :RS.cntx_psh();
   _ndx:=:RS.ndx_tmp(,,'PLRES',,,'ENDD',,);
   _ndx2:=:RS.ndx_tmp(,,'PLRES',,,'STARTD',,);
   :RS.index(_ndx);
   KAL_NAZW.cntx_psh(); KAL_NAZW.clear();
   PL_RES.cntx_psh();
   PL_OPIS.cntx_psh();
   _ok:=0;
   _pl_wzor:=exec('FindAndGet','#table',PL_WZOR,:PL_WZOR,,,null());
   PL_OPIS.index('PL_OPIS');
   PL_OPIS.prefix(_pl_wzor);
   {? PL_OPIS.first()
   ||
      _args:=obj_new('RS','PLRES','NDX1','NDX2');
      _args.RS:=:RS;
      _args.NDX1:=_ndx;
      _args.NDX2:=_ndx2;
      {!
      |? {? PL_OPIS.PL_RES<>null()
         || :RS.blank();
            _kal_nazw:=null();
#           Podczytuje PL_RESa
            PL_OPIS.PL_RES();

            _kal_nazw:=PL_RES.KAL_NAZW;
            {? KAL_NAZW.seek(_kal_nazw)
            ||
              _tm_start:=tm_stamp(:STARTD~1
                          ,:STARTD~2
                          ,:STARTD~3
                          ,0
                          ,0
                          ,0);
               _tm_end:=tm_stamp(:ENDD~1
                                ,:ENDD~2
                                ,:ENDD~3
                                ,0
                                ,0
                                ,0);

               _args.PLRES:=$PL_RES.ref();

               _rule:=" _rs:=_a.RS;
                        _plres:=_a.PLRES;
                        _ndx2:=_a.NDX2;
                        _result:=1;
                        _can_continue:=1;
                        _kal_duration:=KAL_DEF.TM_END-KAL_DEF.TM_START;

#                       KAL_DEFa z zerowa dlugoscia zawsze dodaje - to jest tzw kal_def weekendowy, swiateczny, jego musze dodac
                        {? _kal_duration=0
                        || _can_continue:=1
                        ||

#                             Kontrola konfliktów - nie dopuszczamy żeby dwa KAL_DEFy się zazębiały ze sobą
                           _rs.prefix(_plres,KAL_DEF.DATAW);
                           {? _rs.first()
                           ||
                              {!
                              |?
#                                Sprawdzam czy ten juz dodany ma dlugosc wieksza od zera - zerowe w niczym nie przeszkadzaja
                                    _can_continue:=exec('kaldef_conflict','po_plan',_rs);
                                 _rs.next() & _can_continue>0
                              !}
                           ||
                              _can_continue:=1
                           ?};

                           _rs.cntx_psh();
                           _rs.index(_ndx2);
                           _rs.prefix(_plres,KAL_DEF.DATA);
                           {? _rs.first()
                           ||
                              {!
                              |?
                                 _next:=0;
                                 _ref_nxt:=null();
                                 _rs.cntx_psh();
                                 {? _rs.next()
                                 || _ref_nxt:=_rs.ref()
                                 ?};
                                 _rs.cntx_pop();

                                 {? KAL_DEF.ROK().NAZWA().CZESC='T'
                                 ||
#                                   KAL_DEF z kalendarza czesciowego przykrywa mi inne KAL_DEFY z kalendarza
#                                   nieczesciowego (to jest przypadek odstepstwa od kalendarza)
                                    _rs.del();
                                    _can_continue:=1
                                 ?};

                                 {? _ref_nxt<>null()
                                 || _next:=_rs.seek(_ref_nxt)
                                 ?};
                                 _next>0 & _can_continue>0
                              !}
                           ?};

#                             Kontrola konfliktów - nie dopuszczamy żeby dwa KAL_DEFy się zazębiały ze sobą
                              _rs.index(_ndx2);
                              _rs.prefix(_plres,KAL_DEF.DATA);
                              {? _rs.first()
                              || {!
                                 |? _can_continue:=exec('kaldef_conflict','po_plan',_rs);
                                    _rs.next() & _can_continue>0
                                 !}
                              ?};
                           _rs.cntx_pop()
                        ?};
                        {? _can_continue>0
                        ||
                           _rs.cntx_psh();
                           _rs.clear();
                           _rs.blank();
                           _rs.STARTD:=KAL_DEF.DATA;
                           _rs.STARTT:=KAL_DEF.POCZATEK;
                           _rs.ENDD:=KAL_DEF.DATAW;
                           _rs.ENDT:=KAL_DEF.KONIEC;
                           _rs.TYP:=KAL_DEF.TYP;
                           _rs.OPIS:=KAL_DEF.OPIS;
                           _rs.STRSTART:=exec('to_string','#tm_stamp',KAL_DEF.TM_START);
                           _rs.STREND:=exec('to_string','#tm_stamp',KAL_DEF.TM_END);
                           _rs.PLRES:=_plres;
                           _result:=_rs.add();
                           _rs.cntx_pop()
                        ?};
                        _result
               ";

               exec('rule4kaldef','po_plan',KAL_NAZW.ref(),_tm_start,_tm_end,_rule,0,_args);
               ~~
            ?}
         ?};
         PL_OPIS.next()
      !}
   ?};
   PL_OPIS.cntx_pop();
   PL_RES.cntx_pop();
   KAL_NAZW.cntx_pop();
   :RS.cntx_pop();
   ~~
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 a12b98cc42920eb87359b9d1349973a96471ba66eae64716bd772e1a54229256f84ac8eb47e16e52e89ce5cbe03574001ea69d5e450c34752fa76a027a826b275e720027501d6306d837f921f5d4a891df8a100fcd2640d31883a280801eae2ec6f4d70493f8095a857c3b6f8e68fba20416594489166826eba5c7e8c672670e
