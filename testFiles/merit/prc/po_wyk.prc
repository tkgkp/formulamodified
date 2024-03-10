:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: po_wyk.prc [12.30]
# Utworzony: 24.02.2012
# Autor: WH
#=======================================================================================================================
# Zawartosc: Procedury do obslugi wykonan
#=======================================================================================================================


proc get_plwyki
desc
   Zwraca wykonania w danym przedziale czasu
end desc

params
   START    STRING[19], Czas poczatku w formacie 'YYYY/MM/DD HH:MM:SS'
   END      STRING[19], Czas konca w formacie 'YYYY/MM/DD HH:MM:SS'
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLOPER,
/*3*/    '1234567890123456' as PLOZ,
/*4*/    ' 'as AUTO,
/*5*/    '1234567890123456' as ZLGD,
/*6*/    '1234567890123456789' as STRSTART,
/*7*/    '1234567890123456789' as STREND,
/*8*/    '1234567890123456789' as STRMOD,
/*9*/    CAST (0 AS REAL_TYPE) as ILWYK,
/*10*/   '1234567890123456' as PLOGR,
/*11*/   ' ' as POTW,
/*12*/   ' ' as TP,
/*13*/   ' ' as TZ,
/*14*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*15*/   CAST (0 AS REAL_TYPE) as BRAKI,
/*16*/   '                                                                  ' as OPERATOR,
/*17*/   ' ' as OK
   from SYSLOG
   where 0=1
end sql

formula
   _tm_start:=exec('str2tm_stamp','libfml',:START);
   _tm_end:=exec('str2tm_stamp','libfml',:END);
   PL_WYK.cntx_psh();
   PL_WYK.index('TM_END');
   PL_WYK.clear();
   {? PL_WYK.find_ge(_tm_start)
   || {!
      |?
#        Jesli PL_WYK nie ma daty konca to znak, ze nie powinienem go jeszcze pobierac
#        bo ktos zrobil akcje 'start', ale nie zrobil jeszcze akcji 'koniec' - w takiej
#        sytuacji na planie pojawi sie wykonanie ktore jeszcze jest niekompletne pod wzgledem
#        zaawansowania czasowego
         {? PL_WYK.TM_END>0
         ||
            :RS.blank();
            exec('pl_wyk2rs','po_wyk',:RS);
            :RS.add()
         ?};
         PL_WYK.next() & PL_WYK.TM_SRC_S<_tm_end
      !}
   ?};
   PL_WYK.cntx_pop();
   ~~

end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------


proc get_part_plwyki
desc
   Zwraca wykonania dla danego przewodnika planistycznego
end desc

params
   PL_PART:='' STRING[16], Ref SQL plparta
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLOPER,
/*3*/    '1234567890123456' as PLOZ,
/*4*/    ' 'as AUTO,
/*5*/    '1234567890123456' as ZLGD,
/*6*/    '1234567890123456789' as STRSTART,
/*7*/    '1234567890123456789' as STREND,
/*8*/    '1234567890123456789' as STRMOD,
/*9*/    CAST (0 AS REAL_TYPE) as ILWYK,
/*10*/   '1234567890123456' as PLOGR,
/*11*/   ' ' as POTW,
/*12*/   ' ' as TP,
/*13*/   ' ' as TZ,
/*14*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*15*/   CAST (0 AS REAL_TYPE) as BRAKI,
/*16*/   '                                                                  ' as OPERATOR,
/*17*/   ' ' as OK
   from SYSLOG
   where 0=1
end sql

formula
   PL_PART.cntx_psh();
   PL_PART.clear();
   PL_OPER.cntx_psh();
   PL_OPER.index('PL_PART');
   PL_WYK.cntx_psh();
   PL_WYK.index('PL_OPER');
   PL_WYK.clear();
   {? PL_PART.seek(:PL_PART)
   || PL_OPER.prefix(PL_PART.ref());
      {? PL_OPER.first()
      || {!
         |?
            PL_WYK.prefix(PL_OPER.ref());
            {? PL_WYK.first()
            || {!
               |?
#                 Jesli PL_WYK nie ma daty konca to znak, ze nie powinienem go jeszcze pobierac
#                 bo ktos zrobil akcje 'start', ale nie zrobil jeszcze akcji 'koniec' - w takiej
#                 sytuacji na planie pojawi sie wykonanie ktore jeszcze jest niekompletne pod wzgledem
#                 zaawansowania czasowego
                  {? PL_WYK.TM_END>0
                  || :RS.blank();
                     exec('pl_wyk2rs','po_wyk',:RS);
                     :RS.add()
                  ?};
                  PL_WYK.next()
               !}
            ?};
            PL_OPER.next()
         !}
      ?}
   ?};
   PL_WYK.cntx_pop();
   PL_OPER.cntx_pop();
   PL_PART.cntx_pop();
   ~~

