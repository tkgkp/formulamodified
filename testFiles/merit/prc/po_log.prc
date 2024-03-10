:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#========================================================================================================================
# Nazwa pliku: po_log.prc [2010]
# Utworzony: 16.04.2009
# Autor: WH
# Systemy: PROD
#========================================================================================================================
# Zawartosc: Procedury do pobierania informacji z loga
#========================================================================================================================


#----------------------------------------------------------------------------------------------------------------------
proc getlog

desc
   Zwraca wpisy z loga aplikacji od ostatniego logowania
end desc

params
   ILEWSTE:=2 INTEGER, Od ilu logowan wstecz pobieram log
end params

sql
   select
        '                                                                                                            ' as LINE
   from SYSLOG
   where 1=0
end sql

formula
   _app_name:=app_info('pth_name');

#szukam najpierw linii od ktorej chce pobrac dane (od ostatniego logowania)
   _login_nr:=exec('get_login_line','po_plan',_app_name,:ILEWSTE);
   _file_name:=_app_name+'.log';
   _file:=fopen(_file_name,'Ur',1);
   _line_nr:=0;
   {? _file>0
   || {! |? _line:=fread(_file);_line<>'\n'
      |! {? _line_nr>=_login_nr
         || :RS.LINE:=_line;
            :RS.add()
         ?};
         _line_nr+=1
      !};
      fclose(_file)
   ?}
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:37 e1b1f0644caf3cdeffe5c7665c15ef02d41400ce077d33734f74cf18417162e431d4b6999a469b401f831a98a404c1effb88b5c8346cf76de61bc46f75c7896ebd14e60fa65f572b60a71d80540ac5dd3d2f20f9b13e0419a62bed62ba90b333777e95f8f4e6493f75a16db4b0589778723635cabe824d1a64dabc35c584f2b3
