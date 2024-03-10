:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#========================================================================================================================
# Nazwa pliku: profiles.prc [12.10]
# Utworzony: 08.04.2011
# Autor: WH
#========================================================================================================================
# Zawartosc: Procedury wywolywane po nawiazaniu polaczenia z ODBC (alokacja niezbednych obiektow, zmiennych itp)
#========================================================================================================================


proc orderplan

desc
   Inicjalizacja modulu orderplan.jar
end desc

formula

#  wczytanie parametrów pracy i otwarcie tabel maskowalnych
   exec('__PARSES','#object');
   exec('define','parses',__PARSES);
   __PARSES.setEnv('TPP_PPO');

#  exec('to_file','libfml','poplan.dbg',0,ST.ODDZ+' '+$ST.AR,0);

#  deklaracja klasy do obslugi parametrow technologii
   exec('Tpar_decl','tech_param');

#  FUN
   exec('fun_decl','#message');

#  Init obszarowy
   exec('init','tpp');
   ~~
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:37 d41c3d50eefd5153692974e064751432166c747aa1e3d963b96ef5fbbc9bcfaaf0c5b5df6409aab87caa348a055dc88a08a4e1e3abf57b1ceb20bf2e6719f12c0f345077af5161eaf22ac004660fb7b28d02b0e50f4b033fbe1ad3db0a62b6934b71b22f726dcab28ad173cbc6fe37159edd908021a40ba3a2d4186263eff5ab
