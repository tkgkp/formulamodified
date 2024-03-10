:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#========================================================================================================================
# Nazwa pliku: po_views.prc
# Utworzony: 24.002.2020
# Autor: WH
#========================================================================================================================
# Zawartosc: Procedury obsługujące widoki planu operacyjnego
#========================================================================================================================

proc getviews

desc
   Zwraca widoki do których bieżący użytkownik jest uprawiony
end desc

sql
   select
/*----------------PlanContainer.java*/
/*1*/ SPACE(60) as SYM,
/*2*/ SPACE(100) as NAZ,
/*3*/ 0 as PARALLEL,
/*4*/ ' ' as LAYERS,
/*3*/ 0 as LP,
/*----------------PlanView.java*/
/*5*/ SPACE(16) as PL_WZOR,
/*6*/ ' ' as MODR
   from SYSLOG
   where 1=0
end sql

formula
   PL_WZOR.cntx_psh();
   PL_WZORU.cntx_psh();
   PL_WZORU.index('USERS');
   PL_WZORU.prefix(OPERATOR.USER,'T');
   {? PL_WZORU.first()
   || {!
      |? PL_WZORU.PL_WZOR();
         :RS.blank();
         :RS.SYM:=PL_WZOR.NAZWA;
         :RS.NAZ:=PL_WZOR.NAZWA;
         :RS.PL_WZOR:=$PL_WZOR.ref();
         {? exec('has_upr4wzor','po_param')>0
         || :RS.MODR:='T'
         || :RS.MODR:='N'
         ?};
         :RS.LP:=PL_WZOR.LP;
         :RS.add();
         PL_WZORU.next()
      !}
   ?};
   PL_WZORU.cntx_pop();
   PL_WZOR.cntx_pop();
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc patterns

desc
   Wzorce okresów planowania
end desc

params
   PL_WZOR:='' String[16], Ref SQL widoku planu
end params

sql
   select
      SPACE(100) as NAME,
      ' ' as KIND,
      0 as LP
   from SYSLOG
   where 0=1
end sql

formula
   _pl_wzor:=exec('FindAndGet','#table',PL_WZOR,:PL_WZOR,,,null());
   {? _pl_wzor<>null()
   ||
      PL_OPIS.cntx_psh();
      PL_OPIS.index('PL_OPIS');
      PL_OPIS.prefix(_pl_wzor);
      {? PL_OPIS.first()
      || {!
         |?
            :RS.NAME:=PL_OPIS.OPIS;
            :RS.KIND:=PL_OPIS.RODZAJ;
            :RS.LP:=PL_OPIS.NUMER;
            :RS.add();
            PL_OPIS.next()
         !}
      ?};
      PL_OPIS.cntx_pop()
   ?};
   ~~
end formula

end proc

#-----------------------------------------------------------------------------------------------------------------------

proc getplres

desc
   Zwraca zasoby planistyczne dla danego widoku planu
end desc

params
   PL_WZOR:='' String[16], Ref SQL widoku
end params

sql
   select
/*----------------PlanContainer.java*/
/*1*/ SPACE(60) as SYM,
/*2*/ SPACE(100) as NAZ,
/*3*/ 0 as PARALLEL,
/*4*/ SPACE(1) as LAYERS,
/*5*/ 0 as LP,
/*----------------Plres.java*/
/*5*/ SPACE(1) as TYP,
/*6*/ SPACE(16) as REF_ZAS
   from SYSLOG
   where 1=0
end sql

formula

   _pl_wzor:=exec('FindAndGet','#table',PL_WZOR,:PL_WZOR,,,null());
   {? _pl_wzor<>null()
   || PL_OPIS.cntx_psh();
      PL_OPIS.index('PL_OPIS');
      PL_OPIS.prefix(_pl_wzor);
      {? PL_OPIS.first()
      || {!
         |?
            {? PL_OPIS.PL_RES<>null()
            || PL_OPIS.PL_RES();
               :RS.blank();
               :RS.SYM:=PL_RES.SYM;
               :RS.NAZ:=PL_RES.NAZ;
               :RS.PARALLEL:=#PL_RES.PARALLEL;
               :RS.LAYERS:=PL_RES.LAYERS;
               :RS.LP:=PL_OPIS.NUMER;
               :RS.TYP:=PL_RES.TYP;
               :RS.REF_ZAS:=$PL_RES.ref();
               :RS.add()
            ?};
            PL_OPIS.next()
         !}
      ?};
      PL_OPIS.cntx_pop()
   ?};
   ~~
end formula

end proc


#-----------------------------------------------------------------------------------------------------------------------

proc lock_view

desc
   Blokowanie widoku na czas pracy na nim
end desc

params
   PL_WZOR String[16], PL_WZOR.ref() - widok planu
end params

sql
   select
      SPACE(16) as PL_RES,
      0 as LOCKED
   from SYSLOG
   where 0=1
end sql

