:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: po_add.prc [2011]
# Utworzony: 26.05.2010
# Autor: WH
# Systemy: PROD
#=======================================================================================================================
# Zawartosc: Procedury usuwajace pozycje planu
#=======================================================================================================================


proc del_ploz

desc
   Usuwa jednego PL_OZa
end desc

params
   PLOZ:=''    STRING[16], Ref SQL ploza do usuniecia
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=exec('del_ploz','po_plan',:PLOZ);
   :RS.add()
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc del_ploper

desc
   Usuwa jednego PL_OPERa
end desc

params
   PLOPER:=''    STRING[16], Ref SQL plopera do usuniecia
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=exec('del_ploper','po_plan',:PLOPER,1,1);
   :RS.add()
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc del_plpart

desc
   Usuwa jednego PL_PARTa
end desc

params
   PLPART:=''    STRING[16], Ref SQL plparta do usuniecia
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=exec('del_plpart','po_plan',:PLPART);
   :RS.add()
end formula

end proc


#-----------------------------------------------------------------------------------------------------------------------

proc del_zam

desc
   Usuwa plan produkcji pozycji zamowienia
end desc

params
   ZK_P:=''    STRING[16], Ref SQL zk_p ktorego plan usuwamy
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=exec('del_zam','po_plan',:ZK_P);
   :RS.add()
end formula

end proc


#----------------------------------------------------------------------------------------------------------------------

proc del_zlec

desc
   Usuwa plan produkcji calego zlecnia
end desc

params
   ZLEC:=''    STRING[16], Ref SQL zlecenia ktorego plan usuwamy
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=exec('del_zlec','po_plan',:ZLEC);
   :RS.add()
end formula

end proc


#-----------------------------------------------------------------------------------------------------------------------

proc del_plogr

desc
   Usuwa jednego PL_OGRA
end desc

params
   PL_OGR:=''   STRING[16], Ref SQL plogra do usuniecia
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 1=0
end sql

formula
   _result:=0;
   _pl_ogr:=exec('FindAndGet','#table',PL_OGR,:PL_OGR,,,null());
   {? _pl_ogr<>null()
   || _result:=exec('delete','po_ogr',_pl_ogr)
   ?};
   :RS.blank();
   :RS.RESULT:=_result;
   :RS.add();
   ~~
end formula

end proc


#-----------------------------------------------------------------------------------------------------------------------

proc del_grop

desc
   Usuwa wszystkie PL_OGRy powiazane z podanym GROPem
end desc

params
   GROP:=''   STRING[16], Ref SQL GROPa ktorego PL_OGRY usunac
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 1=0
end sql

formula
   _result:=0;
   _can_continue:=0;
   _grop:=exec('FindAndGet','#table',GROP,:GROP,,,null());
   {? _grop<>null()
   || _can_continue:=1;
      PL_OGR.cntx_psh();
      PL_OGR.index('GROP');
      PL_OGR.prefix(_grop);
      {? PL_OGR.first()
      || {!
         |? _can_continue:=exec('delete','po_ogr',PL_OGR.ref());
            PL_OGR.first() & _can_continue>0
         !}
      ?};
      PL_OGR.cntx_pop()
   ?};
   :RS.blank();
   :RS.RESULT:=_can_continue;
   :RS.add();
   ~~
end formula

end proc


#-----------------------------------------------------------------------------------------------------------------------

proc del_event

desc
   Usuwa wszystkie PL_OPERY powiązane z danym zdarzeniem
end desc

params
   PL_EVENT:=''   STRING[16], Ref SQL zdarzenia
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 1=0
end sql

formula
   _result:=0;
   _can_continue:=0;
   _pl_event:=exec('FindAndGet','#table',PL_EVENT,:PL_EVENT,,,null());
   {? _pl_event<>null()
   || _can_continue:=1;

      PL_EVENR.cntx_psh();
      PL_EVENR.index('PL_EVENT');
      PL_EVENR.prefix(_pl_event);
      {? PL_EVENR.first()
      || {!
         |?
            PL_OPER.cntx_psh();
            PL_OPER.index('PL_EVE1');
            PL_OPER.prefix(PL_EVENR.ref());
            {? PL_OPER.first()
            || {!
               |? _can_continue:=exec('del_ploper','po_plan',$PL_OPER.ref(),,,1);
                  PL_OPER.first() & _can_continue>0
               !}
            ?};
            PL_OPER.cntx_pop();
            PL_EVENR.next() & _can_continue>0
         !}
      ?};
      PL_EVENR.cntx_pop()
   ?};
   :RS.blank();
   :RS.RESULT:=_can_continue;
   :RS.add();
   ~~
end formula

end proc



#Sign Version 2.0 jowisz:1045 2020/04/03 17:10:28 069c56c683c50dd36502cc4ec65ad7ef5132dae21b39017879d98467a9dd80da1c2902a51607ae835bc13cd91c713679cba8957eb12e447ddf08d7225e8309c0172ea8b17e33afc76c19ffe0a80bb48a45ffed0e7301d08cf1b225f7556a6815a69951618a3fbea21b238126c94a4e6525bbc2f0b1740df00afa1955907fb7d2
