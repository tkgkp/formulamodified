

proc zlecenia
params
   DataOd DATE
   DataDo DATE
end params

formula
{? var_pres('pola')<100 || pola:=obj_new(19) ?};
{? var_pres('rubryki')<100 || rubryki:=obj_new(19) ?};
pola[1]:="_a.KW+=";rubryki[1]:=500;
pola[2]:="_a.FE+=";rubryki[2]:=765;
pola[3]:="_a.FR+=";rubryki[3]:=766;
pola[4]:="_a.FC+=";rubryki[4]:=767;
pola[5]:="_a.FW+=";rubryki[5]:=960;
pola[6]:="_a.FP+=";rubryki[6]:=982;
pola[7]:="_a.FG+=";rubryki[7]:=983;
pola[8]:="_a.KU+=";rubryki[8]:=784;
pola[9]:="_a.ZDOCH+=";rubryki[9]:=800;
pola[10]:="_a.POD+=";rubryki[10]:=797;
pola[11]:="_a.ZPOD+=";rubryki[11]:=795;
pola[12]:="_a.KCHP+=";rubryki[12]:=792;
pola[13]:="_a.KCHO+=";rubryki[13]:=793;
pola[14]:="_a.NETTO+=";rubryki[14]:=990;
pola[15]:="_a.FRZ+=";rubryki[15]:=959;
pola[16]:="_a.FEZ+=";rubryki[16]:=958;
pola[17]:="_a.POD+=";rubryki[17]:=798;
pola[18]:="_a.ZAS+=";rubryki[18]:=650;
pola[19]:="_a.FEP+=";rubryki[19]:=962;
{? var_pres('tab')>100 || obj_del(tab) ?};
{? var_pres('tab_p')>100 || obj_del(tab_p) ?};
tab:=sql('select ZC.OSOBA OSOBA, RH.REFERENCE REF, OSOBA.NAZWISKO, OSOBA.PIERWSZE, OSOBA.PESEL, ZC.DU, ZC.DW DDO,
                 RU.O OPIS, UD_SKL.SYMBOL ODD, UD_SKL.OPIS NAZWA_OD, R.RN RN, RH.DWY DRACH, LS.KW KW
          from ZC join RH using(ZC.REFERENCE,RH.ZLE) join LS using(RH.REFERENCE,LS.RH) join RU using(RU.REFERENCE,ZC.RU)
               join OSOBA using(OSOBA.REFERENCE,ZC.OSOBA) join UD_SKL using(UD_SKL.REFERENCE,ZC.WYDZIAL)
               join R using(R.REFERENCE,LS.RB)
          where 1=2
          order by 1,2,RN');
_ndx:=RH.ndx_tmp(,1,'O','FIRMA',,'DWY',,);
RH.index(_ndx);
RH.prefix(exec('ref_firma','ustawienia'));
{? RH.find_ge(:DataOd)
|| {!
   |?
      {? RH.DWY>=:DataOd & RH.DWY<=:DataDo
      || LS.use(RH.O().LT);
         tab_p:=sql('select ZC.OSOBA OSOBA, RH.REFERENCE REF, OSOBA.NAZWISKO, OSOBA.PIERWSZE, OSOBA.PESEL, ZC.DU,
                            ZC.DW DDO, RU.O OPIS, UD_SKL.SYMBOL ODD, UD_SKL.OPIS NAZWA_OD, R.RN RN, RH.DWY DRACH,
                            LS.KW KW
                     from ZC join RH using(ZC.REFERENCE,RH.ZLE) join LS using(RH.REFERENCE,LS.RH)
                          join RU using(RU.REFERENCE,ZC.RU) join OSOBA using(OSOBA.REFERENCE,ZC.OSOBA)
                          join UD_SKL using(UD_SKL.REFERENCE,ZC.WYDZIAL) join R using(R.REFERENCE,LS.RB)
                          join P using (ZC.P,P.REFERENCE)
                     where RH.REFERENCE=\':_a\' and
                           R.RN in (500,650,765,766,767,960,982,983,784,800,797,795,792,793,990,959,958,798,962) and
                           P.FIRMA=:_b
                     order by 1,2,RN',
                     $RH.ref(),exec('ref_firma','ustawienia'));

         {? tab_p.first
         || {!
            |?
               tab.blank(1);
               {! _ind:=1..tab_p.fld_num
               |! _acr:=tab_p.fld_acr(_ind);
                  ($('tab.'+_acr))():=($('tab_p.'+_acr))()
               !};
               tab.add;
               tab_p.next
            !}
         ?};
         &tab_p
      ?};
      RH.next & RH.DWY<=:DataDo
   !}
?};
RH.ndx_drop(_ndx)
end formula

sql
select '                    ' OSOBA,
       '                              ' NAZWISKO,
       '                    ' PIERWSZE,'           ' PESEL,
       0.1-0.1 KW, 0.1-0.1 ZAS, 0.1-0.1 FE, 0.1-0.1 FR, 0.1-0.1 FC,
       0.1-0.1 FW, 0.1-0.1 FP, 0.1-0.1 FG, 0.1-0.1 KU, 0.1-0.1 ZDOCH,
       0.1-0.1 POD, 0.1-0.1 ZPOD, 0.1-0.1 KCHP, 0.1-0.1 KCHO, 0.1-0.1 NETTO,
       0.1-0.1 FRZ, 0.1-0.1 FEZ, 0.1-0.1 FEP, CAST('2004-1-1' as DATE_TYPE) DWY,
       '                ' ODD, '                                                            ' NAZWA_OD,
       '                                                                             ' OPIS
       from syslog where 2=1
       order by 2,3,4,DWY
end sql

formula
{? tab.first ||
   {! |?
      tab.prefix(tab.OSOBA, tab.REF);
      :RS.blank;
      :RS.OSOBA:=tab.OSOBA;
      :RS.NAZWISKO:=tab.NAZWISKO;
      :RS.PIERWSZE:=tab.PIERWSZE;
      :RS.PESEL:=tab.PESEL;
      :RS.ODD:=tab.ODD;
      :RS.DWY:=tab.DRACH;
      :RS.NAZWA_OD:=tab.NAZWA_OD;
      :RS.OPIS:=tab.OPIS + ' od ' + $tab.DU + ' do ' + $tab.DDO;
      {! _i:=1 .. 19 |!
         {? tab.find_key(rubryki[_i]) ||
            ($(pola[_i]+$form(tab.KW,,2,'9.')))(:RS)
         ?}
      !};
      :RS.add;
      tab.last;
      tab.prefix;
      tab.next
   !}
?};
obj_del(tab);
obj_del(pola);
obj_del(rubryki)
end formula
end proc


proc zlec_009

desc
  Rozliczenie surowców
end desc

params
 WYD STRING[16], Wydział (w formacie REFERENCE)
 OKR STRING[16], Okres (w formacie REFERENCE)
 OPCJA STRING[1], Opcja sumowania - po Zleceniach, po Surowcach, Nie sumuj
end params

formula
end formula

sql
# tylko schamat wyniku
   select
      M.KTM as KTM,
      M.N as NAZ,
      M.REFERENCE as T_REF,
      JM.KOD as JM,
      0/2 as IL_P,
      0/2 as IL_Z,
      0/2 as WAR_P,
      0/2 as WAR_Z,
      ZL.SYM as ZL,
      ZL.OPIS as O,
      ZL.REFERENCE as ZL_REF
   from ZL
      join M using(ZL.KTM,M.REFERENCE)
      join JM using(M.J,JM.REFERENCE)
   where 0=1
end sql

formula

_rok:=OKR.ROK;
_mc:=OKR.MC;

_lista:='';
   _lista+=exec('get','#params',500707);
   _lista+=exec('get','#params',500709);
   _typdok:=exec('GetTabFromList','#table','TYPYDOK','T',_lista);

{? :OPCJA='Z'
||
   _tmp:=sql('
      select
         sum(case when DK.PLUS=\'N\' then DK.WAR else 0 end) as WAR_P,
         sum(case when DK.PLUS=\'T\' then DK.WAR else 0 end) as WAR_Z,
         ZL.SYM as ZL,
         ZL.REFERENCE as ZL_REF,
         ZL.OPIS as O
      from @DK join @ND
      left join ZL using(DK.ZL,ZL.REFERENCE)
      where ND.AR=:_a and ND.AM=:_b and ND.TYP in (select :_d.SQLREF from :_d)
    group by ZL.REFERENCE, ZL.SYM, ZL.OPIS
   ',_rok,_mc,:WYD,_typdok)

|? :OPCJA='S'
||
   _tmp:=sql('
      select
         M.KTM as KTM,
         M.N as NAZ,
         M.REFERENCE as T_REF,
         JM.KOD as JM,
         sum(case when DK.PLUS=\'N\' then DK.IL else 0 end) as IL_P,
         sum(case when DK.PLUS=\'T\' then DK.IL else 0 end) as IL_Z,
         sum(case when DK.PLUS=\'N\' then DK.WAR else 0 end) as WAR_P,
         sum(case when DK.PLUS=\'T\' then DK.WAR else 0 end) as WAR_Z
      from @DK join @ND
      join M using(DK.M,M.REFERENCE)
      join JM using(M.J,JM.REFERENCE)
      where ND.AR=:_a and ND.AM=:_b and ND.TYP in (select :_d.SQLREF from :_d)
      group by M.KTM, M.N, M.REFERENCE, JM.KOD
   ',_rok,_mc,:WYD,_typdok)

|? :OPCJA='N'
||
   _tmp:=sql('
      select
         M.KTM as KTM,
         M.N as NAZ,
         M.REFERENCE as T_REF,
         JM.KOD as JM,
         sum(case when DK.PLUS=\'N\' then DK.IL else 0 end) as IL_P,
         sum(case when DK.PLUS=\'T\' then DK.IL else 0 end) as IL_Z,
         sum(case when DK.PLUS=\'N\' then DK.WAR else 0 end) as WAR_P,
         sum(case when DK.PLUS=\'T\' then DK.WAR else 0 end) as WAR_Z,
         ZL.SYM as ZL,
         ZL.REFERENCE as ZL_REF,
         ZL.OPIS as O
      from @DK join @ND
      join M using(DK.M,M.REFERENCE)
      join JM using(M.J,JM.REFERENCE)
      join ZL using(DK.ZL,ZL.REFERENCE)
      where ND.AR=:_a and ND.AM=:_b and ND.TYP in (select :_d.SQLREF from :_d)
      group by M.KTM, M.N, M.REFERENCE, JM.KOD, ZL.SYM, ZL.REFERENCE, ZL.OPIS
   ',_rok,_mc,:WYD,_typdok)
?};
{? _tmp.first()
|| {!
   |?
      :RS.blank();
      {?'SN'*:OPCJA>0
      || :RS.KTM:=_tmp.KTM;
         :RS.NAZ:=_tmp.NAZ;
         :RS.T_REF:=_tmp.T_REF;
         :RS.JM:=_tmp.JM;
         :RS.IL_P:=_tmp.IL_P;
         :RS.IL_Z:=_tmp.IL_Z
      ?};
      :RS.WAR_P:=_tmp.WAR_P;
      :RS.WAR_Z:=_tmp.WAR_Z;
      {? 'ZN'*:OPCJA>0
      || :RS.ZL:=_tmp.ZL;
         :RS.ZL_REF:=_tmp.ZL_REF;
         :RS.O:=_tmp.O
      ?};
      :RS.add();
      _tmp.next()
   !}
?}
end formula

end proc


proc result
sql
   select 0 as wyn from FIRMA where 1=0
end sql

formula
  :RS.clear();
  :RS.blank();
  :RS.WYN:=1;
  :RS.add(1)
end formula
end proc

proc result2
sql
   select 0 as wyn from FIRMA where 1=0
end sql

formula
  :RS.clear();
  :RS.blank();
  :RS.WYN:=1;
  :RS.add(1)
end formula
end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:37 68f70e6a6095013d4724e6dace1becd5d52bcb5c1afc2232b50f909902e80b452b2a443b77122b9f67550e25ecf6851fababea1b38c8c858ab4b8403aa9c7b174071b27cfc8a14df8c9c05139b48bb88f4bde9a449760502bf64e775cd7bac056f79f621b82354fae6079588a8d8ab14ce811cd69bffe85ade11fe6b47d18b7a
