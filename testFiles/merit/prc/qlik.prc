:!UTF-8
proc get_url_param
desc
  Tabela zwraca parametry połączenia
end desc

sql   
 select 
  '                                                                    ' as ADDRES,
  '                                                                    ' as "GROUP",
  '                                                                    ' as APPL,
  '                                                                                                                                            ' as URI_HTML
 from
     syslog
 where
    1=2
end sql

formula
 exec('czytaj','#stalesys',,XINFO,'LINK_SRV','LINK_PRT');
   {? XINFO.LINK_SRV='' | XINFO.LINK_PRT=0
   || _server:=exec('server','#system');
      _address:='%1:%2'[_server.address,_server.port]
   || _address:='%1:%2'[XINFO.LINK_SRV,$XINFO.LINK_PRT]
   ?};

 _group:=app_info('cluster_group');
 _appl:=REF.FIRMA().APP_IDEN;
 _uri_html:=exec('link_uri','#system',exec('obj_ntab_set','#array',,'LINK',REM_ZAS.uidref()),XINFO.LINK_INT);

 :RS.ADDRES:=_address;
 :RS.GROUP:=_group;
 :RS.APPL:=_appl;
 :RS.URI_HTML:=_uri_html;
 :RS.add()

end formula

end proc

#Sign Version 2.0 jowisz:1045 2022/06/30 14:29:25 5fc61da177becc0b056765bc2be29bb9e12bdf1821c36ba11988a8e501681d719aa4250313355377f12b8864cd549de1524356a93a303d0106adb524cee9ef1fb488067587ae5805735814b5f27848a4ca43a1ad4ef5faf640f9b5069d6d7ff33064037df0f4283d0e91097c84b7d7a59e4eac88028e94ee20753268f3a0bf37
