:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: po_ploper.prc [2011]
# Utworzony: 18.03.2010
# Autor: WH
# Systemy: PROD
#=======================================================================================================================
# Zawartosc: Procedury do funkcji planowania w javie, planowanie operacji
#=======================================================================================================================


proc gettech

desc
   Zwraca liste technologii dla zlecenia, zamowienia
end desc

params
   MREF:='' String[16], Ref SQL materialu dla ktorego chce zwrocic technologie
   ZLORZM:='' String[4], Znacznik czy planujemy zlecenie czy zamowienie: ZK_P - zamowienie, ZL - zlecenie
   Z_REF:='' String[16], Ref zlecenia lub pozycji zamowienia ktora jest planowana
end params

sql
   select
      '1234567890123456' as REF,
      '12345678901234567890123456789012345678901234567890' as NRK,
      '123456' as VER,
      '   ' as TYP,
      ' ' as T_Z,                                                /*Technologia zlecenia czy normalna*/
      0 as DEFAULT,
      0 as USED
   from SYSLOG
   where 0=1
end sql

formula
   exec('gettech','po_plan',:RS,:MREF,:ZLORZM,:Z_REF)
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc gettechdefault

desc
   Zwraca domyslna technologie dla zlecenia, zamowienia
end desc

params
   MREF:='' String[16], Ref SQL materialu dla ktorego chce zwrocic technologie
   ZLORZM:='' String[4], Znacznik czy planujemy zlecenie czy zamowienie: ZM - zamowienie, ZL - zlecenie
   Z_REF:='' String[16], Ref zlecenia lub pozycji zamowienia ktora jest planowana
end params

sql
   select
      '1234567890123456' as REF,
      '12345678901234567890123456789012345678901234567890' as NRK,
      '123456' as VER,
      '   ' as TYP,
      ' ' as T_Z,                                                /*Technologia zlecenia czy normalna*/
      0 as DEFAULT,
      0 as USED
   from SYSLOG
   where 0=1
end sql

formula
   exec('gettech','po_plan',:RS,:MREF,:ZLORZM,:Z_REF,1)
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc gettechdata

desc
   Pobiera dane z technologii
end desc

params
   M_REF:=''      STRING[16], Ref SQL materialu dla ktorego chce wyciagnac dane z technologii
   SRC:=''        STRING[16], Ref SQL zrodla z ktorej bede wyciagal dane (TKTL, ZKTL, ZGH)
   IL:=0          REAL, Ilosc na ktora nalezy pobrac dane z technologii
   SRC_TYP:=''    STRING[1], T - dane z TKTL, Z - dane z ZKTL, P - dane z ZGP
   OBJ_REF:=''    STRING[16], Ref SQL planowanego obiektu
   OBJ_TYP:=''    STRING[10], Typ planowanego obiektu - 'ZL_P', 'ZK_P'
   PLPART:=''     STRING[255], Nazwa przewodnika planistycznego do którego dane pobrać
end params

sql
   select
      '                                                                             ' as SYM,    /*Symbol galezi drzewa*/
      ' ' as TYP,                         /*Typ galezi drzewa O - operacja, R - zasob, M - material, W - wydzial, C - calosc*/
      ' ' as COOP,                        /*Znacznik czy zapis dotyczy kooperacji T/N*/
      '                                                                             ' as NAZWA,  /*Nazwa galezi drzewa*/
      '255:255:255' as KOLOR_B,           /*Kolor tla*/
      '0:0:0      ' as KOLOR_T,           /*Kolor tekstu*/
      0 as LEVEL,                         /*Poziom galezi w drzewie*/
      0 as ID,                            /*ID galezi drzewa*/
      0 as PAR,                           /*ID rodzica galezi drzewa*/
      ' ' as BLK,                         /*Znacznik blokady - tutaj nieuzywany*/
      CAST (0 AS REAL_TYPE) as ILOSC,
      CAST (0 AS REAL_TYPE) as DURATION,  /*czas trwania w minutach*/
      CAST (0 AS REAL_TYPE) as OFFSET_P,  /*przesuniecie od poczatku w minutach*/
      CAST (0 AS REAL_TYPE) as OFFSET_O,  /*przesuniecie od ostatniej operacji w minutach*/
      '1234567890123456' as REF_RES,      /*REF SQL PL_RES*/
      ' ' as DEFAULT,                     /*Znacznik T/N - czy stanowisko domyslne w gniezdzie*/
      CAST (0 AS REAL_TYPE) as TP,        /*czas tp operacji w minutach*/
      CAST (0 AS REAL_TYPE) as TZ,        /*czas tz operacji w minutach*/
      ' ' as ALERT,                       /*Znacznik alertu - R - brak zasobu w definicji zasobow*/
      '1234567890123456' as TOPER,        /*SQL Ref operacji na technologii*/
      '1234567890123456' as ZOPER,        /*SQL Ref operacji zlecenia*/
      '1234567890123456' as ZGP,          /*SQL Ref pozycji przewodnika*/
      '1234567890123456' as ZGH,          /*SQL Ref przewodnika*/
      0 as NUM,                           /*Dla operacji - kolejnosc w procesie*/
      '                                                                                                                                                                                                                                                              ' as ID_NEXT,                        /*ID operacji nastepnych separowanych znakiem ;, lub -1; jesli nie ma nastepnej*/
      '1234567890123456789' as TM_REQ_S,  /*Zadany start operacji, poprzednia operacja nie moze sie skonczyc pozniej*/
      '1234567890123456789' as TM_REQ_E,  /*Zadany koniec operacji, nastepna operacja nie moze sie zaczac wczesniej*/
      '1234567890123456789' as TM_MIN,    /*Minimalny start operacji*/
      '1234567890123456789' as TM_MAX,    /*Maksymalny koniec operacji*/
      '                                                                         ' as SYM_MIN, /*Symbol granicy czasowej*/
      '                                                                         ' as SYM_MAX, /*Symbol granicy czasowej*/
      ' ' as IN_GROP,
      '1234567890123456' as GR_STA_R,     /*REF SQL najwczesniej zaplanowanej grupy operacji do ktorej nalezy dana operacja*/
      '1234567890123456' as GR_END_R,     /*REF SQL najpozniej zaplanowanej grupy operacji do ktorej nalezy dana operacja*/
      '                                                                                ' as GR_STA_S, /*Symbol grupy najwczesniej zaplanowaniej*/
      '                                                                                ' as GR_END_S,  /*Symbol grupy najpozniej zaplanowanej*/
      '                                                                                                    ' as INFO1, /*Linia 1 na wyświetlanej utworzonej pozycji planu*/
      '                                                                                                    ' as INFO2, /*Linia 2 na wyświetlanej utworzonej pozycji planu*/
      '                                                                                                    ' as INFO3, /*Linia 3 na wyświetlanej utworzonej pozycji planu*/
      '                                                                                                    ' as PLO_SYM, /*Symbol plopera który zostanie zapisany w bazie*/
      '                                                                                                    ' as PLO_OPIS, /*Opis plopera który zostanie zapisany w bazie*/
      '255:255:255' as KOLOR_TO,
      '255:255:255' as KOLOR_M,
      '255:255:255' as KOLOR_G,
      0 as ZAM,
      ' ' as LIMITY,
      ' ' as NPU,
      SPACE(60) as KTM,
      CAST (0 AS REAL_TYPE) as TPDEF,
      CAST (0 AS REAL_TYPE) as TZDEF
   from SYSLOG
   where 0=1
   order by LEVEL,NUM
end sql

formula
   exec('gettechdata','po_plan',:RS,:SRC_TYP,:M_REF,:SRC,:IL,:OBJ_REF,:OBJ_TYP,:PLPART)
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_plparts

desc
   Zwraca plparts w podanym zakresie
end desc

params
   START    STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END      STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
end params

sql
   select
/*--------------TreeNodeMBase.java*/
/*1*/    '                                         ' as SYM,
/*2*/    '     ' as TYP,
/*3*/    '                                                                  ' as NAZWA,
/*4*/    '255:255:255' as KOLOR_B,
/*5*/    '0:0:0      ' as KOLOR_T,
/*6*/    0 as LEVEL,
/*7*/    0 as ID,
/*8*/    0 as PAR,
/*9*/    ' ' as BLK,
/*10*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*--------------Plpart.java*/
/*11*/   '1234567890123456' as REF,
/*12*/   '1234567890123456' as REF_ZL,
/*13*/   '1234567890123456' as REF_ZKP,
/*14*/   '1234567890123456' as REF_TKTL,
/*15*/   '1234567890123456' as REF_ZKTL,
/*16*/   '                                                                                          ' as SYM_ZL,
/*17*/   '                                                                                          ' as SYM_ZK,
/*18*/   '1234567890123456' as REF_ZGH,
/*19*/   '1234567890123456789' as PL_START,
/*20*/   '1234567890123456789' as PL_END,
/*21*/   TO_DATE('2007/04/25') as STARTD,
/*22*/    TO_DATE('2007/04/25') as ENDD,
/*23*/    TO_TIME('0:0:0') as STARTT,
/*24*/    TO_TIME('0:0:0') as ENDT,
/*25*/   '1234567890123456789' as REF_M,
/*26*/   '1234567890123456789' as PX_OBJ,
/*27*/   '1234567890123456789' as REF_TOP,
/*28*/   '                                                                                          ' as SYM_TOP,
/*29*/   '                                                  ' as KTM,
/*30*/   '                                                                                                    ' as KTM_NAZ,
/*31*/   '                                                  ' as TKTL_SYM
   from SYSLOG
   where 0=1
