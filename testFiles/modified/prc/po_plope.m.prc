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
# NUCO - aktualizacja PL_OZ - po zmianie czasu
            {? PL_OPER.ZGP<>null()
            || PL_OPER.cntx_psh();
               PL_OZ.cntx_psh();
               PL_OZ.clear();
               PL_OZ.index('PL_OPER');
               PL_OZ.prefix(_ploper);
               {? PL_OZ.first()
               || {!
                  |? exec('update4ploz','zl_guide',PL_OPER.ZGP,PL_OZ.ref());
                     PL_OZ.next()
                  !}
               ?};
               PL_OZ.cntx_pop();
               PL_OPER.cntx_pop()
            ?};
# Koniec zmiany
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