formula
   _can_continue:=1;
   _pl_wzor:=exec('FindAndGet','#table',PL_WZOR,:PL_WZOR,,,null());
   {? _pl_wzor<>null()
   ||
      _can_continue:=exec('has_upr4wzor','po_param',_pl_wzor);
      {? _can_continue>0
      ||
         PL_OPIS.cntx_psh();
         PL_OPIS.index('PL_OPIS');
         PL_OPIS.prefix(_pl_wzor);
         {? PL_OPIS.first()
         || {!
            |?
               {? PL_OPIS.PL_RES<>null()
               || _msg:='Zasób planistyczny: %1 jest redagowany'@[PL_OPIS.PL_RES().SYM];
                  _locked:=exec('blk_lock','#table','PL_RES',PL_OPIS.PL_RES,,1,_msg,,1);
                  :RS.blank();
                  :RS.PL_RES:=$PL_OPIS.PL_RES;
                  :RS.LOCKED:=_locked;
                  :RS.add()
               ?};
               PL_OPIS.next()
            !}
         ?};
         PL_OPIS.cntx_pop()
      || _msg:='Brak uprawnień do redagowania widoku planu: %1'@[exec('record','#to_string',_pl_wzor)];
         KOMM.add(_msg,2,,1)
      ?}
   ?};
   ~~
end formula
end proc


#-----------------------------------------------------------------------------------------------------------------------

proc unlock_view

desc
   Odblokowanie widoku
end desc

params
   PL_WZOR String[16], PL_WZOR.ref() - widok planu
end params

sql
   select
      SPACE(16) as PL_RES,
      0 as LOCKED
   from SYSLOG
   where 0=1
end sql

formula
   _pl_wzor:=exec('FindAndGet','#table',PL_WZOR,:PL_WZOR,,,null());
   {? _pl_wzor<>null()
   || PL_OPIS.cntx_psh();
      PL_OPIS.index('PL_OPIS');
      PL_OPIS.prefix(_pl_wzor);
      {? PL_OPIS.first()
      || {!
         |?
            {? PL_OPIS.PL_RES<>null()
            || exec('blk_unlock','#table','PL_RES',PL_OPIS.PL_RES);
               :RS.blank();
               :RS.PL_RES:=$PL_OPIS.PL_RES;
               :RS.LOCKED:=0;
               :RS.add()
            ?};
            PL_OPIS.next()
         !}
      ?};
      PL_OPIS.cntx_pop()
   ?};
   ~~
end formula
end proc


#-----------------------------------------------------------------------------------------------------------------------

proc lock_res

desc
   Blokowanie zasobu na czas pracy na nim
end desc

params
   PL_WZOR String[16], PL_WZOR.ref() - widok planu
   PL_RES String[16], PL_RES.ref() - zasób planu
end params

sql
   select
      0 as LOCKED
   from SYSLOG
   where 0=1
end sql

formula
   PL_RES.cntx_psh(); PL_RES.prefix();
   _pl_wzor:=exec('FindAndGet','#table',PL_WZOR,:PL_WZOR,,,null());
   {? _pl_wzor<>null()
   ||
      _can_continue:=exec('has_upr4wzor','po_param',_pl_wzor);
      {? _can_continue>0
      ||
         {? PL_RES.seek(:PL_RES)
         || _msg:='Zasób planistyczny: %1 jest redagowany'@[PL_RES.SYM];
            _locked:=exec('blk_lock','#table','PL_RES',PL_RES.ref(),,1,_msg,,1);
            :RS.blank();
            :RS.LOCKED:=_locked;
            :RS.add()
         ?}
      || _msg:='Brak uprawnień do redagowania widoku planu: %1'@[exec('record','#to_string',_pl_wzor)];
         KOMM.add(_msg,2,,1)
      ?}
   ?};
   PL_RES.cntx_pop();
   ~~
end formula
end proc


#-----------------------------------------------------------------------------------------------------------------------

proc unlock_res

desc
   Odblokowanie zasobu
end desc

params
   PL_RES String[16], PL_RES.ref() - widok planu
end params

sql
   select
      0 as LOCKED
   from SYSLOG
   where 0=1
end sql

formula
   PL_RES.cntx_psh(); PL_RES.prefix();
   {? PL_RES.seek(:PL_RES)
   || exec('blk_unlock','#table','PL_RES',PL_RES.ref());
      :RS.blank();
      :RS.LOCKED:=0;
      :RS.add()
   ?};
   PL_RES.cntx_pop();
   ~~
end formula
end proc


#Sign Version 2.0 jowisz:1045 2022/06/30 14:29:25 37528ccd45bacf346395f2931299f7b4109b7abb72db91cf82beac2a321a0a18ca4ba24762ea23c30b5e2b6f81ad1f9f84fbb1f373fef4aca8eb32d7e04fb103636ecf599dc2714f0ae0c6618de65985d852046f3c30775a0451e909a16368fe9446252b313574abe5a2262f1dab43e76b39378ec6c3cae28707093269288963