end sql

formula
   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   _int_view:=exec('interval','#interval');
   _int_view.START:=_tm_start;
   _int_view.END:=_tm_end;
   M.cntx_psh();
   ZL.cntx_psh();
   ZK_P.cntx_psh();
   ZK_N.cntx_psh();
   PL_PART.cntx_psh();
   PL_PART.index('TM_END');
   PL_PART.clear();
   {? PL_PART.find_ge(_tm_start)
   || {? PL_PART.TM_START<_tm_end
      ||
         _int_rec:=exec('interval','#interval');
         {!
         |?
            _int_rec.START:=PL_PART.TM_START;
            _int_rec.END:=PL_PART.TM_END;

            {? exec('intervals_chk','#interval',_int_rec,_int_view)>0
            ||
               :RS.blank();
               exec('plpart_to_rs','po_plan',:RS);
               :RS.add()
            ?};
            PL_PART.next()
         !}
      ?}
   ?};
   PL_PART.cntx_pop();
   ZK_P.cntx_pop();
   ZK_N.cntx_pop();
   ZL.cntx_pop();
   M.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_z_plparts

desc
   Zwraca plparts dla podanego zamowienia lub zlecenia
end desc

params
   REF_Z:=''     STRING[16], Ref SQL pozycji zamowienia lub zlecenia
   MODE:=''      STRING[2], Tryb pracy - 'ZL' - zlecenia, 'ZM' - zamowienia
end params

sql
   select
/*--------------TreeNodeMBase.java*/
/*1*/    '                                         ' as SYM,
/*2*/    '     ' as TYP,
/*3*/    '                                                                  ' as NAZWA,
/*4*/    '255:255:255' as KOLOR_B,
/*5*/    '0:0:0      ' as KOLOR_T,
/*6*/    0 as LEVEL,
/*7*/    0 as ID,
/*8*/    0 as PAR,
/*9*/    ' ' as BLK,
/*10*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*--------------Plpart.java*/
/*11*/   '1234567890123456' as REF,
/*12*/   '1234567890123456' as REF_ZL,
/*13*/   '1234567890123456' as REF_ZKP,
/*14*/   '1234567890123456' as REF_TKTL,
/*15*/   '1234567890123456' as REF_ZKTL,
/*16*/   '                                                                                          ' as SYM_ZL,
/*17*/   '                                                                                          ' as SYM_ZK,
/*18*/   '1234567890123456' as REF_ZGH,
/*19*/   '1234567890123456789' as PL_START,
/*20*/   '1234567890123456789' as PL_END,
/*21*/   TO_DATE('2007/04/25') as STARTD,
/*22*/    TO_DATE('2007/04/25') as ENDD,
/*23*/    TO_TIME('0:0:0') as STARTT,
/*24*/    TO_TIME('0:0:0') as ENDT,
/*25*/   '1234567890123456789' as REF_M,
/*26*/   '1234567890123456789' as PX_OBJ,
/*27*/   '1234567890123456789' as REF_TOP,
/*28*/   '                                                                                          ' as SYM_TOP,
/*29*/   '                                                  ' as KTM,
/*30*/   '                                                                                                    ' as KTM_NAZ,
/*31*/   '                                                  ' as TKTL_SYM
   from SYSLOG
   where 0=1
end sql

formula
   PL_PART.cntx_psh();
   {? :MODE='ZL'
   || _zl:=exec('FindAndGet','#table',ZL,:REF_Z,,,null());
      PL_PART.index('ZL_START');
      PL_PART.prefix(_zl);
      {? PL_PART.first()
      || {!
         |? :RS.blank();
            exec('plpart_to_rs','po_plan',:RS);
            :RS.add();
            PL_PART.next()
         !}
      ?}
   |? :MODE='ZM'
   || _zkp:=exec('FindAndGet','#table',ZK_P,:REF_Z,,,null());
      PL_PART.index('ZM_START');
      PL_PART.prefix(_zkp);
      {? PL_PART.first()
      || {!
         |? :RS.blank();
            exec('plpart_to_rs','po_plan',:RS);
            :RS.add();
            PL_PART.next()
         !}
      ?}
   ?};
   PL_PART.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_plopers

desc
   Zwraca plopery w podanym zakresie
end desc

params
   START STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END   STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
   TYP   STRING[1],  Typy pobierania ='O' zwykle plopery operacji PL_OPER.TYP='O', <>'O' plopery rezerwacyjne
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLPART,
/*3*/    cast (0 as REAL_TYPE) as DURATION,
/*4*/    TO_DATE('2007/04/25') as STARTD,
/*5*/    TO_DATE('2007/04/25') as ENDD,
/*6*/    TO_TIME('0:0:0') as STARTT,
/*7*/    TO_TIME('0:0:0') as ENDT,
/*8*/    cast (0 as REAL_TYPE) as TP,
/*9*/    cast (0 as REAL_TYPE) as TZ,
/*10*/   '                                                                                          ' as SYMBOL,
/*11*/   '                                                                                          ' as OPIS,
/*12*/   '255:255:255' as KOLOR,
/*13*/   cast (0 as REAL_TYPE) as OFFSET_P,
/*14*/   cast (0 as REAL_TYPE) as OFFSET_O,
/*15*/   cast (0 as REAL_TYPE) as OFFSET_U,
/*16*/   TO_DATE('2007/04/25') as MINDATE,
/*17*/   TO_DATE('2007/04/25') as MAXDATE,
/*18*/   TO_TIME('0:0:0') as MINTIME,
/*19*/   TO_TIME('0:0:0') as MAXTIME,
/*20*/   '                                                                                          ' as WHO_ADD,
/*21*/   '                                                                                          ' as WHO_MOD,
/*22*/   cast (0 as REAL_TYPE) as WYK,
/*23*/   '1234567890123456' as TOPER,
/*24*/   '1234567890123456' as ZOPER,
/*25*/   '1234567890123456' as PLANNED,
/*26*/   '1234567890123456789' as PL_START,
/*27*/   '1234567890123456789' as PL_END,
/*28*/   ' ' as TYP,
/*29*/   0 as MOVEABLE,
/*30*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*31*/   '1234567890123456' as ZGP,
/*32*/   '12345678901234567890' as GROUPKEY,
/*33*/   0 as PREVS,
/*34*/   0 as NEXTS,
/*35*/   '                                              ' as SYM_MIN,
/*36*/   '                                              ' as SYM_MAX,
/*37*/   '1234567890123456789' as TERMIN,
/*38*/   0 as NUM,
/*39*/   '1234567890123456' as PLRES,
/*40*/   '                                                   ' as KTM,
/*41*/   '                                                                                                    ' as INFO1, /*Linia 1 na wyświetlanej utworzonej pozycji planu*/
/*42*/   '                                                                                                    ' as INFO2, /*Linia 2 na wyświetlanej utworzonej pozycji planu*/
/*43*/   '                                                                                                    ' as INFO3, /*Linia 3 na wyświetlanej utworzonej pozycji planu*/
/*44*/   '          ' as JM,
/*45*/   '1234567890123456' as PL_SPLIT,
/*46*/   '255:255:255' as KOLOR_T,
/*47*/   '255:255:255' as KOLOR_M,
/*48*/   '255:255:255' as KOLOR_G,
/*49*/   ' ' as SINGLE,
/*50*/   ' ' as LIMITY,
/*51*/   cast (0 as REAL_TYPE) as IL_NAPR,
/*52*/   ' ' as EVE_BT,
/*53*/   ' ' as EVE_EAT,
/*54*/   cast (0 as REAL_TYPE) as EVE_USE,
/*55*/   '1234567890123456' as PL_EVENR,
/*56*/   '1234567890123456' as PL_EVENT,
/*57*/   ' ' as EVE_TRYB,
/*58*/   ' ' as NPU
   from SYSLOG
   where 0=1

end sql

formula
   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   _int_view:=exec('interval','#interval');
   _int_view.START:=_tm_start;
   _int_view.END:=_tm_end;
   PL_PART.cntx_psh();
   PL_OPER.cntx_psh();
   PL_OPER.index('TM_END');
   PL_OPER.clear();
   {? PL_OPER.find_ge(_tm_start)
   || _int_rec:=exec('interval','#interval');
      {!
      |?
         _ok:=0;
         {? :TYP='O'
         ||
#           Wczytuje rowniez plopery kooperacyjne, aby zbudowac poprawnie relacje miedzy operacjami
            _ok:={? PL_OPER.TYP='O' | PL_OPER.TYP='K' || 1 || 0 ?}
         |? :TYP<>'O'
         || _ok:={? PL_OPER.TYP<>'O' || 1 || 0 ?}
         ?};
         {? _ok>0
         || _int_rec.START:=PL_OPER.TM_START;
            _int_rec.END:=PL_OPER.TM_END;
            {? exec('intervals_chk','#interval',_int_rec,_int_view)>0
            ||
               :RS.blank();
               exec('ploper_to_rs','po_plan',:RS);
               :RS.add()
            ?}
         ?};
         PL_OPER.next()
      !}
   ?};
   PL_OPER.cntx_pop();
   PL_PART.cntx_pop()
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_ploper

