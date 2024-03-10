:!UTF-8
# Procedury wbudowane z systemu PULPIT


proc add_token
# Dodaje token do tabeli TOKEN
params
   USER  String[41]
   WYNIK:='' String[25]
end params

formula
   TOKEN.cntx_psh();
   TOKEN.index('USER');
   TOKEN.prefix();
   TOKEN.USERNAME:=:USER;
   TOKEN.CREATED:=tm_stamp(date()~1,date()~2,date()~3,time()~1,time()~2,time()~3);
   __token:=(11- username())+$TOKEN.CREATED;
   TOKEN.TOKENID:=__token;
   TOKEN.add();
   TOKEN.cntx_pop();
   :WYNIK:=__token
end formula

sql
   select TOKENID as WYNIK from TOKEN where 2=1
end sql

formula
   :RS.WYNIK:=:WYNIK;
   :RS.add()
end formula
end proc


proc del_token
# Weryfikacja uzytkowniaka dla QLIKA z nowymi tokenami
params
   ID  String[20]
end params

sql
   select space(10) USERNAME, space(20) TOKENID, 0 CREATED from SYSLOG where 2=1
end sql

formula
	:RS.USERNAME:=sec_token_validate(:ID,'qlik');
	:RS.CREATED:=0;
	:RS.TOKENID:=:ID;
	:RS.add()
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:37 c0d4cec83ba99ee3ea8d50ab7b206df21d6d3d5726ea6ed5872abea08f768adfe9a44bf6cc7fa93346fd74a90678b1284a0f4a9ada8cecc4ae60f027ba9ee4720cdcb74a92efe8ccc04f8e6e3f85b21ac36f8ebd56633b78c1c6bd94baa3406d6c6631d2abc860bbf8f275d05eeff63543a88dd2a31171e28b3a12a3b5428b51
