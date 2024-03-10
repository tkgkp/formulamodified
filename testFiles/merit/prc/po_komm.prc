:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#========================================================================================================================
# Nazwa pliku: komm.prc [2009]
# Utworzony: 28.04.2008
# Autor: TS
# Systemy: PROD
#========================================================================================================================
# Zawartosc: Procedury do obslugi komunikatow
#========================================================================================================================


proc init

desc
   Inicjuje obiekt KOMM do obsługi komunikatów
end desc

params
   MSG_NUM:=300 Integer, Maksymalna ilość komunikatów
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=KOMM.init(250,:MSG_NUM);
   :RS.add()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc add

desc
   Dodaje komunikat
end desc

params
   MESSAGE String[250], Treść komunikatu/sekcji
   ICON:=0 Integer, Numer ikony z pliku xwin16.png
   COLOR:='' String[23], Kolor komunikatu
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=KOMM.add(:MESSAGE,:ICON,:COLOR);
   :RS.add()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc sect_beg

desc
   Otwiera sekcję
end desc

params
   MESSAGE String[250], Treść komunikatu/sekcji
   ICON:=0 Integer, Numer ikony z pliku xwin16.png
   COLOR:='' String[23], Kolor komunikatu
end params

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=KOMM.sect_beg(:MESSAGE,:ICON,:COLOR);
   :RS.add()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc sect_end

desc
   Zamyka sekcję
end desc

sql
   select
      0 as RESULT
   from SYSLOG
   where 0=1
end sql

formula
   :RS.RESULT:=KOMM.sect_end();
   :RS.add()
end formula

end proc

#----------------------------------------------------------------------------------------------------------------------

proc get

desc
   Pobiera listę komunikatów
end desc

sql
   select
      0 as PARENT,
      0 as LP,
      '                                                                                                                                                                                                                                                          ' as MESSAGE,
      '255:255:255,255:255:255' as COLOR,
      '01234567890123456789.bmp:888' as ICON
   from SYSLOG
   where 0=1
end sql

formula
   {? ~KOMM.TABisOK || KOMM.transfer() ?};
   KOMM.TAB.clear();
   {? KOMM.TAB.first()
   || {!
      |?
         :RS.PARENT:=KOMM.TAB.PARENT;
         :RS.LP:=#KOMM.TAB.ref();
         :RS.MESSAGE:=KOMM.TAB.MESSAGE;
         :RS.COLOR:=KOMM.TAB.COLOR;
         :RS.ICON:=KOMM.TAB.ICONC;
         :RS.add();
         KOMM.TAB.next()
      !}
   ?}
end formula

end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:37 a96986608ef4e64594f43b9d05eaad0654c3c3767b7b53c7d347ba14c11f0a4ee8754a1ef67d17758e5854bca96550f047c9857bbe80e1f4bce4a90f7b490a4e72c5ba3203f590f8698d0ddcec95b9e5b3de07aa2fd64dc20815dccb7582a68681c6f7dd5de8f02155f101e48c34c5c4e0c665cc29f243234245719c2f427268