desc
   Zwraca podanego plopera
end desc

params
   PL_OPER STRING[16], Ref plopera
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLPART,
/*3*/    cast (0 as REAL_TYPE) as DURATION,
/*4*/    TO_DATE('2007/04/25') as STARTD,
/*5*/    TO_DATE('2007/04/25') as ENDD,
/*6*/    TO_TIME('0:0:0') as STARTT,
/*7*/    TO_TIME('0:0:0') as ENDT,
/*8*/    cast (0 as REAL_TYPE) as TP,
/*9*/    cast (0 as REAL_TYPE) as TZ,
/*10*/   '                                                                                          ' as SYMBOL,
/*11*/   '                                                                                          ' as OPIS,
/*12*/   '255:255:255' as KOLOR,
/*13*/   cast (0 as REAL_TYPE) as OFFSET_P,
/*14*/   cast (0 as REAL_TYPE) as OFFSET_O,
/*15*/   cast (0 as REAL_TYPE) as OFFSET_U,
/*16*/   TO_DATE('2007/04/25') as MINDATE,
/*17*/   TO_DATE('2007/04/25') as MAXDATE,
/*18*/   TO_TIME('0:0:0') as MINTIME,
/*19*/   TO_TIME('0:0:0') as MAXTIME,
/*20*/   '                                                                                          ' as WHO_ADD,
/*21*/   '                                                                                          ' as WHO_MOD,
/*22*/   cast (0 as REAL_TYPE) as WYK,
/*23*/   '1234567890123456' as TOPER,
/*24*/   '1234567890123456' as ZOPER,
/*25*/   '1234567890123456' as PLANNED,
/*26*/   '1234567890123456789' as PL_START,
/*27*/   '1234567890123456789' as PL_END,
/*28*/   ' ' as TYP,
/*29*/   0 as MOVEABLE,
/*30*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*31*/   '1234567890123456' as ZGP,
/*32*/   '12345678901234567890' as GROUPKEY,
/*33*/   0 as PREVS,
/*34*/   0 as NEXTS,
/*35*/   '                                              ' as SYM_MIN,
/*36*/   '                                              ' as SYM_MAX,
/*37*/   '1234567890123456789' as TERMIN,
/*38*/   0 as NUM,
/*39*/   '1234567890123456' as PLRES,
/*40*/   '                                                   ' as KTM,
/*41*/   '                                                                                                    ' as INFO1, /*Linia 1 na wyświetlanej utworzonej pozycji planu*/
/*42*/   '                                                                                                    ' as INFO2, /*Linia 2 na wyświetlanej utworzonej pozycji planu*/
/*43*/   '                                                                                                    ' as INFO3, /*Linia 3 na wyświetlanej utworzonej pozycji planu*/
/*44*/   '          ' as JM,
/*45*/    '1234567890123456' as PL_SPLIT,
/*46*/   '255:255:255' as KOLOR_T,
/*47*/   '255:255:255' as KOLOR_M,
/*48*/   '255:255:255' as KOLOR_G,
/*49*/   ' ' as SINGLE,
/*50*/   ' ' as LIMITY,
/*51*/   cast (0 as REAL_TYPE) as IL_NAPR,
/*52*/   ' ' as EVE_BT,
/*53*/   ' ' as EVE_EAT,
/*54*/   cast (0 as REAL_TYPE) as EVE_USE,
/*55*/   '1234567890123456' as PL_EVENR,
/*56*/   '1234567890123456' as PL_EVENT,
/*57*/   ' ' as EVE_TRYB,
/*58*/   ' ' as NPU
   from SYSLOG
   where 0=1

end sql

formula
   PL_OPER.cntx_psh();
   PL_OPER.clear();
   {? PL_OPER.seek(:PL_OPER)
   || :RS.blank();
      exec('ploper_to_rs','po_plan',:RS);
      :RS.add()
   ?};
   PL_OPER.cntx_pop()
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_part_plopers

desc
   Zwraca plopery dla podanego plparta lu pleventa
end desc

params
   WHAT:='' STRING[16], Ref SQL plparta lub pleventa
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLPART,
/*3*/    cast (0 as REAL_TYPE) as DURATION,
/*4*/    TO_DATE('2007/04/25') as STARTD,
/*5*/    TO_DATE('2007/04/25') as ENDD,
/*6*/    TO_TIME('0:0:0') as STARTT,
/*7*/    TO_TIME('0:0:0') as ENDT,
/*8*/    cast (0 as REAL_TYPE) as TP,
/*9*/    cast (0 as REAL_TYPE) as TZ,
/*10*/   '                                                                                          ' as SYMBOL,
/*11*/   '                                                                                          ' as OPIS,
/*12*/   '255:255:255' as KOLOR,
/*13*/   cast (0 as REAL_TYPE) as OFFSET_P,
/*14*/   cast (0 as REAL_TYPE) as OFFSET_O,
/*15*/   cast (0 as REAL_TYPE) as OFFSET_U,
/*16*/   TO_DATE('2007/04/25') as MINDATE,
/*17*/   TO_DATE('2007/04/25') as MAXDATE,
/*18*/   TO_TIME('0:0:0') as MINTIME,
/*19*/   TO_TIME('0:0:0') as MAXTIME,
/*20*/   '                                                                                          ' as WHO_ADD,
/*21*/   '                                                                                          ' as WHO_MOD,
/*22*/   cast (0 as REAL_TYPE) as WYK,
/*23*/   '1234567890123456' as TOPER,
/*24*/   '1234567890123456' as ZOPER,
/*25*/   '1234567890123456' as PLANNED,
/*26*/   '1234567890123456789' as PL_START,
/*27*/   '1234567890123456789' as PL_END,
/*28*/   ' ' as TYP,
/*29*/   0 as MOVEABLE,
/*30*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*31*/   '1234567890123456' as ZGP,
/*32*/   '12345678901234567890' as GROUPKEY,
/*33*/   0 as PREVS,
/*34*/   0 as NEXTS,
/*35*/   '                                              ' as SYM_MIN,
/*36*/   '                                              ' as SYM_MAX,
/*37*/   '1234567890123456789' as TERMIN,
/*38*/   0 as NUM,
/*39*/   '123456789012346' as PLRES,
/*40*/   '                                                   ' as KTM,
/*41*/   '                                                                                                    ' as INFO1, /*Linia 1 na wyświetlanej utworzonej pozycji planu*/
/*42*/   '                                                                                                    ' as INFO2, /*Linia 2 na wyświetlanej utworzonej pozycji planu*/
/*43*/   '                                                                                                    ' as INFO3, /*Linia 3 na wyświetlanej utworzonej pozycji planu*/
/*44*/   '          ' as JM,
/*45*/    '1234567890123456' as PL_SPLIT,
/*46*/   '255:255:255' as KOLOR_T,
/*47*/   '255:255:255' as KOLOR_M,
/*48*/   '255:255:255' as KOLOR_G,
/*49*/   ' ' as SINGLE,
/*50*/   ' ' as LIMITY,
/*51*/   cast (0 as REAL_TYPE) as IL_NAPR,
/*52*/   ' ' as EVE_BT,
/*53*/   ' ' as EVE_EAT,
/*54*/   cast (0 as REAL_TYPE) as EVE_USE,
/*55*/   '1234567890123456' as PL_EVENR,
/*56*/   '1234567890123456' as PL_EVENT,
/*57*/   ' ' as EVE_TRYB,
/*58*/   ' ' as NPU
   from SYSLOG
   where 0=1

end sql

formula
   PL_EVENT.cntx_psh();
   PL_EVENR.cntx_psh();
   PL_EVENR.index('PL_EVENT');
   PL_PART.cntx_psh();
   PL_OPER.cntx_psh();

   _ttab:=ref_tab(:WHAT);
   {? type_of(_ttab)>0 & _ttab=PL_PART
   || PL_OPER.index('PL_PART');
      PL_PART.clear();
      {? PL_PART.seek(:WHAT)
      || PL_OPER.prefix(PL_PART.ref());
         {? PL_OPER.first()
         || {!
            |? :RS.blank();
               exec('ploper_to_rs','po_plan',:RS);
               :RS.add();
               PL_OPER.next()
            !}
         ?}
      ?}
   |? type_of(_ttab)>0 & _ttab=PL_EVENT
   || PL_OPER.index('PL_EVE1');
      PL_EVENT.clear();
      {? PL_EVENT.seek(:WHAT)
      ||
         PL_EVENR.prefix(PL_EVENT.ref());
         {? PL_EVENR.first()
         || {!
            |?
               PL_OPER.prefix(PL_EVENR.ref());
               {? PL_OPER.first()
               || {!
                  |? :RS.blank();
                     exec('ploper_to_rs','po_plan',:RS);
                     :RS.add();
                     PL_OPER.next()
                  !}
               ?};
               PL_EVENR.next()
            !}
         ?}
      ?}
   ?};
   PL_EVENR.cntx_pop();
   PL_EVENT.cntx_pop();
   PL_OPER.cntx_pop();
   PL_PART.cntx_pop()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc get_spli_plopers

desc
   Zwraca plopery dla podanego podziału
end desc

