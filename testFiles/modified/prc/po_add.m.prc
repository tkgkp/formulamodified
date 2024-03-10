:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: po_add.prc [2011]
# Utworzony: 13.05.2010
# Autor: WH
# Systemy: PROD
#=======================================================================================================================
# Zawartosc: Procedury dodajace pozycje planu
#=======================================================================================================================

proc ploz_add

desc
   Dodaje do tabeli PL_OZ 1 rekord
end desc

params
   PL_OPER:=''    STRING[16], Ref SQL planowanej operacji   [PL_OPER]
   PL_RES:=''     STRING[16], Ref SQL zasobu planistycznego [PL_RES]
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
   PL_OZ.cntx_psh();
   PL_OZ.clear();
   PL_OPER.cntx_psh();
   PL_RES.cntx_psh();
   PL_OZ.blank();
#-----------PL_OPER
   {? :PL_OPER<>''
   || PL_OPER.clear();
      {? PL_OPER.seek(:PL_OPER)
      || PL_OZ.PL_OPER:=PL_OPER.ref()
      ?}
   ?};
#-----------PL_RES
   {? :PL_RES<>''
   || PL_RES.clear();
      {? PL_RES.seek(:PL_RES)
      || PL_OZ.PL_RES:=PL_RES.ref()
      ?}
   ?};
   {? PL_OZ.PL_OPER=null()
   || _can_continue:=-1
   ?};
   {? PL_OZ.PL_RES=null()
   || _can_continue:=-2
   ?};
   {? _can_continue>0
   || PL_OZ.TM_START:=PL_OZ.PL_OPER().TM_START;
      PL_OZ.TM_END:=PL_OZ.PL_OPER().TM_END;
      _can_continue:=PL_OZ.add();
      :RS.REF:=$PL_OZ.ref()
   ?};

   PL_OPER.cntx_psh();
   {? _can_continue>0 & PL_OZ.PL_OPER().PL_EVENR<>null()
   || _can_continue:=exec('plan_add','po_event',PL_OZ.PL_OPER().PL_EVENR,PL_OZ.ref())
   ?};
   PL_OPER.cntx_pop();

   {? _can_continue>0
   ||
#     Dodaje PL_OPERa do planu strategicznego
      _mainver:=exec('get_mainversion','px_ver');
      {? exec('ploper2pxpoz','px_tie',PL_OZ.PL_OPER,_mainver)>0
      ||
#        Oznaczam kolejke ze trzeba przeliczyc
         exec('mod_stamp_queue','px_ver',_mainver)
      ?};
# NUCO - zmiana - aktualizacja stanowiska zawsze
#      {? :ZAM>0 & PL_OZ.PL_OPER().ZGP<>null()
      {?  PL_OZ.PL_OPER().ZGP<>null()
      ||
#        Obsługa zamienników
         _can_continue:=exec('update4ploz','zl_guide',PL_OPER.ZGP,PL_OZ.ref())
      ?};
      ~~
   ?};

   {? _can_continue>0
   || :RS.KONFPLUG:=exec('konfplug_update','po_plan',,'ADD')
   ?};

   :RS.RESULT:=_can_continue;
   :RS.add();
   PL_OPER.cntx_pop();
   PL_RES.cntx_pop();
   PL_OZ.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------