end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------


proc get_new_plwyki

desc
   Zwraca wykonania nowe od ostatniego momentu czasu
end desc

params
   STR_LAST:=''   STRING[19], Moment czasu w ktorym nastapilo ostatnie pobranie danych
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLOPER,
/*3*/    '1234567890123456' as PLOZ,
/*4*/    ' 'as AUTO,
/*5*/    '1234567890123456' as ZLGD,
/*6*/    '1234567890123456789' as STRSTART,
/*7*/    '1234567890123456789' as STREND,
/*8*/    '1234567890123456789' as STRMOD,
/*9*/    CAST (0 AS REAL_TYPE) as ILWYK,
/*10*/   '1234567890123456' as PLOGR,
/*11*/   ' ' as POTW,
/*12*/   ' ' as TP,
/*13*/   ' ' as TZ,
/*14*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*15*/   CAST (0 AS REAL_TYPE) as BRAKI,
/*16*/   '                                                                  ' as OPERATOR,
/*17*/   ' ' as OK
   from SYSLOG
   where 0=1
end sql

formula
   _tm_load:=exec('str2tm_stamp','libfml',:STR_LAST);
   PL_WYK.cntx_psh();
   PL_WYK.index('TM_MOD');
   PL_WYK.clear();
   {? PL_WYK.find_ge(_tm_load)
   || {!
      |?
#        Jesli PL_WYK nie ma daty konca to znak, ze nie powinienem go jeszcze pobierac
#        bo ktos zrobil akcje 'start', ale nie zrobil jeszcze akcji 'koniec' - w takiej
#        sytuacji na planie pojawi sie wykonanie ktore jeszcze jest niekompletne pod wzgledem
#        zaawansowania czasowego
         {? PL_WYK.TM_END>0
         ||
            :RS.blank();
            exec('pl_wyk2rs','po_wyk',:RS);
            :RS.add()
         ?};
         PL_WYK.next()
      !}
   ?};
   PL_WYK.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------


proc get_ploz_plwyki
desc
   Zwraca wykonania dla danej pozycji planu
end desc

params
   PL_OZ:='' STRING[16], Ref SQL PL_OZa
end params

sql
   select
/*1*/    '1234567890123456' as REF,
/*2*/    '1234567890123456' as PLOPER,
/*3*/    '1234567890123456' as PLOZ,
/*4*/    ' 'as AUTO,
/*5*/    '1234567890123456' as ZLGD,
/*6*/    '1234567890123456789' as STRSTART,
/*7*/    '1234567890123456789' as STREND,
/*8*/    '1234567890123456789' as STRMOD,
/*9*/    CAST (0 AS REAL_TYPE) as ILWYK,
/*10*/   '1234567890123456' as PLOGR,
/*11*/   ' ' as POTW,
/*12*/   ' ' as TP,
/*13*/   ' ' as TZ,
/*14*/   CAST (0 AS REAL_TYPE) as ILOSC,
/*15*/   CAST (0 AS REAL_TYPE) as BRAKI,
/*16*/   '                                                                  ' as OPERATOR,
/*17*/   ' ' as OK
   from SYSLOG
   where 0=1
end sql

formula
   PL_OZ.cntx_psh();
   PL_WYK.cntx_psh();
   PL_WYK.index('PL_OZ');
   PL_WYK.clear();
   {? PL_OZ.seek(:PL_OZ)
   || PL_WYK.prefix(PL_OZ.ref());
      {? PL_WYK.first()
      || {!
         |?
            :RS.blank();
            exec('pl_wyk2rs','po_wyk',:RS);
            :RS.add();
            PL_WYK.next()
         !}
      ?}
   ?};
   PL_WYK.cntx_pop();
   PL_OZ.cntx_pop();
   ~~

end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 af0cb14d9d7e950dadd7d0823fe74ab3db0bee578950269075569650d263cdcdabd829776cc438029b168fba21f3a76ac00b912b3fac8a8f0017fd226ec4ab312bb24560b5b9c3bfcf6a5bd130546ff9aa9f040d71ed9df7fbd3e83a65d2bbce9dec90bd1134c4b92ccfdd2550c3b017b9f94343af78be9508bea0bd26c35af6