params
   PL_SPLIT:='' STRING[16], Ref SQL podziału
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLPART,
/*3*/    cast (0 as REAL_TYPE) as DURATION,
/*4*/    TO_DATE('2007/04/25') as STARTD,
/*5*/    TO_DATE('2007/04/25') as ENDD,
/*6*/    TO_TIME('0:0:0') as STARTT,
/*7*/    TO_TIME('0:0:0') as ENDT,
/*8*/    cast (0 as REAL_TYPE) as TP,
/*9*/    cast (0 as REAL_TYPE) as TZ,
/*10*/   '                                                                                          ' as SYMBOL,
/*11*/   '                                                                                          ' as OPIS,
/*12*/   '255:255:255' as KOLOR,
/*13*/   cast (0 as REAL_TYPE) as OFFSET_P,
/*14*/   cast (0 as REAL_TYPE) as OFFSET_O,
/*15*/   cast (0 as REAL_TYPE) as OFFSET_U,
/*16*/   TO_DATE('2007/04/25') as MINDATE,
/*17*/   TO_DATE('2007/04/25') as MAXDATE,
/*18*/   TO_TIME('0:0:0') as MINTIME,
/*19*/   TO_TIME('0:0:0') as MAXTIME,
/*20*/   '                                                                                          ' as WHO_ADD,
/*21*/   '                                                                                          ' as WHO_MOD,
/*22*/   cast (0 as REAL_TYPE) as WYK,
/*23*/   '1234567890123456' as TOPER,
/*24*/   '1234567890123456' as ZOPER,
/*25*/   '1234567890123456' as PLANNED,
/*26*/   '1234567890123456789' as PL_START,
/*27*/   '1234567890123456789' as PL_END,
/*28*/   ' ' as TYP,
/*29*/   0 as MOVEABLE,
/*30*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*31*/   '1234567890123456' as ZGP,
/*32*/   '12345678901234567890' as GROUPKEY,
/*33*/   0 as PREVS,
/*34*/   0 as NEXTS,
/*35*/   '                                              ' as SYM_MIN,
/*36*/   '                                              ' as SYM_MAX,
/*37*/   '1234567890123456789' as TERMIN,
/*38*/   0 as NUM,
/*39*/   '123456789012346' as PLRES,
/*40*/   '                                                   ' as KTM,
/*41*/   '                                                                                                    ' as INFO1, /*Linia 1 na wyświetlanej utworzonej pozycji planu*/
/*42*/   '                                                                                                    ' as INFO2, /*Linia 2 na wyświetlanej utworzonej pozycji planu*/
/*43*/   '                                                                                                    ' as INFO3, /*Linia 3 na wyświetlanej utworzonej pozycji planu*/
/*44*/   '          ' as JM,
/*45*/    '1234567890123456' as PL_SPLIT,
/*46*/   '255:255:255' as KOLOR_T,
/*47*/   '255:255:255' as KOLOR_M,
/*48*/   '255:255:255' as KOLOR_G,
/*49*/   ' ' as SINGLE,
/*50*/   ' ' as LIMITY,
/*51*/   cast (0 as REAL_TYPE) as IL_NAPR,
/*52*/   ' ' as EVE_BT,
/*53*/   ' ' as EVE_EAT,
/*54*/   cast (0 as REAL_TYPE) as EVE_USE,
/*55*/   '1234567890123456' as PL_EVENR,
/*56*/   '1234567890123456' as PL_EVENT,
/*57*/   ' ' as EVE_TRYB,
/*58*/   ' ' as NPU
   from SYSLOG
   where 0=1

end sql

formula
   PL_SPLIT.cntx_psh();
   PL_OPER.cntx_psh();
   PL_OPER.index('PL_SPLIT');
   PL_SPLIT.clear();
   PL_OPER.clear();
   {? PL_SPLIT.seek(:PL_SPLIT)
   ||
      _tab:=exec('merge_list','po_split');
      _tab.clear();
      {? _tab.first()
      || {!
         |? {? PL_OPER.seek(_tab.PL_OPER)
            || :RS.blank();
               exec('ploper_to_rs','po_plan',:RS);
               :RS.add()
            ?};
            _tab.next()
         !}
      ?}
   ?};
   PL_OPER.cntx_pop();
   PL_SPLIT.cntx_pop()
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_plozy

desc
   Zwraca plozy w podanym zakresie
end desc

params
   START    STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END      STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
   TYP      STRING[1],  Typy pobierania ='O' zwykle plopery operacji PL_OPER.TYP='O', <>'O' plopery rezerwacyjne
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLOPER,
/*3*/    '1234567890123456' as PLRES,
/*4*/    '                                                                             ' as PLRESSYM,
/*5*/    '                                                                             ' as PLRESNAZ,
/*6*/    '1234567890123456' as PLPART,
/*7*/    ' ' as WYKFORCE,
/*8*/    SPACE(255) as KONFPLUG
   from SYSLOG
   where 0=1
end sql

formula
   PL_OZ.cntx_psh();
   PL_OPER.cntx_psh();
   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   _int_view:=exec('interval','#interval');
   _int_view.START:=_tm_start;
   _int_view.END:=_tm_end;
   PL_OZ.index('TM_END');
   PL_OZ.clear();
   {? PL_OZ.find_ge(_tm_start)
   ||
      {? PL_OZ.TM_START<_tm_end
      || _int_rec:=exec('interval','#interval');
         {!
         |? _ok:=0;
            {? :TYP='O'
            || _ok:={? PL_OZ.PL_OPER().TYP='O' || 1 || 0 ?}
            |? :TYP<>'O'
            || _ok:={? PL_OZ.PL_OPER().TYP<>'O' || 1 || 0 ?}
            ?};
            {? _ok>0
            || _int_rec.START:=PL_OZ.TM_START;
               _int_rec.END:=PL_OZ.TM_END;
               {? exec('intervals_chk','#interval',_int_rec,_int_view)>0
               || :RS.blank();
                  exec('ploz_to_rs','po_plan',:RS);
                  :RS.add()
               ?}
            ?};
            PL_OZ.next()
         !}
      ?}
   ?};

   PL_OPER.cntx_pop();
   PL_OZ.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_plpart_plozy

desc
   Zwraca plozy danego plparta lub pleventa
end desc

params
   WHAT:='' STRING[16], Ref SQL plparta lub pleventa
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLOPER,
/*3*/    '1234567890123456' as PLRES,
/*4*/    '                                                                             ' as PLRESSYM,
/*5*/    '                                                                             ' as PLRESNAZ,
/*6*/    '1234567890123456' as PLPART,
/*7*/    ' ' as WYKFORCE,
/*8*/    SPACE(255) as KONFPLUG
   from SYSLOG
   where 0=1
end sql

formula
   PL_EVENR.cntx_psh();
   PL_EVENR.index('PL_EVENT');
   PL_EVENT.cntx_psh();
   PL_OPER.cntx_psh();
   PL_OZ.cntx_psh();
   PL_PART.cntx_psh();
   PL_OZ.index('PL_OPER');

   _tab:=ref_tab(:WHAT);
   {? type_of(_tab)>0 & _tab=PL_PART
   ||
      PL_OPER.index('PL_PART');
      PL_PART.clear();
      {? PL_PART.seek(:WHAT)
      || PL_OPER.prefix(PL_PART.ref());
         {? PL_OPER.first()
         || {!
            |? PL_OZ.prefix(PL_OPER.ref());
               {? PL_OZ.first()
               || {!
                  |? :RS.blank();
                     exec('ploz_to_rs','po_plan',:RS);
                     :RS.add();
                     PL_OZ.next()
                  !}
               ?};
               PL_OPER.next()
            !}
         ?}
      ?}
   |? type_of(_tab)>0 & _tab=PL_EVENT
   || PL_OPER.index('PL_EVE1');
      PL_EVENT.clear();
      {? PL_EVENT.seek(:WHAT)
      ||
         PL_EVENR.prefix(PL_EVENT.ref());
         {? PL_EVENR.first()
         || {!
            |?
               PL_OPER.prefix(PL_EVENR.ref());
               {? PL_OPER.first()
               || {!
                  |? PL_OZ.prefix(PL_OPER.ref());
                     {? PL_OZ.first()
                     || {!
                        |? :RS.blank();
                           exec('ploz_to_rs','po_plan',:RS);
                           :RS.add();
                           PL_OZ.next()
                        !}
                     ?};
                     PL_OPER.next()
                  !}
               ?};
               PL_EVENR.next()
            !}
         ?}
      ?}
   ?};
   PL_OZ.cntx_pop();
   PL_OPER.cntx_pop();
   PL_PART.cntx_pop();
   PL_EVENR.cntx_pop();
   PL_EVENT.cntx_pop()
end formula

end proc


proc get_split_plozy

desc
   Zwraca plozy danego podziału
end desc

params
   PL_SPLIT:='' STRING[16], Ref SQL podziału
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLOPER,
/*3*/    '1234567890123456' as PLRES,
/*4*/    '                                                                             ' as PLRESSYM,
/*5*/    '                                                                             ' as PLRESNAZ,
/*6*/    '1234567890123456' as PLPART,
/*7*/    ' ' as WYKFORCE,
/*8*/    SPACE(255) as KONFPLUG
   from SYSLOG
   where 0=1
end sql

formula
   PL_OPER.cntx_psh();
   PL_OZ.cntx_psh();
   PL_SPLIT.cntx_psh();
   PL_OZ.index('PL_OPER');
   PL_OPER.index('PL_SPLI2');
   PL_SPLIT.clear();
   {? PL_SPLIT.seek(:PL_SPLIT)
   || PL_OPER.prefix(PL_SPLIT.ref());
      {? PL_OPER.first()
      || {!
         |? PL_OZ.prefix(PL_OPER.ref());
            {? PL_OZ.first()
            || {!
               |? :RS.blank();
                  exec('ploz_to_rs','po_plan',:RS);
                  :RS.add();
                  PL_OZ.next()
               !}
            ?};
            PL_OPER.next()
         !}
      ?}
   ?};
   PL_OZ.cntx_pop();
   PL_OPER.cntx_pop();
   PL_SPLIT.cntx_pop()
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_plnexts

desc
   Zwraca nastepniki planu w podanym zakresie
end desc

params
   START    STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END      STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PL_OPER,
/*3*/    '1234567890123456' as NEXT_OPE,
/*4*/    '1234567890123456' as PL_OGR,
/*5*/    '1234567890123456' as NEXT_OGR
   from SYSLOG
   where 0=1
end sql

formula
   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   _int_view:=exec('interval','#interval');
   _int_view.START:=_tm_start;
   _int_view.END:=_tm_end;

   PL_OPER.cntx_psh();
   PL_NEXT.cntx_psh();
   PL_NEXT.index('TM_END');
   {? PL_NEXT.find_ge(_tm_start)
   ||
      {? PL_NEXT.TM_START<_tm_end
      ||
         _int_rec:=exec('interval','#interval');
         {!
         |? _int_rec.START:=PL_NEXT.TM_START;
            _int_rec.END:=PL_NEXT.TM_END;
            {? exec('intervals_chk','#interval',_int_rec,_int_view)>0
            || :RS.blank();
               :RS.REF:=$PL_NEXT.ref();
               :RS.PL_OPER:=$PL_NEXT.PL_OPER;
               :RS.NEXT_OPE:=$PL_NEXT.NEXT;
               :RS.PL_OGR:=$PL_NEXT.PL_OGR;
               :RS.NEXT_OGR:=$PL_NEXT.NEXT_OGR;
               :RS.add()
            ?};
            PL_NEXT.next()
         !}
      ?}
   ?};
   PL_NEXT.cntx_pop();
   PL_OPER.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_part_nexts

desc
   Zwraca nastepniki planu dla podanego przewodnika planistycznego
end desc

params
   PL_PART:='' STRING[16], Ref SQL przewodnika planistycznego
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PL_OPER,
/*3*/    '1234567890123456' as NEXT_OPE,
/*4*/    '1234567890123456' as PL_OGR,
/*5*/    '1234567890123456' as NEXT_OGR
   from SYSLOG
   where 0=1
end sql

formula
   PL_OPER.cntx_psh();
   PL_NEXT.cntx_psh();
   PL_PART.cntx_psh();
   PL_PART.clear();
   {? PL_PART.seek(:PL_PART)
   || PL_OPER.index('PL_PART');
      PL_OPER.prefix(PL_PART.ref());
      {? PL_OPER.first()
      || {!
         |? PL_NEXT.index('PL_OPER');
            PL_NEXT.prefix(PL_OPER.ref());
            {? PL_NEXT.first()
            || {!
               |? :RS.blank();
                  :RS.REF:=$PL_NEXT.ref();
                  :RS.PL_OPER:=$PL_NEXT.PL_OPER;
                  :RS.NEXT_OPE:=$PL_NEXT.NEXT;
                  :RS.PL_OGR:=$PL_NEXT.PL_OGR;
                  :RS.NEXT_OGR:=$PL_NEXT.NEXT_OGR;
                  :RS.add();
                  PL_NEXT.next()
               !}
            ?};

            PL_NEXT.index('NEXT');
            PL_NEXT.prefix(PL_OPER.ref());
            {? PL_NEXT.first()
            || {!
               |? :RS.blank();
                  :RS.REF:=$PL_NEXT.ref();
                  :RS.PL_OPER:=$PL_NEXT.PL_OPER;
                  :RS.NEXT_OPE:=$PL_NEXT.NEXT;
                  :RS.PL_OGR:=$PL_NEXT.PL_OGR;
                  :RS.NEXT_OGR:=$PL_NEXT.NEXT_OGR;
                  :RS.add();
                  PL_NEXT.next()
               !}
            ?};
            PL_OPER.next()
         !}
      ?}
   ?};
   PL_NEXT.cntx_pop();
   PL_PART.cntx_pop();
   PL_OPER.cntx_pop()
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc ploper_move

desc
   Przesuwa podanego plopera
end desc

params
   REF:=''    STRING[16], Ref SQL przesuwanego PL_OPERa
   STARTD         DATE,       Data startu
   STARTT         TIME,       Czas startu
   ENDD           DATE,       Data konca
   ENDT           TIME,       Czas konca
   OFFSET_U:=0    REAL,       Czas startu od ostatniej operacji (uzytkownika)
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF,
      SPACE(255) as KONFLIKT
   from SYSLOG
   where 0=1
end sql

formula
   PL_OPER.cntx_psh();
   PL_OPER.clear();
   _result:=0;
   {? PL_OPER.seek(:REF)
   ||
      _tm_start:=exec('create','#tm_stamp',:STARTD,:STARTT);
      _can_move:=1;
      {? _tm_start<>PL_OPER.TM_START
      ||
#        Sprawdzam czy plan strategiczny pozwala na przesuniecie
         _can_move:=exec('can_move_ploper','px_tie',PL_OPER.ref)
      ?};
      {? _can_move>0
      ||
         PL_OPER.STARTD:=:STARTD;
         PL_OPER.STARTT:=:STARTT;
         PL_OPER.ENDD:=:ENDD;
         PL_OPER.ENDT:=:ENDT;
         PL_OPER.TM_START:=exec('create','#tm_stamp',PL_OPER.STARTD,PL_OPER.STARTT);
         PL_OPER.TM_END:=exec('create','#tm_stamp' ,PL_OPER.ENDD  ,PL_OPER.ENDD  );
         PL_OPER.OFFSET_U:=:OFFSET_U;
         _result:=PL_OPER.put();
         {? _result>0
         || {? PL_OPER.PL_PART<>null()
            || exec('plpart_date_upd','po_plan',PL_OPER.PL_PART)
            ?};
            _ploper:=PL_OPER.ref();
            exec('zgp_dates_upd','po_plan',_ploper);
            exec('ploz_tm_update','po_plan',_ploper);
            exec('next_tm_oper','po_plan',_ploper);

#           Powiadomienie zdarzeń o przesunięciu
            _pl_evenr:=PL_OPER.PL_EVENR;
            _can_continue:=1;
            {? _result>0 & _pl_evenr<>null()
            || _can_continue:=exec('plan_move','po_event',_pl_evenr,PL_OPER.ref())
            ?};

#           Aktualizacja planu strategicznego
            {? _can_continue>0
            || _mainver:=exec('get_mainversion','px_ver');
               exec('ploper2pxpoz','px_tie',_ploper,_mainver)
            ?};
            ~~
         ?}
      || _result:=_can_move
      ?}
   || _result:=-5
   ?};
   :RS.RESULT:=_result;
   :RS.add();
   PL_OPER.cntx_pop()
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------

proc ploper_reset

desc
   Resetuje ploperowi daty zaplanowane na podane w argumentach
end desc

params
   PLOPER:=''    STRING[16], Ref SQL plopera
   STARTD         DATE,       Data startu
   STARTT         TIME,       Czas startu
   ENDD           DATE,       Data konca
   ENDT           TIME,       Czas konca
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   PL_OPER.cntx_psh();
   PL_OZ.cntx_psh();
   PL_OPER.clear();
   {? PL_OPER.seek(:PLOPER)
   || PL_OPER.STARTD:=:STARTD;
      PL_OPER.STARTT:=:STARTT;
      PL_OPER.ENDD:=:ENDD;
      PL_OPER.ENDT:=:ENDT;
      PL_OPER.TM_START:=exec('create','#tm_stamp',PL_OPER.STARTD,PL_OPER.STARTT);
      PL_OPER.TM_END:=exec('create','#tm_stamp' ,PL_OPER.ENDD  ,PL_OPER.ENDD  );
      :RS.RESULT:=PL_OPER.put();
      {? :RS.RESULT>0
      || exec('plpart_date_upd','po_plan',PL_OPER.PL_PART);
         exec('zgp_dates_upd','po_plan',PL_OPER.ref());
         exec('ploz_tm_update','po_plan',PL_OPER.ref());
         exec('next_tm_oper','po_plan',PL_OPER.ref());

#        Aktualizacja planu strategicznego
         _mainver:=exec('get_mainversion','px_ver');
         exec('ploper2pxpoz','px_tie',PL_OPER.ref(),_mainver);
         ~~
      ?}
   ?};
   :RS.add();
   PL_OZ.cntx_pop();
   PL_OPER.cntx_pop()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc ploper_color

desc
   Zmienia kolor podanego plopera
end desc

params
   REF:=''    STRING[16], Ref SQL przesuwanego PL_OPERa
   COLOR:=''  STRING[11], Nowy kolor podanego PL_OPERa
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF
   from SYSLOG
   where 0=1
end sql

formula
   PL_OPER.cntx_psh();
   PL_OGR.cntx_psh();
   PL_OGR.clear();
   PL_OPER.clear();
   _result:=1;
   {? ref_tab(:REF)=PL_OPER
   ||
      {? PL_OPER.seek(:REF)
      ||
         PL_OPER.KOLOR:=:COLOR;
         _result:=PL_OPER.put()
      ?}
   |? ref_tab(:REF)=PL_OGR
   || {? PL_OGR.seek(:REF)
      ||
         PL_OGR.KOLOR:=:COLOR;
         _result:=PL_OGR.put()
      ?}
   ?};
   :RS.RESULT:=_result;
   :RS.add();
   PL_OPER.cntx_pop();
   PL_OGR.cntx_pop()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc get_plopresy

desc
   Zwraca refy ploperow i refy pl_resow na ktorych te plopery mozna zaplanowac
end desc

params
   START    STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END      STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
end params

sql
   select
/*1*/    '1234567890123456' as REF_PLOP,
/*2*/    '1234567890123456' as REF_RES,
/*3*/    '1234567890123456' as REF_OGR,
/*4*/    cast (0 as REAL_TYPE) as DURATION,
/*5*/    cast (0 as REAL_TYPE) as OFFSET_O,
/*6*/    0 as ZAM
   from SYSLOG
   where 0=1
end sql

formula
   PL_OGR.cntx_psh();
   PL_OGR.index('TM_END');
   PL_OGR.clear();
   GROP.cntx_psh();
   GROPS.cntx_psh();
   PL_OPER.cntx_psh();
   PL_EVENR.cntx_psh();

   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   _int_view:=exec('interval','#interval');
   _int_view.START:=_tm_start;
   _int_view.END:=_tm_end;

#  Dodawanie ploperow
   PL_OPER.index('TM_END');
   PL_OPER.clear();
   {? PL_OPER.find_ge(_tm_start)
   ||
      {? PL_OPER.TM_START<_tm_end
      ||
         _int_rec:=exec('interval','#interval');
         {!
         |? {? (PL_OPER.TOPER<>null | PL_OPER.ZGP<>null()) & PL_OPER.PL_PART<>null()
            || exec('start_tpar','tech_param',PL_OPER.PL_PART().M,PL_OPER.PL_PART().TKTL)
            ?};
            _int_rec.START:=PL_OPER.TM_START;
            _int_rec.END:=PL_OPER.TM_END;
            {? PL_OPER.PLANNED='T'
            || _ok:=0;
               {? exec('intervals_chk','#interval',_int_rec,_int_view)>0
               ||
                  {? PL_OPER.TOPER<>null()
                  || _res:=exec('get_resources','po_plan',$PL_OPER.TOPER,PL_OPER.ILOSC,,'TOPER');
                     _res.clear();
                     _ok:=1
                  |? PL_OPER.ZGP<>null()
                  || _res:=exec('get_resources','po_plan',$PL_OPER.ZGP,PL_OPER.ILOSC,,'ZGP');
                     _res.clear();
                     _ok:=1
                  |? PL_OPER.PL_EVENR<>null()
                  || _res:=exec('get_resources','po_event',PL_OPER.PL_EVENR().PL_EVENT,PL_OPER.DURATION);
                     _res.clear();
                     _ok:=1
                  ?}
               ?};
               {? _ok>0
               || {? _res.first()
                  || {!
                     |? :RS.blank();
                        :RS.REF_PLOP:=$PL_OPER.ref();
                        :RS.REF_RES:=_res.REF_RES;
                        :RS.REF_OGR:='';
                        :RS.DURATION:=_res.DURATION;
                        :RS.OFFSET_O:=_res.OFFSET_O;
                        {? _res.ZAM_WHAT='ZAMIENNIK'
                        || :RS.ZAM:=1
                        ?};
                        :RS.add();
                        _res.next()
                     !}
                  ?};
                  obj_del(_res)
               ?}
            ?};
            PL_OPER.next()
         !}
      ?}
   ?};
#  Dodawanie PL_OGRow
   GROPS.index('GROP');
   {? PL_OGR.find_ge(_tm_start)
   ||
      {? PL_OGR.TM_START<_tm_end
      ||
         {? var_pres('_int_rec')>100
         || obj_del(_int_rec)
         ?};
         _int_rec:=exec('interval','#interval');
         {!
         |?
#         GROPS.prefix(PL_OGR.GROP);
#         {? GROPS.first()
#         || {!
#            |? :RS.blank();
#               :RS.REF_OGR:=$PL_OGR.ref();
#               :RS.REF_PLOP:='';
#               :RS.REF_RES:=$GROPS.PL_RES;
#               :RS.add();
#               GROPS.next()
#            !}
#         ?};

#           Zalozenie upraszczajace - PL_OGRa nie mozna przesuwac na inne PL_RESY
            _int_rec.START:=PL_OGR.TM_START;
            _int_rec.END:=PL_OGR.TM_END;
            {? exec('intervals_chk','#interval',_int_rec,_int_view)>0
            ||
               :RS.blank();
               :RS.REF_OGR:=$PL_OGR.ref();
               :RS.REF_PLOP:='';
               :RS.REF_RES:=$PL_OGR.PL_RES;
               :RS.DURATION:=PL_OGR.DURATION;
               :RS.add()
            ?};
            PL_OGR.next()
         !}
      ?}
   ?};

   PL_OPER.cntx_pop();
   PL_OGR.cntx_pop();
   GROP.cntx_pop();
   GROPS.cntx_pop();
   PL_EVENR.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------

proc get_part_plopres

desc
   Zwraca refy ploperow i refy pl_resow na ktorych te plopery mozna zaplanowac
end desc

params
   PL_PART:='' STRING[16], Ref SQL plparta
end params

sql
   select
/*1*/    '1234567890123456' as REF_PLOP,
/*2*/    '1234567890123456' as REF_RES,
/*3*/    '1234567890123456' as REF_OGR,
/*4*/    cast (0 as REAL_TYPE) as DURATION,
/*5*/    cast (0 as REAL_TYPE) as OFFSET_O,
/*6*/     0 as ZAM
   from SYSLOG
   where 0=1
end sql

formula
   PL_OPER.cntx_psh();
   PL_PART.cntx_psh(); PL_PART.clear();
   {? PL_PART.seek(:PL_PART)
   ||
      PL_OPER.index('PL_PART');
      PL_OPER.prefix(PL_PART.ref());
      {? PL_OPER.first()
      || {!
         |?
            {? PL_OPER.PLANNED='T'
            || _ok:=0;

               {? (PL_OPER.TOPER<>null | PL_OPER.ZGP<>null()) & PL_OPER.PL_PART<>null()
               || exec('start_tpar','tech_param',PL_OPER.PL_PART().M,PL_OPER.PL_PART().TKTL)
               ?};
               {? PL_OPER.TOPER<>null()
               || _res:=exec('get_resources','po_plan',$PL_OPER.TOPER,PL_OPER.ILOSC,,'TOPER');
                  _res.clear();
                  _ok:=1
               |? PL_OPER.ZGP<>null()
               || _res:=exec('get_resources','po_plan',$PL_OPER.ZGP,PL_OPER.ILOSC,,'ZGP');
                  _res.clear();
                  _ok:=1
               ?};
               {? _ok>0
               || {? _res.first()
                  || {!
                     |? :RS.blank();
                        :RS.REF_PLOP:=$PL_OPER.ref();
                        :RS.REF_RES:=_res.REF_RES;
                        :RS.REF_OGR:='';
                        :RS.DURATION:=_res.DURATION;
                        :RS.OFFSET_O:=_res.OFFSET_O;
                        {? _res.ZAM_WHAT='ZAMIENNIK'
                        || :RS.ZAM:=1
                        ?};
                        :RS.add();
                        _res.next()
                     !}
                  ?};
                  obj_del(_res)
               ?}
            ?};
            PL_OPER.next()
         !}
      ?}
   ?};
   PL_PART.cntx_pop();
   PL_OPER.cntx_pop()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------


proc ploz_move

desc
   Przepina ploza na inny zasob planistyczny
end desc

params
   PLOZ:=''    STRING[16], Ref SQL przepinanego ploza
   PL_RES:=''  STRING[16], Ref SQL nowego zasobu dla ploza (PL_RES)
   DURATION:=0 REAL, Nowy czas trwania plopera
   OFFSET_O:=0 REAL, Nowy odstęp technologiczny od poprzedniej operacji
   ZAM:=0      REAL, Czy Ploper zmienił czas trwania w wyniku przeciągnięcia go na zamiennik
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF,
      SPACE(255) as KONFPLUG
   from SYSLOG
   where 0=1
end sql

formula
   _can_continue:=1;
   PL_EVENR.cntx_psh();
   PL_OPER.cntx_psh();
   PL_OPER.clear();
   PL_OZ.cntx_psh();
   PL_RES.cntx_psh();
   PL_OZ.clear();
   PL_RES.clear();
   {? PL_OZ.seek(:PLOZ)
   || {? PL_RES.seek(:PL_RES)
      || {? $PL_OZ.PL_RES<>$PL_RES.ref()
         ||
            _old_evenr:=null();
            _pl_event:=null();
            PL_OZ.PL_RES:=PL_RES.ref();
            PL_OZ.TM_START:=PL_OZ.PL_OPER().TM_START;
            PL_OZ.TM_END:=PL_OZ.PL_OPER().TM_END;
            {? PL_OZ.PL_OPER<>null()
            || _put:=0;
               PL_OZ.PL_OPER();
               {? :DURATION>0 & :DURATION<>PL_OPER.DURATION
               || PL_OPER.DURATION:=:DURATION;
                  _put:=1
               ?};
               {? :OFFSET_O<>PL_OPER.OFFSET_O
               || PL_OPER.OFFSET_O:=:OFFSET_O;
                  _put:=1
               ?};
               {? PL_OPER.PL_EVENR<>null()
               || _old_evenr:=PL_OPER.PL_EVENR;
                  _pl_event:=PL_OPER.PL_EVENR().PL_EVENT;
                  PL_EVENR.cntx_psh();
                  PL_EVENR.index('PL_EVENT');
                  PL_EVENR.prefix(_pl_event,PL_RES.ref());
                  {? PL_EVENR.first()
                  || PL_OPER.PL_EVENR:=PL_EVENR.ref();
                     _put:=1
                  ?};
                  PL_EVENR.cntx_pop()
               ?};
               {? _put>0
               || _can_continue:=PL_OPER.put()
               ?}
            ?};
            {? _can_continue>0
            || _can_continue:=PL_OZ.put();
               :RS.REF:=$PL_OZ.ref()
            ?};

#           Powiadomienie zdarzeń o przesunięciu
            _pl_evenr:=PL_OPER.PL_EVENR;
            {? _can_continue>0 & _pl_evenr<>null()
            || _can_continue:=exec('plan_move','po_event',_pl_evenr,PL_OPER.ref(),_old_evenr)
            ?};

            {? _can_continue>0
            ||
#              Aktualizacja planu strategicznego
               _mainver:=exec('get_mainversion','px_ver');
               exec('ploper2pxpoz','px_tie',PL_OZ.PL_OPER,_mainver)
            ?};
            {? _can_continue>0 & PL_OZ.PL_OPER().ZGP<>null()
            ||
#              Obsługa zamienników
               _can_continue:=exec('update4ploz','zl_guide',PL_OPER.ZGP,PL_OZ.ref())
            ?};

            {? _can_continue>0
            || :RS.KONFPLUG:=exec('konfplug_update','po_plan',,'CHANGE_RES')
            ?}
         || _can_continue:=-2
         ?}
      || _can_continue:=-1
      ?}
   || _can_continue:=-3
   ?};
   :RS.RESULT:=_can_continue;
   :RS.add();
   PL_RES.cntx_pop();
   PL_OZ.cntx_pop();
   PL_OPER.cntx_pop();
   PL_EVENR.cntx_pop();
   ~~
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc ploper_update

desc
   Resetuje ploperowi daty zaplanowane na podane w argumentach
end desc

params
   PLOPER:=''    STRING[16],  Ref SQL plopera
   KOLOR:=''     STRING[11],  Kolor plopera
   DURATION:=0    REAL,       Czas trwania
   TP:=0          REAL,       Czas TP w minutach
   TZ:=0          REAL,       Czas TZ w minutach
   STARTD         DATE,       Data startu
   STARTT         TIME,       Czas startu
   ENDD           DATE,       Data konca
   ENDT           TIME,       Czas konca
   OPIS:=''      STRING[255], Opis plopera
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   PL_OPER.cntx_psh();
   PL_OZ.cntx_psh();
   PL_OPER.clear();
   _can_continue:=0;
   {? PL_OPER.seek(:PLOPER)
   ||
      _can_continue:=1;

      {? :TP<>PL_OPER.TP | :TZ<>PL_OPER.TZ
      ||
#        Zmienił się czas TPZ więc sprawdzam czy zarejestrowano już jakieś wykonania
#        do TPZ
         {? exec('has_wyk_ploper','po_wyk',PL_OPER.ref(),2)>0
         || _can_continue:=0
         ?}
      ?};

      {? _can_continue>0
      || PL_OPER.DURATION:=:DURATION;
         PL_OPER.STARTD:=:STARTD;
         PL_OPER.STARTT:=:STARTT;
         PL_OPER.ENDD:=:ENDD;
         PL_OPER.ENDT:=:ENDT;
         PL_OPER.TP:=:TP;
         PL_OPER.TZ:=:TZ;
         PL_OPER.KOLOR:=:KOLOR;
         PL_OPER.OPIS:=:OPIS;
         _can_continue:=PL_OPER.put();

         {? _can_continue>0
         || exec('plpart_date_upd','po_plan',PL_OPER.PL_PART);
            exec('zgp_dates_upd','po_plan',PL_OPER.ref());

            {? PL_OPER.ZGP<>null()
            ||
#              Dodaje, modyfikuje lub usuwam czas TPZ na pozycji przewodnika zlecenia
               _tp:=PL_OPER.TP;
               _tz:=PL_OPER.TZ;
               _can_continue:=exec('tpz_edit','zl_guide',PL_OPER.ZGP,_tp,_tz);
               {? _can_continue<=0
               || :RS.RESULT:=0
               ?}
            ?}
         || KOMM.add('Edycja operacji w planie: '+PL_OPER.SYMBOL+' '+PL_OPER.OPIS+' zakończona niepowodzeniem.',2,,1)
         ?}
      || KOMM.add('Zarejestrowano już wykonania do operacji przygotowawczo-zakończeniowej, ich modyfikacja jest niedozwolona.',2,,1)
      ?}
   ?};
   :RS.RESULT:=_can_continue;
   :RS.add();
   PL_OZ.cntx_pop();
   PL_OPER.cntx_pop()
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_delays

desc
   Zwraca opóźnione plopery, tzn takie które mają koniec w przeszłości i nie zostały w całości wykonane
end desc

params
   FILTER:='%' String[255],Filtr na zamowienie klienta, skrot, nazwe kontrahenta
   START STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END   STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLPART,
/*3*/    cast (0 as REAL_TYPE) as DURATION,
/*4*/    TO_DATE('2007/04/25') as STARTD,
/*5*/    TO_DATE('2007/04/25') as ENDD,
/*6*/    TO_TIME('0:0:0') as STARTT,
/*7*/    TO_TIME('0:0:0') as ENDT,
/*8*/    cast (0 as REAL_TYPE) as TP,
/*9*/    cast (0 as REAL_TYPE) as TZ,
/*10*/   '                                                                                          ' as SYMBOL,
/*11*/   '                                                                                          ' as OPIS,
/*12*/   '255:255:255' as KOLOR,
/*13*/   cast (0 as REAL_TYPE) as OFFSET_P,
/*14*/   cast (0 as REAL_TYPE) as OFFSET_O,
/*15*/   cast (0 as REAL_TYPE) as OFFSET_U,
/*16*/   TO_DATE('2007/04/25') as MINDATE,
/*17*/   TO_DATE('2007/04/25') as MAXDATE,
/*18*/   TO_TIME('0:0:0') as MINTIME,
/*19*/   TO_TIME('0:0:0') as MAXTIME,
/*20*/   '                                                                                          ' as WHO_ADD,
/*21*/   '                                                                                          ' as WHO_MOD,
/*22*/   cast (0 as REAL_TYPE) as WYK,
/*23*/   '1234567890123456' as TOPER,
/*24*/   '1234567890123456' as ZOPER,
/*25*/   '1234567890123456' as PLANNED,
/*26*/   '1234567890123456789' as PL_START,
/*27*/   '1234567890123456789' as PL_END,
/*28*/   ' ' as TYP,
/*29*/   0 as MOVEABLE,
/*30*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*31*/   '1234567890123456' as ZGP,
/*32*/   '12345678901234567890' as GROUPKEY,
/*33*/   0 as PREVS,
/*34*/   0 as NEXTS,
/*35*/   '                                              ' as SYM_MIN,
/*36*/   '                                              ' as SYM_MAX,
/*37*/   '1234567890123456789' as TERMIN,
/*38*/   0 as NUM,
/*39*/   '1234567890123456' as PLRES,
/*40*/   '                                                   ' as KTM,
/*41*/   '                                                                                                    ' as INFO1, /*Linia 1 na wyświetlanej utworzonej pozycji planu*/
/*42*/   '                                                                                                    ' as INFO2, /*Linia 2 na wyświetlanej utworzonej pozycji planu*/
/*43*/   '                                                                                                    ' as INFO3, /*Linia 3 na wyświetlanej utworzonej pozycji planu*/
/*44*/   '          ' as JM,
/*45*/   '1234567890123456' as PL_SPLIT,
/*46*/   '255:255:255' as KOLOR_T,
/*47*/   '255:255:255' as KOLOR_M,
/*48*/   '255:255:255' as KOLOR_G,
/*49*/   ' ' as SINGLE,
/*50*/   ' ' as LIMITY,
/*51*/   cast (0 as REAL_TYPE) as IL_NAPR,
/*52*/   ' ' as EVE_BT,
/*53*/   ' ' as EVE_EAT,
/*54*/   cast (0 as REAL_TYPE) as EVE_USE,
/*55*/   '1234567890123456' as PL_EVENR,
/*56*/   '1234567890123456' as PL_EVENT,
/*57*/   ' ' as EVE_TRYB,
/*58*/   ' ' as NPU
   from SYSLOG
   where 0=1
   order by PL_START DESC, PL_END DESC

end sql

formula
   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   _int_view:=exec('interval','#interval');
   _int_view.START:=_tm_start;
   _int_view.END:=_tm_end;
   _now:=PL_OPER.tm_stamp();
   PL_PART.cntx_psh();
   PL_OPER.cntx_psh();
   PL_OPER.index('TM_END');
   PL_OPER.clear();
   {? PL_OPER.find_ge(_tm_start)
   || _int_rec:=exec('interval','#interval');
      {!
      |?
         {? PL_OPER.TYP='O' & PL_OPER.ILOSC>PL_OPER.IL_WYK  & PL_OPER.TM_END<_now
         || _int_rec.START:=PL_OPER.TM_START;
            _int_rec.END:=PL_OPER.TM_END;

            _can_add:=1;
            {? :FILTER<>''
            || _can_add:=0;
               _ktm:=PL_OPER.PL_PART().M().KTM;
               _ktm_naz:=M.N;
               {? (PL_OPER.SYMBOL*:FILTER>0 | PL_OPER.OPIS*:FILTER>0 | _ktm*:FILTER>0 | _ktm_naz*:FILTER>0)
               || _can_add:=1
               ?}
            ?};

            {? _can_add>0 & exec('intervals_chk','#interval',_int_rec,_int_view)>0
            ||
               :RS.blank();
               exec('ploper_to_rs','po_plan',:RS);
               :RS.add()
            ?}
         ?};
         PL_OPER.next()
      !}
   ?};
   PL_OPER.cntx_pop();
   PL_PART.cntx_pop()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc load4rej

desc
   Aktualizuje PROD_REJ dla podanego plparta
end desc

params
   PL_PART:='' STRING[16], Ref SQL plparta
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   {? exec('get','#params',500612,2)='T'
   ||
      PL_OPER.cntx_psh();
      PL_OZ.cntx_psh();
      PL_PART.cntx_psh();
      PL_OZ.index('PL_OPER');
      PL_OPER.index('PL_PART');
      PL_PART.clear();
      {? PL_PART.seek(:PL_PART)
      || exec('load_4rej','po_wyk',0,PL_PART.ref());
         :RS.blank();
         :RS.RESULT:=1;
         :RS.add()
      ?};
      PL_OZ.cntx_pop();
      PL_OPER.cntx_pop();
      PL_PART.cntx_pop()
   ||
      :RS.blank();
      :RS.RESULT:=1;
      :RS.add()
   ?}
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc konfplug_update

desc
   Uruchamia wtyczkę PO_AFTER_CHANGE_001 dla podanego PL_OZa i aktualizuje mu treść konfliktu wdrożeniowego
end desc

params
   REF:=''    STRING[16], Ref SQL przesuwanego PL_OZa
   KIND:=''   STRING[20], Eodzaj zmiany: ADD,CHANGE_TIME,CHANGE_RES
end params

sql
   select
      0 as RESULT,
      '1234567890123456' as REF,
      SPACE(255) as KONFPLUG
   from SYSLOG
   where 0=1
end sql

formula
   PL_OZ.cntx_psh(); PL_OZ.prefix();
   {? PL_OZ.seek(:REF)
   ||
      _konf:=exec('konfplug_update','po_plan',,:KIND);
      {? type_of(_konf)=type_of('')
      ||
         :RS.blank();
         :RS.REF:=$PL_OZ.ref();
         :RS.KONFPLUG:=_konf;
         :RS.RESULT:=1;
         :RS.add()
      ?}
   ?};
   PL_OZ.cntx_pop();
   ~~
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc konfplug_view

desc
   Uruchamia wtyczkę PO_AFTER_CHANGE_001 dla wszystkich plozow w widoku planu
end desc

params
   START    STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END      STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
   TYP      STRING[1],  Typy pobierania ='O' zwykle plopery operacji PL_OPER.TYP='O', <>'O' plopery rezerwacyjne
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   :RS.blank();
   :RS.RESULT:=exec('konfplug_run','po_plan',_tm_start,_tm_end,:TYP);
   :RS.add();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------

proc ploper_def_tpz

desc
   Zwraca domyśny czas TPZ dla podanego PL_OPERa
end desc

params
   PL_OPER    STRING[16], SQL ref pl_opera
end params

sql
   select
      CAST (0 AS REAL_TYPE) as TPDEF,
      CAST (0 AS REAL_TYPE) as TZDEF
   from SYSLOG
   where 0=1
end sql

formula
   PL_OPER.cntx_psh(); PL_OPER.prefix();
   ZGP.cntx_psh();
   TOPER.cntx_psh();
   TOPER.index('TPZ');
   {? PL_OPER.seek(:PL_OPER)
   || :RS.blank();

      {? PL_OPER.ZGP<>null()
      ||
         PL_OPER.ZGP();

         {? ZGP.TOPER<>null()
         ||
            TOPER.prefix('T',ZGP.TOPER().UNROP);
            {? TOPER.first()
            ||
               {? ZGP.ZL().TYP().TECH='T'
               ||
#                 Zlecenie z własną technologią, norma TPZ przeliczona
                  :RS.TPDEF:=TOPER.NTIME*60
               ||
#                 Zlecenie bez własnej technologii trzeba przeliczyć czas TPZ
                  {? TOPER.FNTIME<>''
                  || exec('start_tpar','tech_param',ZL.KTM,ZGP.ZL().KTL);
                     :RS.TPDEF:=tpar.calc(TOPER.FNTIME)*60
                  || :RS.TPDEF:=TOPER.NTIME*60
                  ?}
               ?};
               :RS.add()
            ?}
         ?}
      |? PL_OPER.TOPER<>null()
      ||
         TOPER.prefix('T',TOPER.UNROP);
         {? TOPER.first()
         || :RS.TPDEF:=TOPER.NTIME*60;
            :RS.add()
         ?}
      ?}
   ?};

   PL_OPER.cntx_pop();
   ZGP.cntx_pop();
   TOPER.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_plconf_all

desc
   Zwraca konflikty wdrożeniowe w podanym zakresie
end desc

params
   START    STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END      STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PL_OZ,
/*3*/    0 as LP,
/*4*/    SPACE(30) as TYP,
/*5*/    SPACE(255) as OPIS
   from SYSLOG
   where 0=1
end sql

formula
   PL_CONF.cntx_psh();
   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   _int_view:=exec('interval','#interval');
   _int_view.START:=_tm_start;
   _int_view.END:=_tm_end;
   PL_CONF.index('TM_END');
   PL_CONF.clear();
   {? PL_CONF.find_ge(_tm_start)
   ||
      {? PL_CONF.TM_START<_tm_end
      || _int_rec:=exec('interval','#interval');
         {!
         |? _ok:=1;
            {? _ok>0
            || _int_rec.START:=PL_CONF.TM_START;
               _int_rec.END:=PL_CONF.TM_END;
               {? exec('intervals_chk','#interval',_int_rec,_int_view)>0
               || :RS.blank();
                  :RS.REF:=$PL_CONF.ref();
                  :RS.PL_OZ:=$PL_CONF.PL_OZ;
                  :RS.LP:=PL_CONF.LP;
                  :RS.TYP:=PL_CONF.TYP;
                  :RS.OPIS:=PL_CONF.OPIS;
                  :RS.add()
               ?}
            ?};
            PL_CONF.next()
         !}
      ?}
   ?};
   PL_CONF.cntx_pop();
   ~~
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------


proc get_plconf_ploz

desc
   Zwraca konflikty wdrożeniowe dla danego PL_OZ
end desc

params
   PL_OZ    STRING[16], Ref SQL PL_OZ
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PL_OZ,
/*3*/    0 as LP,
/*4*/    SPACE(30) as TYP,
/*5*/    SPACE(255) as OPIS
   from SYSLOG
   where 0=1
end sql

formula
   PL_CONF.cntx_psh();
   PL_OZ.cntx_psh();
   PL_OZ.prefix();
   {? PL_OZ.seek(:PL_OZ)
   ||
      PL_CONF.index('PL_OZ');
      PL_CONF.prefix(PL_OZ.ref());
      {? PL_CONF.first()
      || {!
         |? :RS.blank();
            :RS.REF:=$PL_CONF.ref();
            :RS.PL_OZ:=$PL_CONF.PL_OZ;
            :RS.LP:=PL_CONF.LP;
            :RS.TYP:=PL_CONF.TYP;
            :RS.OPIS:=PL_CONF.OPIS;
            :RS.add();
            PL_CONF.next()
         !}
      ?}
   ?};
   PL_OZ.cntx_pop();
   PL_CONF.cntx_pop();
   ~~
end formula

end proc


#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 0bddfb0a28d4ecdfb1603ba67ef993442b2bfa86edf3570d1c19ac6138181e2f4378464f18153569b8a0a2b5a1142f1450e1842c539dcdd3e12fc2766bdb5545c7316128f3592498bf8806b1d95bbd368d0d837fc2318e0202cafb3a930726ad2bc14fe587954ba2b3a7ee36d359708f52fcad666128697d73842ad22a8828e7
