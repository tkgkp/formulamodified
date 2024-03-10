:!UTF-8
# (c) Macrologic S.A. Wszelkie prawa zastrzezone
#=======================================================================================================================
# Nazwa pliku: kontrol.prc [2011]
# Utworzony: 12.10.2009
# Autor: MB
# Systemy: KONTROL
#=======================================================================================================================
# Zawartosc: Procedury do wymiany danych EXCEL
#=======================================================================================================================


proc poz_bud
desc
   schemat danych
end desc
params
   MODEL:='MODEL' String[8]
   TYP:='PODZORG' String[8]
   SCHEMAT:='STRORG' String[8]
end params

formula
   SKID_MBN.index('KOD'); SKID_MBN.prefix(:MODEL);
   {? SKID_MBN.first() & SKID_MBN.KOD=:MODEL
   || SKID_MBP.index('LP'); SKID_MBP.prefix(SKID_MBN.ref(),1);
      {? SKID_MBP.first()
      || :SCHEMAT:=SKID_MBP.UD_SCH().SYMBOL;
         :TYP:=UD_SCH.UD_TYP().SYMBOL
      || :SCHEMAT:='';
         :TYP:=''
      ?}
   ?}
end formula

sql
   select
      UD_DEF.UD_SKL REF,
      UD_DEF.REFERENCE REF_NAD,
      UD_DEF.SYMBOL SYMBOL,
      UD_DEF.OPIS OPIS,
      UD_DEF.ZN_AGR as MNOZNIK,
      '                                                                                                    '||
      '                                                                                                    '
      as F1,
      '                                                                                                    '||
      '                                                                                                    '
      as F2,
      '                                                                                                    '||
      '                                                                                                    '
      as F3,
      '                                                                                                    '||
      '                                                                                                    '
      as F4,
      '                                                                                                    '||
      '                                                                                                    '
      as F5,
      '                                                                                                    '||
      '                                                                                                    '
      as F6,
      '                                                                                                    '||
      '                                                                                                    '
      as F7,
      '                                                                                                    '||
      '                                                                                                    '
      as F8,
      '                                                                                                    '||
      '                                                                                                    '
      as F9,
      '                                                                                                    '||
      '                                                                                                    '
      as F10,
      '                                                                                                    '||
      '                                                                                                    '
      as F11,
      '                                                                                                    '||
      '                                                                                                    '
      as F12,
      '                                                                                                    '||
      '                                                                                                    '
      as F13,
      '                                                                                                    '||
      '                                                                                                    '
      as F14,
      cast('' as SYS_MEMO_TYPE) as F15

   from
      UD_DEF join
      UD_SCH join
      UD_TYP join SKIDXDUD using (UD_DEF.UD_SKL,SKIDXDUD.POZ_BUD)
      join UD_SKL using (UD_DEF.UD_SKL,UD_SKL.REFERENCE)
   where
      UD_TYP.SYMBOL=:TYP and UD_SCH.SYMBOL=:SCHEMAT
end sql

formula
   UD_DEF.clear;
   {? :RS.first
   || SKID_MBP.NAZ:=exec('olap_dim_name','control',SKID_MBP.NAZ);
      {!
      |? _f:=exec('formula','control',:RS.REF_NAD,:MODEL);
         :RS.F1:=200+_f; _f:=200-_f;
         :RS.F2:=200+_f; _f:=200-_f;
         :RS.F3:=200+_f; _f:=200-_f;
         :RS.F4:=200+_f; _f:=200-_f;
         :RS.F5:=200+_f; _f:=200-_f;
         :RS.F6:=200+_f; _f:=200-_f;
         :RS.F7:=200+_f; _f:=200-_f;
         :RS.F8:=200+_f; _f:=200-_f;
         :RS.F9:=200+_f; _f:=200-_f;
         :RS.F10:=200+_f; _f:=200-_f;
         :RS.F11:=200+_f; _f:=200-_f;
         :RS.F12:=200+_f; _f:=200-_f;
         :RS.F13:=200+_f; _f:=200-_f;
         :RS.F14:=200+_f; _f:=200-_f;
         {? _f<>''
         || :RS.memo_set(_f,'F15');
            :RS.memo_put(,'F15')
         || _f:=' ';
            :RS.memo_set(_f,'F15');
            :RS.memo_put(,'F15')
         ?};
         :RS.REF_NAD:=
            {? UD_DEF.seek(BIT.sqlint(:RS.REF_NAD),)
            || {? UD_DEF.seek(UD_DEF.UD_DEF,)
               || BIT.refsql(UD_DEF.UD_SKL)
               || ''
               ?}
            || ''
            ?};
         :RS.put;
         :RS.next
      !}
   ?}
end formula
end proc


proc schemat
desc
   schemat danych
end desc
params
   MODEL:='MODEL' String[8]
   NR:=1 INTEGER
   TYP:='PODZORG' String[8]
   SCHEMAT:='STRORG' String[8]
end params

formula
   SKID_MBN.index('KOD'); SKID_MBN.prefix(:MODEL);
   {? SKID_MBN.first() & SKID_MBN.KOD=:MODEL
   || SKID_MBP.index('LP'); SKID_MBP.prefix(SKID_MBN.ref(),:NR);
      {? SKID_MBP.first()
      || :SCHEMAT:=SKID_MBP.UD_SCH().SYMBOL;
         :TYP:=UD_SCH.UD_TYP().SYMBOL
      || :SCHEMAT:='';
         :TYP:=''
      ?}
   ?}
end formula

sql
   select
      UD_DEF.UD_SKL REF,
      UD_DEF.REFERENCE REF_NAD,
      UD_DEF.SYMBOL SYMBOL,
      UD_DEF.OPIS OPIS
   from
      UD_DEF join
      UD_SCH join
      UD_TYP join UD_SKL using (UD_DEF.UD_SKL,UD_SKL.REFERENCE)
   where
      UD_TYP.SYMBOL=:TYP and UD_SCH.SYMBOL=:SCHEMAT
end sql

formula
   UD_DEF.clear;
   {? :RS.first
   || {!
      |? :RS.REF_NAD:=
            {? UD_DEF.seek(BIT.sqlint(:RS.REF_NAD),)
            || {? UD_DEF.seek(UD_DEF.UD_DEF,)
               || BIT.refsql(UD_DEF.UD_SKL)
               || ''
               ?}
            || ''
            ?};
         :RS.put;
         :RS.next
      !}
   ?}
end formula
end proc


proc l_wart
desc
   liczba elemntow wartosci dla kontrolingu
end desc
params
   KOD:='000000' String[6]
end params

formula

end formula

sql
   select
      100 as SIZE
   from
      K__NAG
   where
      1=2
end sql

formula
   _size:=0;
   K__NAG.index('UNIK'); K__NAG.prefix(:KOD);
   {? K__NAG.first()
   || OKRO_F.cntx_psh();
      OKRO_F.index('ROK'); OKRO_F.prefix(K__NAG.ROK_F);
      {? OKRO_F.first()
      || {!
         |? K__POZ.use('yb'+exec('maska','control'));
            K__POZ.prefix();
            _size+=K__POZ.size();
            OKRO_F.next()
         !}
      ?};
      OKRO_F.cntx_pop()
   ?};
   :RS.SIZE:=_size;
   :RS.add()
end formula
end proc


proc wart_kod
desc
   wartosci dla kontrolingu naglowka
end desc
params
   KOD:='000000' String[6]
end params

formula

end formula

sql
   select
      WART as WARTOSC,
      WART_N as WARTOSCN,
      WART_NB as WARTOSCB,
      OKRES,
      K__NAG.K_WERSJE as WERSJA,
      CASE WHEN WYMIAR01 is null THEN 'brak' ELSE WYMIAR01 END as DIM_1,
      CASE WHEN WYMIAR02 is null THEN 'brak' ELSE WYMIAR02 END as DIM_2,
      CASE WHEN WYMIAR03 is null THEN 'brak' ELSE WYMIAR03 END as DIM_3,
      CASE WHEN WYMIAR04 is null THEN 'brak' ELSE WYMIAR04 END as DIM_4,
      CASE WHEN WYMIAR05 is null THEN 'brak' ELSE WYMIAR05 END as DIM_5,
      CASE WHEN WYMIAR06 is null THEN 'brak' ELSE WYMIAR06 END as DIM_6,
      CASE WHEN WYMIAR07 is null THEN 'brak' ELSE WYMIAR07 END as DIM_7,
      CASE WHEN WYMIAR08 is null THEN 'brak' ELSE WYMIAR08 END as DIM_8,
      CASE WHEN WYMIAR09 is null THEN 'brak' ELSE WYMIAR09 END as DIM_9,
      CASE WHEN WYMIAR10 is null THEN 'brak' ELSE WYMIAR10 END as DIM_10,
      CASE WHEN WYMIAR11 is null THEN 'brak' ELSE WYMIAR11 END as DIM_11,
      CASE WHEN WYMIAR12 is null THEN 'brak' ELSE WYMIAR12 END as DIM_12,
      CASE WHEN WYMIAR13 is null THEN 'brak' ELSE WYMIAR13 END as DIM_13,
      CASE WHEN WYMIAR14 is null THEN 'brak' ELSE WYMIAR14 END as DIM_14,
      CASE WHEN WYMIAR15 is null THEN 'brak' ELSE WYMIAR15 END as DIM_15
   from
      K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)
   where
      K__NAG.KOD=:KOD
   order by DIM_1
end sql

formula
   :RS.blank();
   :RS.DIM_1:='Asize';
   :RS.WARTOSC:=:RS.size();
   :RS.add()
end formula
end proc


proc wart_fun
desc
   wartosci dla kontrolingu z funkcji
end desc
params
   FIRMA:='1234567890ABCDEF' String[16]
   MODEL:='1234567890ABCDEF' String[16]
   K_WERSJA:='1234567890ABCDEF' String[16]
   OKR_OD:='1234567890ABCDEF' String[16]
   OKR_DO:='1234567890ABCDEF' String[16]
end params

formula

end formula

sql
   select
      WART as WARTOSC,
      WART_N as WARTOSCN,
      WART_NB as WARTOSCB,
      OKRES,
      K__NAG.K_WERSJE as WERSJA,
      CASE WHEN WYMIAR01 is null THEN 'brak' ELSE WYMIAR01 END as DIM_1,
      CASE WHEN WYMIAR02 is null THEN 'brak' ELSE WYMIAR02 END as DIM_2,
      CASE WHEN WYMIAR03 is null THEN 'brak' ELSE WYMIAR03 END as DIM_3,
      CASE WHEN WYMIAR04 is null THEN 'brak' ELSE WYMIAR04 END as DIM_4,
      CASE WHEN WYMIAR05 is null THEN 'brak' ELSE WYMIAR05 END as DIM_5,
      CASE WHEN WYMIAR06 is null THEN 'brak' ELSE WYMIAR06 END as DIM_6,
      CASE WHEN WYMIAR07 is null THEN 'brak' ELSE WYMIAR07 END as DIM_7,
      CASE WHEN WYMIAR08 is null THEN 'brak' ELSE WYMIAR08 END as DIM_8,
      CASE WHEN WYMIAR09 is null THEN 'brak' ELSE WYMIAR09 END as DIM_9,
      CASE WHEN WYMIAR10 is null THEN 'brak' ELSE WYMIAR10 END as DIM_10,
      CASE WHEN WYMIAR11 is null THEN 'brak' ELSE WYMIAR11 END as DIM_11,
      CASE WHEN WYMIAR12 is null THEN 'brak' ELSE WYMIAR12 END as DIM_12,
      CASE WHEN WYMIAR13 is null THEN 'brak' ELSE WYMIAR13 END as DIM_13,
      CASE WHEN WYMIAR14 is null THEN 'brak' ELSE WYMIAR14 END as DIM_14,
      CASE WHEN WYMIAR15 is null THEN 'brak' ELSE WYMIAR15 END as DIM_15
   from
      K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)
   where
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:MODEL and
      K__NAG.K_WERSJE=:K_WERSJA and
      K__NAG.K_PODWER is null and
      K__POZ.OKRES>=:OKR_OD and
      K__POZ.OKRES<=:OKR_DO
   order by 1
end sql

formula
   :RS.blank();
   :RS.DIM_1:='Asize';
   :RS.WARTOSC:=:RS.size();
   :RS.add()
end formula
end proc


proc wartokod
desc
   wartosci dla kontrolingu naglowka i dokumentow
end desc
params
   KOD:='000000' String[6]
end params

formula

end formula

sql
   select
      CASE WHEN K__WAR.REFERENCE is null THEN WART ELSE KW END as WARTOSC,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_N ELSE 0 END as WARTOSCN,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_NB ELSE 0 END as WARTOSCB,
      OKRES,
      K__NAG.K_WERSJE as WERSJA,
      CASE WHEN WYMIAR01 is null THEN 'brak' ELSE WYMIAR01 END as DIM_1,
      CASE WHEN WYMIAR02 is null THEN 'brak' ELSE WYMIAR02 END as DIM_2,
      CASE WHEN WYMIAR03 is null THEN 'brak' ELSE WYMIAR03 END as DIM_3,
      CASE WHEN WYMIAR04 is null THEN 'brak' ELSE WYMIAR04 END as DIM_4,
      CASE WHEN WYMIAR05 is null THEN 'brak' ELSE WYMIAR05 END as DIM_5,
      CASE WHEN WYMIAR06 is null THEN 'brak' ELSE WYMIAR06 END as DIM_6,
      CASE WHEN WYMIAR07 is null THEN 'brak' ELSE WYMIAR07 END as DIM_7,
      CASE WHEN WYMIAR08 is null THEN 'brak' ELSE WYMIAR08 END as DIM_8,
      CASE WHEN WYMIAR09 is null THEN 'brak' ELSE WYMIAR09 END as DIM_9,
      CASE WHEN WYMIAR10 is null THEN 'brak' ELSE WYMIAR10 END as DIM_10,
      CASE WHEN WYMIAR11 is null THEN 'brak' ELSE WYMIAR11 END as DIM_11,
      CASE WHEN WYMIAR12 is null THEN 'brak' ELSE WYMIAR12 END as DIM_12,
      CASE WHEN WYMIAR13 is null THEN 'brak' ELSE WYMIAR13 END as DIM_13,
      CASE WHEN WYMIAR14 is null THEN 'brak' ELSE WYMIAR14 END as DIM_14,
      CASE WHEN WYMIAR15 is null THEN 'brak' ELSE WYMIAR15 END as DIM_15,
      CASE WHEN ((K__WAR.REFERENCE is null) or (K__WAR.REJ is null and K__WAR.LT is null)) THEN 'brak' ELSE K__WAR.REFERENCE END as DOKUMENT,
      K__POZ.RODZAJ
   from
      K__WAR right join K__POZ using (K__POZ.REFERENCE,K__WAR.K__POZ) join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)

   where
      K__NAG.KOD=:KOD
   order by DIM_1,DIM_2,DIM_3,DIM_4,DIM_5,DIM_6,DIM_7,DIM_8,DIM_9,DIM_10,DIM_11,DIM_12,
         DIM_13,DIM_14,DIM_15,OKRES,RODZAJ,DOKUMENT
end sql

formula
   exec('nar4dok','!ctr_pdm_patw',:RS);
   :RS.blank();
   :RS.DIM_1:='Asize';
   :RS.WARTOSC:=:RS.size();
   :RS.add()
end formula
end proc


proc wartpkod
desc
   wartosci dla kontrolingu naglowka i dokumentow
end desc
params
   KOD:='000000' String[6]
end params

formula

end formula

sql
   select
      CASE WHEN K__WAR.REFERENCE is null THEN WART ELSE KW END as WARTOSC,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_N ELSE 0 END as WARTOSCN,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_NB ELSE 0 END as WARTOSCB,
      OKRES,
      K__NAG.K_WERSJE as WERSJA,
      CASE WHEN WYMIAR01 is null THEN 'brak' ELSE WYMIAR01 END as DIM_1,
      CASE WHEN WYMIAR02 is null THEN 'brak' ELSE WYMIAR02 END as DIM_2,
      CASE WHEN WYMIAR03 is null THEN 'brak' ELSE WYMIAR03 END as DIM_3,
      CASE WHEN WYMIAR04 is null THEN 'brak' ELSE WYMIAR04 END as DIM_4,
      CASE WHEN WYMIAR05 is null THEN 'brak' ELSE WYMIAR05 END as DIM_5,
      CASE WHEN WYMIAR06 is null THEN 'brak' ELSE WYMIAR06 END as DIM_6,
      CASE WHEN WYMIAR07 is null THEN 'brak' ELSE WYMIAR07 END as DIM_7,
      CASE WHEN WYMIAR08 is null THEN 'brak' ELSE WYMIAR08 END as DIM_8,
      CASE WHEN WYMIAR09 is null THEN 'brak' ELSE WYMIAR09 END as DIM_9,
      CASE WHEN WYMIAR10 is null THEN 'brak' ELSE WYMIAR10 END as DIM_10,
      CASE WHEN WYMIAR11 is null THEN 'brak' ELSE WYMIAR11 END as DIM_11,
      CASE WHEN WYMIAR12 is null THEN 'brak' ELSE WYMIAR12 END as DIM_12,
      CASE WHEN WYMIAR13 is null THEN 'brak' ELSE WYMIAR13 END as DIM_13,
      CASE WHEN WYMIAR14 is null THEN 'brak' ELSE WYMIAR14 END as DIM_14,
      CASE WHEN WYMIAR15 is null THEN 'brak' ELSE WYMIAR15 END as DIM_15,
      CASE WHEN K__WAR.REFERENCE is null or (K__WAR.LT='') THEN 'brak' ELSE K__WAR.REFERENCE END as DOKUMENT,
      K__POZ.RODZAJ
   from
      K__WAR right join K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)

   where
      K__NAG.KOD=:KOD
   order by DIM_1,DIM_2,DIM_3,DIM_4,DIM_5,DIM_6,DIM_7,DIM_8,DIM_9,DIM_10,DIM_11,DIM_12,
         DIM_13,DIM_14,DIM_15,OKRES,RODZAJ,DOKUMENT
end sql

formula
   exec('nar4dok','!ctr_pdm_patw',:RS);
   :RS.blank();
   :RS.DIM_1:='Asize';
   :RS.WARTOSC:=:RS.size();
   :RS.add()
end formula
end proc


proc wartmkod
desc
   wartosci dla kontrolingu naglowka i dokumentow
end desc
params
   KOD:='000000' String[6]
end params

formula

end formula

sql
   select
      CASE WHEN K__WAR.REFERENCE is null THEN WART ELSE KW END as WARTOSC,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_N ELSE 0 END as WARTOSCN,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_NB ELSE 0 END as WARTOSCB,
      OKRES,
      K__NAG.K_WERSJE as WERSJA,
      CASE WHEN WYMIAR01 is null THEN 'brak' ELSE WYMIAR01 END as DIM_1,
      CASE WHEN WYMIAR02 is null THEN 'brak' ELSE WYMIAR02 END as DIM_2,
      CASE WHEN WYMIAR03 is null THEN 'brak' ELSE WYMIAR03 END as DIM_3,
      CASE WHEN WYMIAR04 is null THEN 'brak' ELSE WYMIAR04 END as DIM_4,
      CASE WHEN WYMIAR05 is null THEN 'brak' ELSE WYMIAR05 END as DIM_5,
      CASE WHEN WYMIAR06 is null THEN 'brak' ELSE WYMIAR06 END as DIM_6,
      CASE WHEN WYMIAR07 is null THEN 'brak' ELSE WYMIAR07 END as DIM_7,
      CASE WHEN WYMIAR08 is null THEN 'brak' ELSE WYMIAR08 END as DIM_8,
      CASE WHEN WYMIAR09 is null THEN 'brak' ELSE WYMIAR09 END as DIM_9,
      CASE WHEN WYMIAR10 is null THEN 'brak' ELSE WYMIAR10 END as DIM_10,
      CASE WHEN WYMIAR11 is null THEN 'brak' ELSE WYMIAR11 END as DIM_11,
      CASE WHEN WYMIAR12 is null THEN 'brak' ELSE WYMIAR12 END as DIM_12,
      CASE WHEN WYMIAR13 is null THEN 'brak' ELSE WYMIAR13 END as DIM_13,
      CASE WHEN WYMIAR14 is null THEN 'brak' ELSE WYMIAR14 END as DIM_14,
      CASE WHEN WYMIAR15 is null THEN 'brak' ELSE WYMIAR15 END as DIM_15,
      CASE WHEN K__WAR.REFERENCE is null THEN 'brak' ELSE K__WAR.REFERENCE END as DOKUMENT,
      K__POZ.RODZAJ
   from
      K__WAR right join K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)

   where
      K__NAG.KOD=:KOD
   order by DIM_1,DIM_2,DIM_3,DIM_4,DIM_5,DIM_6,DIM_7,DIM_8,DIM_9,DIM_10,DIM_11,DIM_12,
         DIM_13,DIM_14,DIM_15,OKRES,RODZAJ,DOKUMENT
end sql

formula
   exec('nar4dok','!ctr_pdm_patw',:RS);
   :RS.blank();
   :RS.DIM_1:='Asize';
   :RS.WARTOSC:=:RS.size();
   :RS.add()
end formula
end proc


proc wartofun
desc
   wartosci dla kontrolingu z funkcji z dokumentami
end desc
params
   FIRMA:='1234567890ABCDEF' String[16]
   MODEL:='1234567890ABCDEF' String[16]
   K_WERSJA:='1234567890ABCDEF' String[16]
   OKR_OD:='1234567890ABCDEF' String[16]
   OKR_DO:='1234567890ABCDEF' String[16]
end params

formula

end formula

sql
   select
      CASE WHEN K__WAR.REFERENCE is null THEN WART ELSE KW END as WARTOSC,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_N ELSE 0 END as WARTOSCN,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_NB ELSE 0 END as WARTOSCB,
      OKRES,
      K__NAG.K_WERSJE as WERSJA,
      CASE WHEN WYMIAR01 is null THEN 'brak' ELSE WYMIAR01 END as DIM_1,
      CASE WHEN WYMIAR02 is null THEN 'brak' ELSE WYMIAR02 END as DIM_2,
      CASE WHEN WYMIAR03 is null THEN 'brak' ELSE WYMIAR03 END as DIM_3,
      CASE WHEN WYMIAR04 is null THEN 'brak' ELSE WYMIAR04 END as DIM_4,
      CASE WHEN WYMIAR05 is null THEN 'brak' ELSE WYMIAR05 END as DIM_5,
      CASE WHEN WYMIAR06 is null THEN 'brak' ELSE WYMIAR06 END as DIM_6,
      CASE WHEN WYMIAR07 is null THEN 'brak' ELSE WYMIAR07 END as DIM_7,
      CASE WHEN WYMIAR08 is null THEN 'brak' ELSE WYMIAR08 END as DIM_8,
      CASE WHEN WYMIAR09 is null THEN 'brak' ELSE WYMIAR09 END as DIM_9,
      CASE WHEN WYMIAR10 is null THEN 'brak' ELSE WYMIAR10 END as DIM_10,
      CASE WHEN WYMIAR11 is null THEN 'brak' ELSE WYMIAR11 END as DIM_11,
      CASE WHEN WYMIAR12 is null THEN 'brak' ELSE WYMIAR12 END as DIM_12,
      CASE WHEN WYMIAR13 is null THEN 'brak' ELSE WYMIAR13 END as DIM_13,
      CASE WHEN WYMIAR14 is null THEN 'brak' ELSE WYMIAR14 END as DIM_14,
      CASE WHEN WYMIAR15 is null THEN 'brak' ELSE WYMIAR15 END as DIM_15,
      CASE WHEN K__WAR.REFERENCE is null or (K__WAR.REJ is null and K__WAR.LT is null) THEN 'brak' ELSE K__WAR.REFERENCE END as DOKUMENT,
      K__POZ.RODZAJ
   from
      K__WAR right join K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)
   where
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:MODEL and
      K__NAG.K_WERSJE=:K_WERSJA and
      K__NAG.K_PODWER is null and
      K__POZ.OKRES>=:OKR_OD and
      K__POZ.OKRES<=:OKR_DO
   order by DIM_1,DIM_2,DIM_3,DIM_4,DIM_5,DIM_6,DIM_7,DIM_8,DIM_9,DIM_10,DIM_11,DIM_12,
         DIM_13,DIM_14,DIM_15,OKRES,RODZAJ,DOKUMENT
end sql

formula
   exec('nar4dok','!ctr_pdm_patw',:RS);
   :RS.blank();
   :RS.DIM_1:='Asize';
   :RS.WARTOSC:=:RS.size();
   :RS.add()
end formula
end proc


proc wartpfun
desc
   wartosci dla kontrolingu z funkcji z dokumentami
end desc
params
   FIRMA:='1234567890ABCDEF' String[16]
   MODEL:='1234567890ABCDEF' String[16]
   K_WERSJA:='1234567890ABCDEF' String[16]
   OKR_OD:='1234567890ABCDEF' String[16]
   OKR_DO:='1234567890ABCDEF' String[16]
end params

formula

end formula

sql
   select
      CASE WHEN K__WAR.REFERENCE is null THEN WART ELSE KW END as WARTOSC,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_N ELSE 0 END as WARTOSCN,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_NB ELSE 0 END as WARTOSCB,
      OKRES,
      K__NAG.K_WERSJE as WERSJA,
      CASE WHEN WYMIAR01 is null THEN 'brak' ELSE WYMIAR01 END as DIM_1,
      CASE WHEN WYMIAR02 is null THEN 'brak' ELSE WYMIAR02 END as DIM_2,
      CASE WHEN WYMIAR03 is null THEN 'brak' ELSE WYMIAR03 END as DIM_3,
      CASE WHEN WYMIAR04 is null THEN 'brak' ELSE WYMIAR04 END as DIM_4,
      CASE WHEN WYMIAR05 is null THEN 'brak' ELSE WYMIAR05 END as DIM_5,
      CASE WHEN WYMIAR06 is null THEN 'brak' ELSE WYMIAR06 END as DIM_6,
      CASE WHEN WYMIAR07 is null THEN 'brak' ELSE WYMIAR07 END as DIM_7,
      CASE WHEN WYMIAR08 is null THEN 'brak' ELSE WYMIAR08 END as DIM_8,
      CASE WHEN WYMIAR09 is null THEN 'brak' ELSE WYMIAR09 END as DIM_9,
      CASE WHEN WYMIAR10 is null THEN 'brak' ELSE WYMIAR10 END as DIM_10,
      CASE WHEN WYMIAR11 is null THEN 'brak' ELSE WYMIAR11 END as DIM_11,
      CASE WHEN WYMIAR12 is null THEN 'brak' ELSE WYMIAR12 END as DIM_12,
      CASE WHEN WYMIAR13 is null THEN 'brak' ELSE WYMIAR13 END as DIM_13,
      CASE WHEN WYMIAR14 is null THEN 'brak' ELSE WYMIAR14 END as DIM_14,
      CASE WHEN WYMIAR15 is null THEN 'brak' ELSE WYMIAR15 END as DIM_15,
      CASE WHEN K__WAR.REFERENCE is null or K__WAR.LT='' THEN 'brak' ELSE K__WAR.REFERENCE END as DOKUMENT,
      K__POZ.RODZAJ
   from
      K__WAR right join K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)
   where
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:MODEL and
      K__NAG.K_WERSJE=:K_WERSJA and
      K__NAG.K_PODWER is null and
      K__POZ.OKRES>=:OKR_OD and
      K__POZ.OKRES<=:OKR_DO
   order by DIM_1,DIM_2,DIM_3,DIM_4,DIM_5,DIM_6,DIM_7,DIM_8,DIM_9,DIM_10,DIM_11,DIM_12,
         DIM_13,DIM_14,DIM_15,OKRES,RODZAJ,DOKUMENT
end sql

formula
   exec('nar4dok','!ctr_pdm_patw',:RS);
   :RS.blank();
   :RS.DIM_1:='Asize';
   :RS.WARTOSC:=:RS.size();
   :RS.add()
end formula
end proc


proc wartmfun
desc
   wartosci dla kontrolingu z funkcji z dokumentami
end desc
params
   FIRMA:='1234567890ABCDEF' String[16]
   MODEL:='1234567890ABCDEF' String[16]
   K_WERSJA:='1234567890ABCDEF' String[16]
   OKR_OD:='1234567890ABCDEF' String[16]
   OKR_DO:='1234567890ABCDEF' String[16]
end params

formula

end formula

sql
   select
      CASE WHEN K__WAR.REFERENCE is null THEN WART ELSE KW END as WARTOSC,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_N ELSE 0 END as WARTOSCN,
      CASE WHEN K__WAR.REFERENCE is null THEN WART_NB ELSE 0 END as WARTOSCB,
      OKRES,
      K__NAG.K_WERSJE as WERSJA,
      CASE WHEN WYMIAR01 is null THEN 'brak' ELSE WYMIAR01 END as DIM_1,
      CASE WHEN WYMIAR02 is null THEN 'brak' ELSE WYMIAR02 END as DIM_2,
      CASE WHEN WYMIAR03 is null THEN 'brak' ELSE WYMIAR03 END as DIM_3,
      CASE WHEN WYMIAR04 is null THEN 'brak' ELSE WYMIAR04 END as DIM_4,
      CASE WHEN WYMIAR05 is null THEN 'brak' ELSE WYMIAR05 END as DIM_5,
      CASE WHEN WYMIAR06 is null THEN 'brak' ELSE WYMIAR06 END as DIM_6,
      CASE WHEN WYMIAR07 is null THEN 'brak' ELSE WYMIAR07 END as DIM_7,
      CASE WHEN WYMIAR08 is null THEN 'brak' ELSE WYMIAR08 END as DIM_8,
      CASE WHEN WYMIAR09 is null THEN 'brak' ELSE WYMIAR09 END as DIM_9,
      CASE WHEN WYMIAR10 is null THEN 'brak' ELSE WYMIAR10 END as DIM_10,
      CASE WHEN WYMIAR11 is null THEN 'brak' ELSE WYMIAR11 END as DIM_11,
      CASE WHEN WYMIAR12 is null THEN 'brak' ELSE WYMIAR12 END as DIM_12,
      CASE WHEN WYMIAR13 is null THEN 'brak' ELSE WYMIAR13 END as DIM_13,
      CASE WHEN WYMIAR14 is null THEN 'brak' ELSE WYMIAR14 END as DIM_14,
      CASE WHEN WYMIAR15 is null THEN 'brak' ELSE WYMIAR15 END as DIM_15,
      CASE WHEN K__WAR.REFERENCE is null THEN 'brak' ELSE K__WAR.REFERENCE END as DOKUMENT,
      K__POZ.RODZAJ
   from
      K__WAR right join K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)
   where
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:MODEL and
      K__NAG.K_WERSJE=:K_WERSJA and
      K__NAG.K_PODWER is null and
      K__POZ.OKRES>=:OKR_OD and
      K__POZ.OKRES<=:OKR_DO
   order by DIM_1,DIM_2,DIM_3,DIM_4,DIM_5,DIM_6,DIM_7,DIM_8,DIM_9,DIM_10,DIM_11,DIM_12,
         DIM_13,DIM_14,DIM_15,OKRES,RODZAJ,DOKUMENT
end sql

formula
   exec('nar4dok','!ctr_pdm_patw',:RS);
   :RS.blank();
   :RS.DIM_1:='Asize';
   :RS.WARTOSC:=:RS.size();
   :RS.add()
end formula
end proc




proc okresy
desc
   okresy dla kontrolingu
end desc
params
   KOD:='000000' String[6]
   OD:='1234567890ABCDEF' String[16]
   DO:='1234567890ABCDEF' String[16]
end params

formula

end formula

sql
   select
      '                ' as REF,
      '                    ' as ROK,
      'II pol 2007                ' as POLROCZE,
      'III kw 2007                ' as KWARTAL,
      '0123456789012345678901234567890123456789012345' as MIESIAC,
      '                                         ' as TXT
   from
      syslog
   where
      1=2
end sql

formula
   _fun:="{? _a=4 ||'IV'||_a*'I'?}";
   _od:=:OD;
   _do:=:DO;
   {? :KOD<>'------'
   || K__NAG.index('UNIK'); K__NAG.prefix(:KOD); K__NAG.first();
      OKRO_F.index('ROK'); OKRO_F.prefix(K__NAG.ROK_F);
      {? OKRO_F.first() || _od:=$OKRO_F.ref() ?};
      {? OKRO_F.last() || _do:=$OKRO_F.ref() ?}
   ?};
   _tab:=sql('select REFERENCE as REF from OKRO_F where REFERENCE>=\':_a\' and REFERENCE<=\':_b\'',_od,_do);
   {? _tab.first()
   || OKRO_F.prefix();
      {!
      |? {? OKRO_F.seek(BIT.sqlint(_tab.REF),)
         || {? OKRO_F.POCZ<>date(0,0,0)
            || :RS.REF:=$OKRO_F.ref();
               :RS.ROK:=OKRO_F.ROK().NAZ;
               :RS.POLROCZE:=_fun(OKRO_F.POLROCZE)+' pol '+:RS.ROK;
               :RS.KWARTAL:=_fun(OKRO_F.KWARTAL)+' kw '+:RS.ROK;
               _mc:=ROK_F.LOBR<>12 | ROK_F.POCZ_ROK~2<>1 | ROK_F.POCZ_ROK~3<>1;
               :RS.MIESIAC:=(('0'+$(OKRO_F.NR))+2)+' '+:RS.ROK+{? _mc || ' ('+OKRO_F.NAZ+')' || '' ?};
               :RS.TXT:=OKRO_F.NAZ+' '+:RS.ROK;
               :RS.add()
            || :RS.REF:=$OKRO_F.ref();
               :RS.ROK:=OKRO_F.ROK().NAZ;
               :RS.POLROCZE:=_fun(OKRO_F.POLROCZE)+' pol '+:RS.ROK;
               :RS.KWARTAL:=_fun(OKRO_F.KWARTAL)+' kw '+:RS.ROK;
               _mc:=ROK_F.LOBR<>12 | ROK_F.POCZ_ROK~2<>1 | ROK_F.POCZ_ROK~3<>1;
               :RS.MIESIAC:={? OKRO_F.NR=0 || '00' || ('0'+$OKRO_F.NR)+2 ?}+' '+:RS.ROK+{? _mc || ' ('+OKRO_F.NAZ+')' || '' ?};
               :RS.TXT:=OKRO_F.NAZ+' '+:RS.ROK;
               :RS.add()
            ?}
         ?};
         _tab.next()
      !}
   ?}
end formula
end proc


proc wersje
desc
   wersje dla kontrolingu
end desc

params
end params

formula
end formula

sql
   select
      REFERENCE as REF,
      SYM,
      OPIS
   from
      K_WERSJE
   where CZY_KALK<>'T'
end sql

formula
end formula

end proc


proc wersje_k
desc
   wersje kalkulowane dla kontrolingu
end desc

params
end params

formula
end formula

sql
   select
      REFERENCE as REF,
      SYM,
      OPIS,
      MDX
   from
      K_WERSJE
   where CZY_KALK='T'
   order by 1
end sql

formula
   exec('wersje_k','!ctr_pdm_patw',:RS)
end formula

end proc


proc zapkod_o
desc
   Zapisy controllingowe - dokumenty
end desc

params
   KOD:='000000' String[8]
end params

formula
   :KOD:='yx'+:KOD+'%'
end formula

sql
   select
      K__WAR.REFERENCE as REF,
      K__POZ.OKRES,
      K__WAR.SYM as D_SYM,
      REJ.KOD as D_REJ,
      K__WAR.POZ as D_POZ,
      K__WAR.DATA as D_DATA,
      K__WAR.OPIS as D_OPIS,
      K__WAR.KON as D_KON
   from
      REJ right join K__WAR join K__POZ
   where
      K__WAR.REFERENCE like :KOD and (K__WAR.REJ is not null or K__WAR.LT='')
   order by REF
end sql

formula
   exec('kwarprc','!ctr_pdm_patw',:RS);
   :RS.blank();
   :RS.REF:='brak';
   :RS.D_SYM:='brak';
   :RS.D_REJ:='brak';
   :RS.D_POZ:=0;
   :RS.D_OPIS:='brak';
   :RS.D_KON:='brak';
   :RS.add();
   :RS.blank();
   :RS.REF:='Asize';
   :RS.D_POZ:=:RS.size();
   :RS.add()
end formula

end proc


proc zapfun_o
desc
   Zapisy controllingowe - funkcja - dokumenty
end desc

params
   FIRMA:='1234567890ABCDEF' String[16]
   MODEL:='1234567890ABCDEF' String[16]
   K_WERSJA:='1234567890ABCDEF' String[16]
   OKR_OD:='1234567890ABCDEF' String[16]
   OKR_DO:='1234567890ABCDEF' String[16]
end params

formula
end formula

sql
   select
      K__WAR.REFERENCE as REF,
      K__POZ.OKRES,
      K__WAR.SYM as D_SYM,
      REJ.KOD as D_REJ,
      K__WAR.POZ as D_POZ,
      K__WAR.DATA as D_DATA,
      K__WAR.OPIS as D_OPIS,
      K__WAR.KON as D_KON
   from
      REJ right join K__WAR join K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)
   where
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:MODEL and
      K__NAG.K_WERSJE=:K_WERSJA and
      K__NAG.K_PODWER is null and
      K__POZ.OKRES>=:OKR_OD and
      K__POZ.OKRES<=:OKR_DO
   order by REF
end sql

formula
   exec('kwarprc','!ctr_pdm_patw',:RS);
   :RS.blank();
   :RS.REF:='brak';
   :RS.D_SYM:='brak';
   :RS.D_REJ:='brak';
   :RS.D_POZ:=0;
   :RS.D_OPIS:='brak';
   :RS.D_KON:='brak';
   :RS.add();
   :RS.blank();
   :RS.REF:='Asize';
   :RS.D_POZ:=:RS.size();
   :RS.add()
end formula

end proc


proc zapkod_p
desc
   Zapisy controllingowe - listy plac
end desc

params
   KOD:='000000' String[8]
end params

formula
   :KOD:='yx'+:KOD+'%'
end formula

sql
   select
      K__WAR.REFERENCE as REF,
      K__POZ.OKRES,
      K__WAR.LT as D_LT,
      K__WAR.RN as D_RN,
      K__WAR.RT as D_RT,
      K__WAR.G as D_G,
      K__WAR.PROC as D_PROC
   from
      K__WAR join K__POZ
   where
      K__WAR.REFERENCE like :KOD and K__WAR.LT<>''
   order by REF
end sql

formula
   exec('kwarprc','!ctr_pdm_patw',:RS);
   :RS.REF:='brak';
   :RS.D_LT:='brak';
   :RS.D_RN:=0;
   :RS.D_RT:='brak';
   :RS.D_G:=0;
   :RS.D_PROC:=0;
   :RS.add();
   :RS.blank();
   :RS.REF:='Asize';
   :RS.D_RN:=:RS.size();
   :RS.add()
end formula

end proc


proc zapfun_m
desc
   Zapisy controllingowe - funkcja - dokumenty i listy plac (mix)
end desc

params
   FIRMA:='1234567890ABCDEF' String[16]
   MODEL:='1234567890ABCDEF' String[16]
   K_WERSJA:='1234567890ABCDEF' String[16]
   OKR_OD:='1234567890ABCDEF' String[16]
   OKR_DO:='1234567890ABCDEF' String[16]
end params

formula
end formula

sql
   select
      K__WAR.REFERENCE as REF,
      K__POZ.OKRES,
      K__WAR.SYM as D_SYM,
      REJ.KOD as D_REJ,
      K__WAR.POZ as D_POZ,
      K__WAR.DATA as D_DATA,
      K__WAR.OPIS as D_OPIS,
      K__WAR.KON as D_KON,
      K__WAR.LT as D_LT,
      K__WAR.RN as D_RN,
      K__WAR.RT as D_RT,
      K__WAR.G as D_G,
      K__WAR.PROC as D_PROC
   from
      REJ right join K__WAR join K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)
   where
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:MODEL and
      K__NAG.K_WERSJE=:K_WERSJA and
      K__NAG.K_PODWER is null and
      K__POZ.OKRES>=:OKR_OD and
      K__POZ.OKRES<=:OKR_DO
   order by REF
end sql

formula
   exec('kwarprc','!ctr_pdm_patw',:RS);
   :RS.blank();
   :RS.REF:='brak';
   :RS.D_SYM:='brak';
   :RS.D_REJ:='brak';
   :RS.D_POZ:=0;
   :RS.D_OPIS:='brak';
   :RS.D_KON:='brak';
   :RS.D_LT:='brak';
   :RS.D_RN:=0;
   :RS.D_RT:='brak';
   :RS.D_G:=0;
   :RS.D_PROC:=0;
   :RS.add();
   :RS.blank();
   :RS.REF:='Asize';
   :RS.D_POZ:=:RS.size();
   :RS.add()
end formula

end proc


proc zapkod_m
desc
   Zapisy controllingowe - dokumenty i listy plac (mix)
end desc

params
   KOD:='000000' String[8]
end params

formula
   :KOD:='yx'+:KOD+'%'
end formula

sql
   select
      K__WAR.REFERENCE as REF,
      K__POZ.OKRES,
      K__WAR.SYM as D_SYM,
      REJ.KOD as D_REJ,
      K__WAR.POZ as D_POZ,
      K__WAR.DATA as D_DATA,
      K__WAR.OPIS as D_OPIS,
      K__WAR.KON as D_KON,
      K__WAR.LT as D_LT,
      K__WAR.RN as D_RN,
      K__WAR.RT as D_RT,
      K__WAR.G as D_G,
      K__WAR.PROC as D_PROC
   from
      REJ right join K__WAR join K__POZ
   where
      K__WAR.REFERENCE like :KOD
   order by REF
end sql

formula
   exec('kwarprc','!ctr_pdm_patw',:RS);
   :RS.REF:='brak';
   :RS.D_SYM:='brak';
   :RS.D_REJ:='brak';
   :RS.D_POZ:=0;
   :RS.D_OPIS:='brak';
   :RS.D_KON:='brak';
   :RS.D_LT:='brak';
   :RS.D_RN:=0;
   :RS.D_RT:='brak';
   :RS.D_G:=0;
   :RS.D_PROC:=0;
   :RS.add();
   :RS.blank();
   :RS.REF:='Asize';
   :RS.D_POZ:=:RS.size();
   :RS.add()
end formula

end proc


proc zapfun_p
desc
   Zapisy controllingowe - funkcja - listy plac
end desc

params
   FIRMA:='1234567890ABCDEF' String[16]
   MODEL:='1234567890ABCDEF' String[16]
   K_WERSJA:='1234567890ABCDEF' String[16]
   OKR_OD:='1234567890ABCDEF' String[16]
   OKR_DO:='1234567890ABCDEF' String[16]
end params

formula
end formula

sql
   select
      K__WAR.REFERENCE as REF,
      K__POZ.OKRES,
      K__WAR.LT as D_LT,
      K__WAR.RN as D_RN,
      K__WAR.RT as D_RT,
      K__WAR.G as D_G,
      K__WAR.PROC as D_PROC
   from
      K__WAR join K__POZ join K__NAG using (K__POZ.K__NAG,K__NAG.REFERENCE)
   where
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:MODEL and
      K__NAG.K_WERSJE=:K_WERSJA and
      K__NAG.K_PODWER is null and
      K__POZ.OKRES>=:OKR_OD and
      K__POZ.OKRES<=:OKR_DO
   order by REF
end sql

formula
   exec('kwarprc','!ctr_pdm_patw',:RS);
   :RS.REF:='brak';
   :RS.D_LT:='brak';
   :RS.D_RN:=0;
   :RS.D_RT:='brak';
   :RS.D_G:=0;
   :RS.D_PROC:=0;
   :RS.add();
   :RS.blank();
   :RS.REF:='Asize';
   :RS.D_RN:=:RS.size();
   :RS.add()
end formula

end proc



proc zak_war
desc
   zakres zasilanych wartosci
end desc

params
   KOD:='000000' String[6]
end params

formula
end formula

sql
   select
      '                ' as OD,
      '                ' as DO
   from
      K__NAG
   where 1=2
end sql

formula
   K__NAG.index('UNIK'); K__NAG.prefix(:KOD);
   OKRO_F.index('ROK');
   {? K__NAG.first()
   || OKRO_F.prefix(K__NAG.ROK_F);
      {? OKRO_F.first()
      || :RS.OD:=$OKRO_F.ref()
      ?};
      {? OKRO_F.last()
      || :RS.DO:=$OKRO_F.ref()
      ?};
      :RS.add()
   ?}
end formula

end proc


proc k_p_view
desc
   Pozycje widoku danych
end desc

params
   NAG:='k_n_view00000001' String[16]
end params

formula
   K_N_VIEW.name()
end formula

sql
   select
      CASE TYP WHEN 'K' THEN 1 WHEN 'W' THEN 2 ELSE 3 end as LPTYP,
      K_P_VIEW.REFERENCE as REF,
      TYP,
      CASE WHEN K_P_VIEW.SKID_MBP is null THEN 'Czas' ELSE SKID_MBP.NAZ END as NAZ,
      K_P_VIEW.LP,
      K_P_VIEW.ZN_SUMA,
      CASE WHEN K_P_VIEW.SKID_MBP is null THEN 0 ELSE SKID_MBP.LP END as LPALL
   from
      K_P_VIEW left join SKID_MBP using (K_P_VIEW.SKID_MBP, SKID_MBP.REFERENCE)
   where
      K_N_VIEW=:NAG
   order by LPTYP,LP
end sql
end proc


proc k_e_view
desc
   Elementy pozycji widoku danych
end desc

params
   NAG:='k_p_view00000003' String[16]
end params

sql
   select
      K_E_VIEW.LP,
      UD_SKL.SYMBOL,
      UD_SKL.OPIS,
      UD_SKL.REFERENCE as REF,
      '                                                                                                                                                                                                                                                             ' as FORMULA1,
      '                                                                                                                                                                                                                                                             ' as FORMULA2,
      '                                                                                                                                                                                                                                                             ' as FORMULA3,
      '                                                                                                                                                                                                                                                             ' as FORMULA4,
      '                                                                                                                                                                                                                                                             ' as FORMULA5,
      '                                                                                                                                                                                                                                                             ' as FORMULA6,
      '                                                                                                                                                                                                                                                             ' as FORMULA7,
      '                                                                                                                                                                                                                                                             ' as FORMULA8,
      '                                                                                                                                                                                                                                                             ' as FORMULA9,
      '                                                                                                                                                                                                                                                             ' as FORMULAA,
      '                                                                                                                                                                                                                                                             ' as FORMULAB,
      UD_SKL.SYMBOL as SYM,
      K_E_VIEW.SUMATYP,
      K_E_VIEW.READONLY
   from
      K_E_VIEW
      left join UD_SKL using (UD_SKL.REFERENCE, K_E_VIEW.UD_SKL)
   where
      K_P_VIEW=:NAG
   order by LP
end sql

formula
   exec('ex_form','control',:NAG,:RS);
   {? ~:RS.first()
   || K_P_VIEW.prefix();
      {? K_P_VIEW.seek(BIT.sqlint(:NAG),)
      || _naz:=K_P_VIEW.SKID_MBP().NAZ;
         _s:=1+_naz;
         {! _lp:=1..4
         |! :RS.LP:=_lp;
            :RS.SYMBOL:=_s+$_lp;
            :RS.SYM:=:RS.SYMBOL;
            :RS.OPIS:=_naz+$_lp;
            :RS.REF:=_s;
            :RS.add()
         !}
      ?}
   ?}
end formula

end proc


proc k_e_time
desc
   Elementy pozycji widoku danych - czas
end desc

params
   K_HARM:=1 Integer
   NAG:='k_p_view00000005' String[16]
end params

sql
   select
      K_E_VIEW.LP,
      UD_SKL.SYMBOL,
      UD_SKL.OPIS,
      UD_SKL.REFERENCE as REF,
      '                                                                                                                                                                                                                                                             ' as FORMULA1,
      '                                                                                                                                                                                                                                                             ' as FORMULA2,
      '                                                                                                                                                                                                                                                             ' as FORMULA3,
      '                                                                                                                                                                                                                                                             ' as FORMULA4,
      UD_SKL.SYMBOL as SYM,
      ' ' as CZY_WYK,
      K_E_VIEW.SUMATYP,
      K_E_VIEW.READONLY
   from
      K_E_VIEW
      left join UD_SKL using (UD_SKL.REFERENCE, K_E_VIEW.UD_SKL)
   where
      1=2
   order by LP
end sql

formula
   exec('ex_formt','control',:NAG,:RS,:K_HARM);
   {? ~:RS.first()
   || {! _lp:=1..4
      |! :RS.LP:=_lp;
         :RS.SYMBOL:='C'+$_lp;
         :RS.SYM:='Czas';
         :RS.OPIS:='Czas '+$_lp;
         :RS.REF:='czas'+$_lp;
         :RS.add()
      !}
   ?}
end formula

end proc


proc k__poz
desc
   Pozycje planu
end desc

params
   K_HARM:=1 Integer
   K_P_VIEW:='maska___00000001' String[16]
   K_PODWER:='' String[16]
   WYKON:=0 Integer
   FIRMA:='maska___00000001' String[16]
   SKID_MBN:='maska___00000001' String[16]
   K_WERSJE:='maska___00000001' String[16]
   OD:='okrobr  00000010' String[16]
   DO:='okrobr  0000001b' String[16]
   OD2:='okrobr  00000010' String[16]
   DO2:='okrobr  0000001b' String[16]
   SQL_WYK:='maska___00000001' String[16]
end params

formula
   K_HARM.index('K_WERSJE'); K_HARM.prefix();
   {? K_HARM.seek(:K_HARM,)
   || :SKID_MBN:=$K_HARM.SKID_MBN;
      :K_WERSJE:=$K_HARM.K_WERSJE;
      :OD:=$K_HARM.OD;
      :DO:=$K_HARM.DO
   ?};
   {? :WYKON
   || K_P_VIEW.prefix();
      {? K_P_VIEW.seek(BIT.sqlint(:K_P_VIEW),)
      || _m:=0;
         K_E_VIEW.index('LAT'); K_E_VIEW.prefix(K_P_VIEW.ref());
         {? K_E_VIEW.last()
         || _m:=K_E_VIEW.LAT
         ?};
         _fml_r:="
            ROK_F.index('KOD'); ROK_F.prefix(REF.FIRMA);
            {! _i:=1.._a
            |! ROK_F.prev()
            !};
            OKRO_F.index('ROK'); OKRO_F.prefix(ROK_F.ref());
            {? _b || OKRO_F.first() || OKRO_F.last() ?}
         ";
         K_HARM.OD().ROK();
         _fml_r(_m,1);
         :OD2:=$OKRO_F.ref();
         K_HARM.DO().ROK();
         _fml_r(1,0);
         :DO2:=$OKRO_F.ref()
      ?};
      K_WERSJE.index('CZY_SYS'); K_WERSJE.prefix('T');
      {? K_WERSJE.first() || :SQL_WYK:=$K_WERSJE.ref() ?}
   ?}
end formula

sql
   select
      K__POZ.WART,
      'N'||K__POZ.OKRES as OKRES,
      K__POZ.WYMIAR01,
      K__POZ.WYMIAR02,
      K__POZ.WYMIAR03,
      K__POZ.WYMIAR04,
      K__POZ.WYMIAR05,
      K__POZ.REFERENCE as REF,
      '                                                                                                                                                                                                        ' as K1,
      '                                                                                                                                                                                                        ' as K2,
      '                                                                                                                                                                                                        ' as K3,
      '                                                                                                                                                                                                        ' as K4,
      '                                                                                                                                                                                                        ' as K5
   from
      K__POZ join K__NAG
   where
      :K_PODWER='brak' and
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:SKID_MBN and K__NAG.K_WERSJE=:K_WERSJE and
      K__POZ.RODZAJ<>15 and K__POZ.OKRES>=:OD and K__POZ.OKRES<=:DO and K__NAG.K_PODWER is null
   order by OKRES

   UNION ALL

   select
      K__POZ.WART,
      'N'||K__POZ.OKRES as OKRES,
      K__POZ.WYMIAR01,
      K__POZ.WYMIAR02,
      K__POZ.WYMIAR03,
      K__POZ.WYMIAR04,
      K__POZ.WYMIAR05,
      K__POZ.REFERENCE as REF,
      '                                                                                                                                                                                                        ' as K1,
      '                                                                                                                                                                                                        ' as K2,
      '                                                                                                                                                                                                        ' as K3,
      '                                                                                                                                                                                                        ' as K4,
      '                                                                                                                                                                                                        ' as K5
   from
      K__POZ join K__NAG
   where
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:SKID_MBN and K__NAG.K_WERSJE=:K_WERSJE and
      K__POZ.RODZAJ<>15 and K__POZ.OKRES>=:OD and K__POZ.OKRES<=:DO and
      K__NAG.K_PODWER=:K_PODWER
   order by OKRES

   UNION ALL

   select
      K__POZ.WART,
      'T'||K__POZ.OKRES as OKRES,
      K__POZ.WYMIAR01,
      K__POZ.WYMIAR02,
      K__POZ.WYMIAR03,
      K__POZ.WYMIAR04,
      K__POZ.WYMIAR05,
      K__POZ.REFERENCE as REF,
      '                                                                                                                                                                                                        ' as K1,
      '                                                                                                                                                                                                        ' as K2,
      '                                                                                                                                                                                                        ' as K3,
      '                                                                                                                                                                                                        ' as K4,
      '                                                                                                                                                                                                        ' as K5
   from
      K__POZ join K__NAG
   where
      :WYKON=1 and
      K__NAG.FIRMA=:FIRMA and
      K__NAG.SKID_MB=:SKID_MBN and K__NAG.K_WERSJE=:SQL_WYK and
      K__POZ.OKRES>=:OD2 and K__POZ.OKRES<=:DO2
   order by OKRES
end sql

formula
   exec('kpoz_index','control',:RS,:K_P_VIEW);
   {? :RS.first()
   || {!
      |? K__POZ.use(8+:RS.REF);
         K__POZ.prefix();
         K__POZ.seek(BIT.sqlint(:RS.REF+8),K__POZ.name());
         {? K__POZ.RODZAJ<>4
         || _fml:=K__POZ.memo_txt(0,1,'MEMO');
         {? _fml<>''
         || :RS.K1:=200+_fml; _fml:=200-_fml;
            :RS.K2:=200+_fml; _fml:=200-_fml;
            :RS.K3:=200+_fml; _fml:=200-_fml;
            :RS.K4:=200+_fml; _fml:=200-_fml;
            :RS.K5:=200+_fml; _fml:=200-_fml
         || :RS.K1:='';
            :RS.K2:='';
            :RS.K3:='';
            :RS.K4:='';
            :RS.K5:=''
         ?};
         :RS.put();
         {!
         |? {? _fml<>''
            || :RS.K1:=200+_fml; _fml:=200-_fml;
               :RS.K2:=200+_fml; _fml:=200-_fml;
               :RS.K3:=200+_fml; _fml:=200-_fml;
               :RS.K4:=200+_fml; _fml:=200-_fml;
               :RS.K5:=200+_fml; _fml:=200-_fml;
               :RS.add()
            ?}
         !};
         :RS.next()
         || :RS.del()
         ?}
      !}
   ?};
   {? var_press('B_GET',SKIDXDUD)>0
   || exec('b_get','control',:RS,:K_P_VIEW,:K_HARM)
   ?};
   :RS.blank();
   :RS.OKRES:='Asum';
   :RS.WART:=:RS.size();
   :RS.add()
end formula

end proc


proc add_poz
desc
   Dodaje pozycje planu
end desc

params
   K_HARM:=1 Integer
   K_PODWER:='' String[16]
   P1:='' String[1024]
   P2:='' String[1024]
   P3:='' String[1024]
   P4:='' String[1024]
   P5:='' String[1024]
   P6:='' String[1024]
   P7:='' String[1024]
   P8:='' String[1024]
   P9:='' String[1024]
   P10:='' String[1024]
   P11:='' String[1024]
   P12:='' String[1024]
   P13:='' String[1024]
   P14:='' String[1024]
   P15:='' String[1024]
   P16:='' String[1024]
   P17:='' String[1024]
   P18:='' String[1024]
   P19:='' String[1024]
   P20:='' String[1024]
#   WART String[50]
#   OKRES String[16]
#   WYMIAR01 String[16]
#   WYMIAR02 String[16]
#   WYMIAR03 String[16]
#   WYMIAR04 String[16]
#   WYMIAR05 String[16]
   OK:=0 Integer
#{? 0 || :OK:=exec('add_poz','control',:WART,:OKRES,:WYMIAR01,:WYMIAR02,:WYMIAR03,:WYMIAR04,:WYMIAR05) ?}
end params

formula
   K_HARM.index('K_WERSJE'); K_HARM.prefix();
   {? K_HARM.seek(:K_HARM,)
   || K_PODWER.prefix();
      _podwer:={? :K_PODWER=''
               || null
               |? K_PODWER.seek(BIT.sqlint(:K_PODWER),)
               || K_PODWER.ref()
               || null
               ?};
      exec('add_poz1','control',_podwer,:P1,:P2,:P3,:P4,:P5,:P6,:P7,:P8,:P9,:P10,:P11,:P12,:P13,:P14,:P15,:P16,:P17,:P18,:P19,:P20)
   ?}
end formula

sql
   select 1 as OK from K__POZ where 1=2
end sql

formula
   :RS.OK:=:OK;
   :RS.add()
end formula

end proc


proc akc_harm
desc
   Akceptacja planu
end desc

params
   K_HARM_P:=1 Integer
   USER:='' String[100]
   UWAGI:='' String[255]
end params

sql
   select 1 as OK from K__POZ where 1=2
end sql

formula
   _typ:=exec('akc_harm','control',:K_HARM_P,:USER,:UWAGI);
   {? _typ<>''
   || exec('koniec','ctr_bha',_typ,:USER)
   ?};
   :RS.OK:=_typ<>'';
   :RS.add()
end formula

end proc


proc ret_harm
desc
   Odrzucenie planu
end desc

params
   K_HARM_P:=1 Integer
   USER:='' String[100]
   UWAGI:='' String[255]
end params

sql
   select 1 as OK from K__POZ where 1=2
end sql

formula
   _ok:=0;
   K_HARM_P.index('K_HARM'); K_HARM_P.prefix();
   {? K_HARM_P.seek(:K_HARM_P,)
   || {? K_HARM_P.STATUS='U' | K_HARM_P.STATUS='A'
      || K_HARM_P.cntx_psh(); K_HARM_P.index('K_HARM'); K_HARM_P.prefix(K_HARM_P.K_HARM,K_HARM_P.ref());
         _jest:=K_HARM_P.first();
         K_HARM_P.cntx_pop();
         {? _jest
         || exec('kharmp_stat','control','P',:USER)
         |? K_HARM_P.ZN_UZU='T'
         || exec('kharmp_stat','control','W',:USER)
         || exec('kharmp_stat','control','U',:USER)
         ?};
         K_HARM_P.UWAGI:=:UWAGI;
         K_HARM_P.ZN_RET:='T';
         _ok:=K_HARM_P.put()
      ?}
   ?};
   {? _ok
   || exec('koniec','ctr_bha','B',:USER)
   ?};
   :RS.OK:=_ok;
   :RS.add()
end formula

end proc


proc stat_harm
desc
   Status pozycji harmonogramu
end desc

params
   K_HARM_P:=1 Integer
   K_HARM_U:='' String[100]
end params

formula

end formula

sql
   select
      'NN' as STATUS,
      '                                                                                                    ' as USR_UZU,
      '                                                                                                    ' as USR_AKC,
      '                                                            ' as NAZ,
      'zaakceptowane' as STAT_TXT,
      '2009/12/31' as D_R_UZU,
      '2009/12/31' as D_R_AKC,
      '2009/12/31' as D_P_UZU,
      '2009/12/31' as D_P_AKC,
      '2009/12/31' as DATA_UZU,
      '2009/12/31' as DATA_AKC,
      '                                                                                                                                                                                                                                                               ' as OPIS,
      0 as CAN_VIEW,
      '12345678901234567890' as WER_SYM,
      '1234567890123456' as WER_REF,
      '                                                                                                                                                                                                                                                               ' as PROC,
      0 as SAVE_PAS,
      0 as SUMY,
      0 as A_POB
   from K__POZ where 1=2
end sql

formula
   :RS.blank();
   K_HARM_P.index('K_HARM'); K_HARM_P.prefix();
   {? K_HARM_P.seek(:K_HARM_P,)
   || _stat:=K_HARM_P.STATUS;
      {? _stat='W' & (K_HARM_P.ZN_AKC='N' | K_HARM_P.KTO_AKC=K_HARM_P.KTO_UZU)
      || _stat:='WU'
      |? _stat='W' & K_HARM_P.ZN_UZU='N'
      || _stat:='U'
      ?};
      K_INFO.first();
      :RS.USR_UZU:=K_HARM_P.KTO_UZU().KOD;
      :RS.USR_AKC:=K_HARM_P.KTO_AKC().KOD;
      :RS.NAZ:=K_HARM_P.NAZ;
      exec('set_status','control');
      :RS.STAT_TXT:=UNPAR.P10;
      :RS.D_R_UZU:=$K_HARM_P.D_R_UZU;
      :RS.D_R_AKC:=$K_HARM_P.D_R_AKC;
      :RS.D_P_UZU:=$K_HARM_P.D_P_UZU;
      :RS.D_P_AKC:=$K_HARM_P.D_P_AKC;
      :RS.DATA_UZU:=$K_HARM_P.DATA_UZU;
      :RS.DATA_AKC:=$K_HARM_P.DATA_AKC;
      :RS.OPIS:=K_HARM_P.UWAGI;
      :RS.WER_SYM:=K_HARM_P.K_HARM().K_WERSJE().SYM;
      :RS.WER_REF:=$K_HARM_P.K_HARM().K_WERSJE;
      :RS.CAN_VIEW:=0;
      {? exec('getUser','users',:K_HARM_U)
      || K_HARM_H.index('K_USERS');
         K_HARM_H.prefix(K_HARM_P.ref(),USERS.ref());
         :RS.CAN_VIEW:=K_HARM_H.first() & K_HARM_H.CAN_VIEW;
         {? ~:RS.CAN_VIEW
         || K_HARM_U.index('K_HARM_P');
            K_HARM_U.prefix(K_HARM_P.ref(),USERS.ref());
            :RS.CAN_VIEW:=K_HARM_U.first()
         ?}
      ?};
      {? K_HARM_P.K_N_VIEW().PODGLAD
      || :RS.PROC:='call '+K_HARM_P.K_N_VIEW().PROC
      ?};
      :RS.SAVE_PAS:=PAR_SKID.get(110)='T';
      :RS.A_POB:=PAR_SKID.get(111)='T';
      :RS.SUMY:=K_HARM_P.K_N_VIEW().SUMY
   || _stat:='-'
   ?};
   :RS.STATUS:=_stat;
   :RS.add()
end formula

end proc


proc login

desc
::----------------------------------------------------------------------------------------------------------------------
::  UTW: MB [2008]
:: OPIS: zwraca haslo uzytkownika
::   WE: _a - login
::----------------------------------------------------------------------------------------------------------------------
end desc

params
   login:='' String[100]
   pass:='' String[100]
   guid:='' String[100]
   k_p_view:='' String[16]
end params

formula
   _poz:=:login*'\\';
   {? _poz>0 & K_INFO.first() & K_INFO.DOMENA<>'' & :login*(K_INFO.DOMENA+'\\')>0
   || :login:=_poz-:login
   ?}
end formula

sql
   select
      'N' as OK,
      'N' as TYP,
      'N' as ZN_UZU,
      'N' as ZN_AKC,
      'N' as PODWER,
      '          ' as USERS
   from
      SYSSUSER
   where 1=0
end sql

formula
   _sys:=exec(,'__sysusr',1);
   {? var_press('_sys')>0 &
      (:guid<>'' & exec('getADUser','users',:guid) | :login<>'' & exec('getWebUser','users',:login))
   || _ok:={? :login<>'' || _sys.checkWebPassword(:login,:pass) || 1 ?};
      :RS.blank();
      :RS.OK:={? _ok || 'T' || 'N' ?};
      :RS.TYP:='N';
      :RS.ZN_UZU:={? exec('hasAction','users','CTR_HBD_DZAA',USERS.ref()) || 'T' || 'N' ?};
      :RS.ZN_AKC:={? exec('hasAction','users','CTR_HBD_DZBA',USERS.ref()) || 'T' || 'N' ?};
      :RS.PODWER:={? exec('hasAction','users','CTR_HBD_DDPW',USERS.ref()) || 'T' || 'N' ?};
      :RS.USERS:=USERS.KOD;
      :RS.add()
   ?};
   {? :RS.first() & :k_p_view<>''
   || K_P_VIEW.prefix();
      {? K_P_VIEW.seek(BIT.sqlint(:k_p_view),) & K_P_VIEW.K_N_VIEW().SKID_MBN().TYP='P' &
         exec('hasAction','users','CTR_PDM_ZMOP',USERS.ref())
      || :RS.TYP:='P';
         :RS.put()
      ?}
   ?}
end formula

end proc


proc lock
desc
   Blokuje rekordy K__NAG i K_HARM
end desc

params
   K_HARM:=1 Integer
   TRYB:=1 Integer
   OK:=0 Integer
end params

formula
   :OK:=exec('lock','control',:K_HARM,:TRYB)
end formula

sql
   select 0 as OK from K__POZ where 1=2
end sql

formula
   :RS.OK:=:OK;
   :RS.add()
end formula

end proc


proc winlogin

desc
   Uzytkownikcy dla kontrolingu systemu windows
end desc

params
   SYSTEM:='        ' String[8]
end params

formula
   VAR_DEL.delete('UserRap');
   UserRap:=exec('usersWithAction','users','CTR_RAP_ZZAP',REF.FIRMA)
end formula

sql
   select
      REFERENCE as REF,
      WINLOGIN,
      WIN_PASS,
      CON_AD as AD
   from
      USERS
   where 1=0
end sql

formula
   {? UserRap.first()
   || USERS.index('USR_KKOD'); USERS.prefix();
      {!
      |? {? USERS.seek(BIT.sqlint(UserRap.REF),)
         || :RS.REF:=$USERS.ref();
            :RS.WINLOGIN:=USERS.WINLOGIN;
            :RS.WIN_PASS:=USERS.WIN_PASS;
            :RS.AD:=USERS.CON_AD;
            :RS.add()
         ?};
         UserRap.next()
      !}
   ?}
end formula

end proc


proc nwinlog

desc
   Nowy login uzytkownika
end desc

params
   REF:='                ' String[16]
end params

sql
   select
      '12345678901234567890' as LOGIN
   from
      USERS
   where 1=2
end sql

formula
   USERS.index('USR_KKOD'); USERS.prefix();
   {? USERS.seek(BIT.sqlint(:REF),)
   || USERS.WINLOGIN:=exec('winlogin','control',USERS.WINLOGIN);
      USERS.put();
      :RS.LOGIN:=USERS.WINLOGIN;
      :RS.add()
   ?}
end formula

end proc


proc k_role_u

desc
   Uzytkownicy roli
end desc

params
   NAZWA String[100]
   FIRMA String[16]
   TYPE:='O' String[1]
end params

sql
   select
      USERS.WINLOGIN,
      USERS.CON_AD as AD
   from
      K_ROLE
      join K_ROLE_U
      join USERS
   where K_ROLE.FIRMA=:FIRMA and K_ROLE.NAZWA=:NAZWA and K_ROLE.TYPE=:TYPE
end sql

formula
   K_INFO.prefix();
   K_INFO.first();
   VAR_DEL.delete('__t');
   __t:=:RS;
   :RS.for_each("{? __t.AD='T' & K_INFO.DOMENA<>'' || __t.WINLOGIN:=K_INFO.DOMENA+'\\\\'+__t.WINLOGIN; __t.put() ?}");
   VAR_DEL.delete('__t')
end formula

end proc


proc k_role_d

desc
   Definicja uprawnien roli
end desc

params
   NAZWA String[100]
   FIRMA String[16]
   TYPE:='O' String[1]
end params

sql
   select
      SKID_MBN.KOD,
      SKID_MBP.LP,
      SKID_MBP.NAZ,
      K_ROLE_D.UD_SKL
   from
      K_ROLE join
      K_ROLE_D
      join SKID_MBP using (SKID_MBP.REFERENCE,K_ROLE_D.SKID_MBP)
      join SKID_MBN using (SKID_MBN.REFERENCE,SKID_MBP.SKID_MBN)
   where K_ROLE.FIRMA=:FIRMA and K_ROLE.NAZWA=:NAZWA and K_ROLE.TYPE=:TYPE
   order by 1,2
end sql

formula

end formula

end proc


proc k_rap_u

desc
   Uzytkownicy raportu
end desc

params
   REF:=0 Integer
end params

sql
   select
      1 as REF,
      'raport10000000.xlsx    ' as PLIK,
      '                    ' as WINLOGIN,
      '                                        ' as WIN_PASS,
      '                                        ' as NAZWA
   from
      K_RAP_U
   where 1=2
end sql

formula
   K_INFO.prefix();
   K_INFO.first();
   K_RAPORT.index('NAZWA'); K_RAPORT.prefix();
   {? K_RAPORT.seek(:REF,)
   || K_RAP_U.index('K_RAPORT'); K_RAP_U.prefix(K_RAPORT.ref());
      {? K_RAP_U.first()
      || {!
         |? :RS.REF:=#K_RAP_U.ref();
            :RS.PLIK:='raport'+$:RS.REF+'.xlsx';
            :RS.WINLOGIN:={? K_RAP_U.USERS().CON_AD='T' & K_INFO.DOMENA<>'' || K_INFO.DOMENA+'\\' || '' ?}+USERS.WINLOGIN;
            :RS.WIN_PASS:=USERS.WIN_PASS;
            :RS.NAZWA:=USERS.DANE;
            :RS.add();
            K_RAP_U.next()
         !}
      ?}
   ?}
end formula

end proc


proc add_kom
desc
   Dodaje komentarz do pozycji planu
end desc

params
   K_HARM:=1 Integer
   K_PODWER:='' String[16]
   P1:='' String[1024]
   P2:='' String[1024]
   P3:='' String[1024]
   P4:='' String[1024]
   P5:='' String[1024]
   P6:='' String[1024]
   P7:='' String[1024]
   P8:='' String[1024]
   P9:='' String[1024]
   P10:='' String[1024]
   P11:='' String[1024]
   P12:='' String[1024]
   P13:='' String[1024]
   P14:='' String[1024]
   P15:='' String[1024]
   P16:='' String[1024]
   P17:='' String[1024]
   P18:='' String[1024]
   P19:='' String[1024]
   P20:='' String[1024]
   OK:=0 Integer
#{? 0 || :OK:=exec('add_poz','control',:WART,:OKRES,:WYMIAR01,:WYMIAR02,:WYMIAR03,:WYMIAR04,:WYMIAR05) ?}
end params

formula
   K_HARM.index('K_WERSJE'); K_HARM.prefix();
   {? K_HARM.seek(:K_HARM,)
   || K_PODWER.prefix();
      _podwer:={? :K_PODWER=''
               || null
               |? K_PODWER.seek(BIT.sqlint(:K_PODWER),)
               || K_PODWER.ref()
               || null
               ?};
      :OK:=exec('add_kom1','control',_podwer,:P1,:P2,:P3,:P4,:P5,:P6,:P7,:P8,:P9,:P10,:P11,:P12,:P13,:P14,:P15,:P16,:P17,:P18,:P19,:P20)
   ?}
end formula

sql
   select 1 as OK from K__POZ where 1=2
end sql

formula
   :RS.OK:=:OK;
   :RS.add()
end formula

end proc


proc zam_okr
desc
   Zamkniete okresy
end desc

params
   K_HARM:=1 Integer
   FIRMA:='' String[16]
   OD:='1234567890ABCDEF' String[16]
   DO:='1234567890ABCDEF' String[16]
   OK:=1 Integer
end params

formula
   K_HARM.index('K_WERSJE'); K_HARM.prefix();
   {? K_HARM.seek(:K_HARM,)
   || :FIRMA:=$K_HARM.FIRMA;
      :OD:=$K_HARM.OD;
      :DO:=$K_HARM.DO;
      :OK:=K_HARM.K_WERSJE().CZY_SYS='T'
   ?}
end formula

sql
   select
      OKRO_F.REFERENCE as REF,
      OKRO_F.NAZ||' '||ROK_F.NAZ as NAZ
   from OKRO_F join ROK_F
   where :OK=1 and ROK_F.FIRMA=:FIRMA and OKRO_F.REFERENCE>=:OD and OKRO_F.REFERENCE<=:DO and OKRO_F.ZAM_CON='T'
end sql

end proc


proc okr_nar
desc
   okresy narastajace
end desc

params
   OD String[16]
   DO String[16]
end params

sql
   select
      '                                                                                                                                                                                                                                                               ' as REF
   from SYSLOG
   where 1=2
end sql

formula
   _full:='';
   OKRO_F.index('FIRMA_NR');
   OKRO_F.prefix(REF.FIRMA);
   {? OKRO_F.seek(BIT.sqlint(:DO),)
   || _ref:=OKRO_F.ref();
      OKRO_F.cntx_psh();
      OKRO_F.prefix(REF.FIRMA,OKRO_F.ROK().POCZ_ROK);
      {? OKRO_F.last()
      || _full:=$OKRO_F.ref()
      ?};
      OKRO_F.cntx_pop();
      {? OKRO_F.seek(BIT.sqlint(:OD),)
      || OKRO_F.cntx_psh();
         OKRO_F.prefix(REF.FIRMA,OKRO_F.ROK().POCZ_ROK);
         {? OKRO_F.first()
         || _full:=$OKRO_F.ref()+'@'+_full
         ?};
         OKRO_F.cntx_pop();
         :RS.REF:='F'+_full;
         :RS.add();
         {!
         |? _txt:='';
            OKRO_F.cntx_psh();
            OKRO_F.prefix(REF.FIRMA,OKRO_F.ROK().POCZ_ROK);
            {!
            |? _txt+=(($OKRO_F.ref())+8)+'@';
               OKRO_F.next()
            !};
            OKRO_F.cntx_pop();
            :RS.REF:=_txt;
            :RS.add();
            _ref<>OKRO_F.ref() & OKRO_F.next()
         !}
      ?}
   ?}
end formula

end proc

proc pbud_qv
desc
   schemat danych
end desc
params
   MODEL:='MODEL' String[8]
   TYP:='PODZORG' String[8]
   SCHEMAT:='STRORG' String[8]
end params

formula
   SKID_MBN.index('KOD'); SKID_MBN.prefix(:MODEL);
   {? SKID_MBN.first() & SKID_MBN.KOD=:MODEL
   || SKID_MBP.index('LP'); SKID_MBP.prefix(SKID_MBN.ref(),1);
      {? SKID_MBP.first()
      || :SCHEMAT:=SKID_MBP.UD_SCH().SYMBOL;
         :TYP:=UD_SCH.UD_TYP().SYMBOL
      || :SCHEMAT:='';
         :TYP:=''
      ?}
   ?}
end formula

sql
   select
      UD_DEF.UD_SKL REF,
      UD_DEF.REFERENCE REF_NAD,
      UD_DEF.SYMBOL SYMBOL,
      UD_DEF.OPIS OPIS,
      UD_DEF.ZN_AGR as MNOZNIK,
      SKIDXDUD.ONLY_L as ONLY_L,
      K_FORM.REFERENCE as K_FORM,
      K_FORM.TYP as FORM_TYP,
      K_W_OBL.NAZ as K_W_OBL,
      '                                                                                                    '||
      '                                                                                                    '
      as F1,
      '                                                                                                    '||
      '                                                                                                    '
      as F2,
      '                                                                                                    '||
      '                                                                                                    '
      as F3,
      '                                                                                                    '||
      '                                                                                                    '
      as F4,
      '                                                                                                    '||
      '                                                                                                    '
      as F5,
      '                                                                                                    '||
      '                                                                                                    '
      as F6,
      '                                                                                                    '||
      '                                                                                                    '
      as F7,
      '                                                                                                    '||
      '                                                                                                    '
      as F8,
      '                                                                                                    '||
      '                                                                                                    '
      as F9,
      '                                                                                                    '||
      '                                                                                                    '
      as F10,
      '                                                                                                    '||
      '                                                                                                    '
      as F11,
      '                                                                                                    '||
      '                                                                                                    '
      as F12,
      '                                                                                                    '||
      '                                                                                                    '
      as F13,
      '                                                                                                    '||
      '                                                                                                    '
      as F14

   from
      UD_DEF
      join UD_SCH
      join UD_TYP
      join SKIDXDUD using (UD_DEF.UD_SKL,SKIDXDUD.POZ_BUD)
      join UD_SKL using (UD_DEF.UD_SKL,UD_SKL.REFERENCE)
      left join K_FORM using (UD_DEF.REFERENCE,K_FORM.UD_DEF)
      left join K_W_OBL using(K_FORM.K_W_OBL,K_W_OBL.REFERENCE)
   where
      UD_TYP.SYMBOL=:TYP and UD_SCH.SYMBOL=:SCHEMAT
end sql

formula
   UD_DEF.clear;
   {? :RS.first
   || {!
      |? _f:=exec('get_qv','control',BIT.sqlint(:RS.K_FORM),:RS.ONLY_L);
         :RS.F1:=200+_f; _f:=200-_f;
         :RS.F2:=200+_f; _f:=200-_f;
         :RS.F3:=200+_f; _f:=200-_f;
         :RS.F4:=200+_f; _f:=200-_f;
         :RS.F5:=200+_f; _f:=200-_f;
         :RS.F6:=200+_f; _f:=200-_f;
         :RS.F7:=200+_f; _f:=200-_f;
         :RS.F8:=200+_f; _f:=200-_f;
         :RS.F9:=200+_f; _f:=200-_f;
         :RS.F10:=200+_f; _f:=200-_f;
         :RS.F11:=200+_f; _f:=200-_f;
         :RS.F12:=200+_f; _f:=200-_f;
         :RS.F13:=200+_f; _f:=200-_f;
         :RS.F14:=200+_f; _f:=200-_f;
         :RS.REF_NAD:=
            {? UD_DEF.seek(BIT.sqlint(:RS.REF_NAD),)
            || {? UD_DEF.seek(UD_DEF.UD_DEF,)
               || BIT.refsql(UD_DEF.UD_SKL)
               || ''
               ?}
            || ''
            ?};
         :RS.put;
         :RS.next
      !}
   ?}
end formula
end proc


proc pbud_qv_all
desc
   schemat danych
end desc
params
   MODEL:='MODEL' String[8]
   TYP:='PODZORG' String[8]
   SCHEMAT:='STRORG' String[8]
end params

formula
   SKID_MBN.index('KOD'); SKID_MBN.prefix(:MODEL);
   {? SKID_MBN.first() & SKID_MBN.KOD=:MODEL
   || SKID_MBP.index('LP'); SKID_MBP.prefix(SKID_MBN.ref(),1);
      {? SKID_MBP.first()
      || :SCHEMAT:=SKID_MBP.UD_SCH().SYMBOL;
         :TYP:=UD_SCH.UD_TYP().SYMBOL
      || :SCHEMAT:='';
         :TYP:=''
      ?}
   ?}
end formula

sql
   select
      UD_DEF.REFERENCE as REF_ORG,
      UD_DEF.UD_SKL REF,
      UD_DEF.REFERENCE REF_NAD,
      UD_DEF.SYMBOL SYMBOL,
      UD_DEF.OPIS OPIS,
      UD_DEF.ZN_AGR as MNOZNIK,
      SKIDXDUD.ONLY_L as ONLY_L,
      SKIDXDUD.STR as STR,
      K_FORM.REFERENCE as K_FORM,
      K_FORM.TYP as FORM_TYP,
      K_W_OBL.NAZ as K_W_OBL,
      '                                                                                                    '||
      '                                                                                                    '
      as F1,
      '                                                                                                    '||
      '                                                                                                    '
      as F2,
      '                                                                                                    '||
      '                                                                                                    '
      as F3,
      '                                                                                                    '||
      '                                                                                                    '
      as F4,
      '                                                                                                    '||
      '                                                                                                    '
      as F5,
      '                                                                                                    '||
      '                                                                                                    '
      as F6,
      '                                                                                                    '||
      '                                                                                                    '
      as F7,
      '                                                                                                    '||
      '                                                                                                    '
      as F8,
      '                                                                                                    '||
      '                                                                                                    '
      as F9,
      '                                                                                                    '||
      '                                                                                                    '
      as F10,
      '                                                                                                    '||
      '                                                                                                    '
      as F11,
      '                                                                                                    '||
      '                                                                                                    '
      as F12,
      '                                                                                                    '||
      '                                                                                                    '
      as F13,
      '                                                                                                    '||
      '                                                                                                    '
      as F14

   from
      UD_DEF
      join UD_SCH
      join UD_TYP
      join SKIDXDUD using (UD_DEF.UD_SKL,SKIDXDUD.POZ_BUD)
      join UD_SKL using (UD_DEF.UD_SKL,UD_SKL.REFERENCE)
      left join K_FORM using (UD_DEF.REFERENCE,K_FORM.UD_DEF)
      left join K_W_OBL using(K_FORM.K_W_OBL,K_W_OBL.REFERENCE)
   where
      UD_TYP.SYMBOL=:TYP and UD_SCH.SYMBOL=:SCHEMAT
   order by
      UD_DEF.REFERENCE
end sql

formula
   UD_DEF.clear;
   {? :RS.first
   || {!
      |? _f:=exec('get_qv_all','control',:RS.K_FORM,:RS.ONLY_L,:RS.REF_NAD);
         :RS.F1:=200+_f; _f:=200-_f;
         :RS.F2:=200+_f; _f:=200-_f;
         :RS.F3:=200+_f; _f:=200-_f;
         :RS.F4:=200+_f; _f:=200-_f;
         :RS.F5:=200+_f; _f:=200-_f;
         :RS.F6:=200+_f; _f:=200-_f;
         :RS.F7:=200+_f; _f:=200-_f;
         :RS.F8:=200+_f; _f:=200-_f;
         :RS.F9:=200+_f; _f:=200-_f;
         :RS.F10:=200+_f; _f:=200-_f;
         :RS.F11:=200+_f; _f:=200-_f;
         :RS.F12:=200+_f; _f:=200-_f;
         :RS.F13:=200+_f; _f:=200-_f;
         :RS.F14:=200+_f; _f:=200-_f;
         :RS.REF_NAD:=
            {? UD_DEF.seek(BIT.sqlint(:RS.REF_NAD),)
            || {? UD_DEF.seek(UD_DEF.UD_DEF,)
               || BIT.refsql(UD_DEF.UD_SKL)
               || ''
               ?}
            || ''
            ?};
         :RS.put;
         :RS.next
      !}
   ?};
   UD_DEF.clear;
   {? :RS.first
   || {!
      |? {? :RS.K_FORM<>''
    ||:RS.K_FORM:='';
      :RS.FORM_TYP:='';
      :RS.K_W_OBL:='';
           _f:=exec('get_qv_all','control',:RS.K_FORM,:RS.ONLY_L,:RS.REF_ORG);
           :RS.F1:=200+_f; _f:=200-_f;
           :RS.F2:=200+_f; _f:=200-_f;
           :RS.F3:=200+_f; _f:=200-_f;
           :RS.F4:=200+_f; _f:=200-_f;
           :RS.F5:=200+_f; _f:=200-_f;
           :RS.F6:=200+_f; _f:=200-_f;
           :RS.F7:=200+_f; _f:=200-_f;
           :RS.F8:=200+_f; _f:=200-_f;
           :RS.F9:=200+_f; _f:=200-_f;
           :RS.F10:=200+_f; _f:=200-_f;
           :RS.F11:=200+_f; _f:=200-_f;
           :RS.F12:=200+_f; _f:=200-_f;
           :RS.F13:=200+_f; _f:=200-_f;
           :RS.F14:=200+_f; _f:=200-_f;
      :RS.add()
    ?};
         :RS.next
      !}
   ?}
end formula
end proc



proc pbud_qv_zmienne
desc
   schemat danych
end desc
params
   MODEL:='MODEL' String[8]
   TYP:='PODZORG' String[8]
   SCHEMAT:='STRORG' String[8]
end params

formula
   SKID_MBN.index('KOD'); SKID_MBN.prefix(:MODEL);
   {? SKID_MBN.first() & SKID_MBN.KOD=:MODEL
   || SKID_MBP.index('LP'); SKID_MBP.prefix(SKID_MBN.ref(),1);
      {? SKID_MBP.first()
      || :SCHEMAT:=SKID_MBP.UD_SCH().SYMBOL;
         :TYP:=UD_SCH.UD_TYP().SYMBOL
      || :SCHEMAT:='';
         :TYP:=''
      ?}
   ?}
end formula

sql
   select
      UD_DEF.REFERENCE as REF_ORG,
      UD_DEF.UD_SKL REF,
      UD_DEF.REFERENCE REF_NAD,
      UD_DEF.SYMBOL SYMBOL,
      UD_DEF.OPIS OPIS,
      UD_DEF.ZN_AGR as MNOZNIK,
      SKIDXDUD.ONLY_L as ONLY_L,
      K_FORM.REFERENCE as K_FORM,
      K_FORM.TYP as FORM_TYP,
      K_W_OBL.NAZ as K_W_OBL,
      '    ' as ZMIENNA,
      '                                                                                                    '||
      '                                                                                                    '
      as F1,
      '                                                                                                    '||
      '                                                                                                    '
      as F2,
      '                                                                                                    '||
      '                                                                                                    '
      as F3,
      '                                                                                                    '||
      '                                                                                                    '
      as F4,
      '                                                                                                    '||
      '                                                                                                    '
      as F5,
      '                                                                                                    '||
      '                                                                                                    '
      as F6,
      '                                                                                                    '||
      '                                                                                                    '
      as F7,
      '                                                                                                    '||
      '                                                                                                    '
      as F8,
      '                                                                                                    '||
      '                                                                                                    '
      as F9,
      '                                                                                                    '||
      '                                                                                                    '
      as F10,
      '                                                                                                    '||
      '                                                                                                    '
      as F11,
      '                                                                                                    '||
      '                                                                                                    '
      as F12,
      '                                                                                                    '||
      '                                                                                                    '
      as F13,
      '                                                                                                    '||
      '                                                                                                    '
      as F14

   from
      UD_DEF
      join UD_SCH
      join UD_TYP
      join SKIDXDUD using (UD_DEF.UD_SKL,SKIDXDUD.POZ_BUD)
      join UD_SKL using (UD_DEF.UD_SKL,UD_SKL.REFERENCE)
      left join K_FORM using (UD_DEF.REFERENCE,K_FORM.UD_DEF)
      left join K_W_OBL using(K_FORM.K_W_OBL,K_W_OBL.REFERENCE)
   where
      UD_TYP.SYMBOL=:TYP and UD_SCH.SYMBOL=:SCHEMAT
   order by
      UD_DEF.REFERENCE
end sql

formula
   UD_DEF.clear;
   _licznik:=1;
   {? :RS.first
   || {!
      |? _f:=exec('get_qv_zmienne','control',:RS.K_FORM,:RS.ONLY_L,:RS.REF_NAD);
         :RS.F1:=200+_f; _f:=200-_f;
         :RS.F2:=200+_f; _f:=200-_f;
         :RS.F3:=200+_f; _f:=200-_f;
         :RS.F4:=200+_f; _f:=200-_f;
         :RS.F5:=200+_f; _f:=200-_f;
         :RS.F6:=200+_f; _f:=200-_f;
         :RS.F7:=200+_f; _f:=200-_f;
         :RS.F8:=200+_f; _f:=200-_f;
         :RS.F9:=200+_f; _f:=200-_f;
         :RS.F10:=200+_f; _f:=200-_f;
         :RS.F11:=200+_f; _f:=200-_f;
         :RS.F12:=200+_f; _f:=200-_f;
         :RS.F13:=200+_f; _f:=200-_f;
         :RS.F14:=200+_f; _f:=200-_f;
         :RS.REF_NAD:=
            {? UD_DEF.seek(BIT.sqlint(:RS.REF_NAD),)
            || {? UD_DEF.seek(UD_DEF.UD_DEF,)
               || BIT.refsql(UD_DEF.UD_SKL)
               || ''
               ?}
            || ''
            ?};
         {?:RS.F1*'#(vW('
    ||:RS.ZMIENNA:='v'+('000'+($_licznik)+3);
      _licznik:=_licznik+1
    ?};
         :RS.put;
         :RS.next
      !}
   ?};
   UD_DEF.clear;
   {? :RS.first
   || {!
      |? {? :RS.K_FORM<>''
    ||:RS.K_FORM:='';
      :RS.FORM_TYP:='';
      :RS.K_W_OBL:='';
           _f:=exec('get_qv_zmienne','control',:RS.K_FORM,:RS.ONLY_L,:RS.REF_ORG);
           :RS.F1:=200+_f; _f:=200-_f;
           :RS.F2:=200+_f; _f:=200-_f;
           :RS.F3:=200+_f; _f:=200-_f;
           :RS.F4:=200+_f; _f:=200-_f;
           :RS.F5:=200+_f; _f:=200-_f;
           :RS.F6:=200+_f; _f:=200-_f;
           :RS.F7:=200+_f; _f:=200-_f;
           :RS.F8:=200+_f; _f:=200-_f;
           :RS.F9:=200+_f; _f:=200-_f;
           :RS.F10:=200+_f; _f:=200-_f;
           :RS.F11:=200+_f; _f:=200-_f;
           :RS.F12:=200+_f; _f:=200-_f;
           :RS.F13:=200+_f; _f:=200-_f;
           :RS.F14:=200+_f; _f:=200-_f;
      {?:RS.F1*'#(vW('
      ||:RS.ZMIENNA:='v'+('000'+($_licznik)+3);
        _licznik:=_licznik+1
      ?};
      :RS.add()
    ?};
         :RS.next
      !}
   ?};
   exec('get_qv_kor','control',:RS)
end formula
end proc


proc pbud_qv_all_spr
desc
   schemat danych
end desc
params
   MODEL:='MODEL' String[8]
   TYP:='PODZORG' String[8]
   SCHEMAT:='STRORG' String[8]
end params

formula
   SKID_MBN.index('KOD'); SKID_MBN.prefix(:MODEL);
   {? SKID_MBN.first() & SKID_MBN.KOD=:MODEL
   || SKID_MBP.index('LP'); SKID_MBP.prefix(SKID_MBN.ref(),1);
      {? SKID_MBP.first()
      || :SCHEMAT:=SKID_MBP.UD_SCH().SYMBOL;
         :TYP:=UD_SCH.UD_TYP().SYMBOL
      || :SCHEMAT:='';
         :TYP:=''
      ?}
   ?}
end formula

sql
   select
      UD_DEF.REFERENCE as REF_ORG,
      UD_DEF.UD_SKL REF,
      UD_DEF.REFERENCE REF_NAD,
      UD_DEF.SYMBOL SYMBOL,
      UD_DEF.OPIS OPIS,
      UD_DEF.ZN_AGR as MNOZNIK,
      K_FORM.REFERENCE as K_FORM,
      K_FORM.TYP as FORM_TYP,
      K_W_OBL.NAZ as K_W_OBL,
      '                                                                                                    '||
      '                                                                                                    '
      as F1,
      '                                                                                                    '||
      '                                                                                                    '
      as F2,
      '                                                                                                    '||
      '                                                                                                    '
      as F3,
      '                                                                                                    '||
      '                                                                                                    '
      as F4,
      '                                                                                                    '||
      '                                                                                                    '
      as F5,
      '                                                                                                    '||
      '                                                                                                    '
      as F6,
      '                                                                                                    '||
      '                                                                                                    '
      as F7,
      '                                                                                                    '||
      '                                                                                                    '
      as F8,
      '                                                                                                    '||
      '                                                                                                    '
      as F9,
      '                                                                                                    '||
      '                                                                                                    '
      as F10,
      '                                                                                                    '||
      '                                                                                                    '
      as F11,
      '                                                                                                    '||
      '                                                                                                    '
      as F12,
      '                                                                                                    '||
      '                                                                                                    '
      as F13,
      '                                                                                                    '||
      '                                                                                                    '
      as F14

   from
      UD_DEF
      join UD_SCH
      join UD_TYP
      join UD_SKL using (UD_DEF.UD_SKL,UD_SKL.REFERENCE)
      left join K_FORM using (UD_DEF.REFERENCE,K_FORM.UD_DEF)
      left join K_W_OBL using(K_FORM.K_W_OBL,K_W_OBL.REFERENCE)
   where
      UD_TYP.SYMBOL=:TYP and UD_SCH.SYMBOL=:SCHEMAT
   order by
      UD_DEF.REFERENCE
end sql

formula
   UD_DEF.clear;
   {? :RS.first
   || {!
      |? _f:=exec('get_qv_all','control',:RS.K_FORM,'N',:RS.REF_NAD);
         :RS.F1:=200+_f; _f:=200-_f;
         :RS.F2:=200+_f; _f:=200-_f;
         :RS.F3:=200+_f; _f:=200-_f;
         :RS.F4:=200+_f; _f:=200-_f;
         :RS.F5:=200+_f; _f:=200-_f;
         :RS.F6:=200+_f; _f:=200-_f;
         :RS.F7:=200+_f; _f:=200-_f;
         :RS.F8:=200+_f; _f:=200-_f;
         :RS.F9:=200+_f; _f:=200-_f;
         :RS.F10:=200+_f; _f:=200-_f;
         :RS.F11:=200+_f; _f:=200-_f;
         :RS.F12:=200+_f; _f:=200-_f;
         :RS.F13:=200+_f; _f:=200-_f;
         :RS.F14:=200+_f; _f:=200-_f;
         :RS.REF_NAD:=
            {? UD_DEF.seek(BIT.sqlint(:RS.REF_NAD),)
            || {? UD_DEF.seek(UD_DEF.UD_DEF,)
               || BIT.refsql(UD_DEF.UD_SKL)
               || ''
               ?}
            || ''
            ?};
         :RS.put;
         :RS.next
      !}
   ?};
   UD_DEF.clear;
   {? :RS.first
   || {!
      |? {? :RS.K_FORM<>''
    ||:RS.K_FORM:='';
      :RS.FORM_TYP:='';
      :RS.K_W_OBL:='';
           _f:=exec('get_qv_all','control',:RS.K_FORM,:RS.ONLY_L,:RS.REF_ORG);
           :RS.F1:=200+_f; _f:=200-_f;
           :RS.F2:=200+_f; _f:=200-_f;
           :RS.F3:=200+_f; _f:=200-_f;
           :RS.F4:=200+_f; _f:=200-_f;
           :RS.F5:=200+_f; _f:=200-_f;
           :RS.F6:=200+_f; _f:=200-_f;
           :RS.F7:=200+_f; _f:=200-_f;
           :RS.F8:=200+_f; _f:=200-_f;
           :RS.F9:=200+_f; _f:=200-_f;
           :RS.F10:=200+_f; _f:=200-_f;
           :RS.F11:=200+_f; _f:=200-_f;
           :RS.F12:=200+_f; _f:=200-_f;
           :RS.F13:=200+_f; _f:=200-_f;
           :RS.F14:=200+_f; _f:=200-_f;
      :RS.add()
    ?};
         :RS.next
      !}
   ?}
end formula
end proc


proc k_podwer
desc
   Podwersje
end desc

params
   K_PODWER:='' String[16]
   K_WERSJE:='' String[16]
   USER:='' String[100]
end params

formula
   {? exec('getUser','users',:USER) & exec('hasAction','users','CTR_HBD_DDPW',USERS.ref())
   || :USER:=$USERS.ref()
   || :USER:='users'
   ?}

end formula

sql
   select
      K_PODWER.REFERENCE as REF,
      K_PODWER.SYM,
      K_PODWER.OPIS,
      USERS.KOD,
      K_PODWER.READ,
      K_PODWER.WRITE
   from K_PODWER join USERS
   where :K_PODWER='' and K_PODWER.K_WERSJE=:K_WERSJE and (K_PODWER.READ='T' or K_PODWER.USERS=:USER) or
         :K_PODWER<>'' and K_PODWER.REFERENCE=:K_PODWER

end sql

end proc


proc k_podwer_edit
desc
   Podwersje redakcja
end desc

params
   K_PODWER String[16]
   DEL:=1 INTEGER
   SYM:='' String[20]
   OPIS:='' String[255]
   USER:='' String[100]
   K_WERSJE:='' String[16]
   READ:='N' String[1]
   WRITE:='N' String[1]
   WYNIK:='' String[255]
   REF:='' String[16]
end params

formula
   K_PODWER.index('UNIK');
   K_PODWER.prefix();
   {? :K_PODWER=''
   || K_PODWER.blank(1);
      _akc:='dołączania';
      _akc2:='dołączyć';
      _ok:=1
   || _ok:=K_PODWER.seek(BIT.sqlint(:K_PODWER),);
      _akc:='poprawiania';
      _akc2:='poprawić'
   ?};
   {? _ok
   || {? :DEL
      || {? exec('users','#users',:USER) & exec('hasAction','users','CTR_HBD_DDPW',USERS.ref())
         || :REF:=$K_PODWER.ref();
            {? K_PODWER.USERS<>USERS.ref()
            || :WYNIK:='Nie można usuwać podwersji innego użytkownika.'
            |? K_PODWER.count()>0
            || :WYNIK:='Istnieją dane przypisane do podwersji.\nUsunięcie niemożliwe.'
            |? K_PODWER.del(,1)=0
            || :WYNIK:='Nie udało się usunąć podwersji.'
            ?}
         || :WYNIK:='Brak uprawnien do usuwania podwersji.'
         ?}
      || _ref:=K_PODWER.ref();
         K_PODWER.SYM:=:SYM;
         K_PODWER.OPIS:=:OPIS;
         _user:=K_PODWER.USERS;
         K_PODWER.USERS:={? exec('getUser','users',:USER) || USERS.ref() || null ?};
         K_WERSJE.prefix();
         K_PODWER.K_WERSJE:={? K_WERSJE.seek(BIT.sqlint(:K_WERSJE),) || K_WERSJE.ref() || null ?};
         K_PODWER.READ:=:READ;
         K_PODWER.WRITE:=:WRITE;
         _f:=fopen('C:/test.txt','w',0);
         {? _f
         || fwrite(_f,:READ+','+:WRITE);
            fclose(_f)
         ?};
         {? K_PODWER.USERS=null | ~exec('hasAction','users','CTR_HBD_DDPW',K_PODWER.USERS)
         || :WYNIK:='Brak uprawnień do '+_akc+' podwersji.'
         |? _user<>null & K_PODWER.USERS<>_user
         || :WYNIK:='Nie można poprawiać podwersji innego użytkownika.'
         |? K_PODWER.K_WERSJE=null
         || :WYNIK:='Nie znaleziono wersji planu.'
         |? (K_PODWER.cntx_psh();
            _v:=K_PODWER.find_key(K_PODWER.K_WERSJE,K_PODWER.USERS,K_PODWER.SYM,);
            K_PODWER.cntx_pop();
            _v) & (:K_PODWER='' | _ref<>K_PODWER.ref())
         || :WYNIK:='Istnieje podwersja o symbolu \''+K_PODWER.SYM+'\'.'
         |? :K_PODWER='' & ~K_PODWER.add() | :K_PODWER<>'' & ~K_PODWER.put()
         || :WYNIK:='Nie udało się '+_akc2+' podwersji.'
         || :REF:=$K_PODWER.ref()
         ?}
      ?}
   || :WYNIK:='Nie znaleziono podwersji.'
   ?}
end formula

sql
   select
      '                                                                                                                                                                                                        ' as WYNIK,
      '1234567890123456' as REF
   from SYSLOG
   where 1=0
end sql

formula
   :RS.blank(1);
   :RS.WYNIK:=:WYNIK;
   :RS.REF:=:REF;
   :RS.add()
end formula

end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 c50fde0b71c0a6329ffe3d5644501d1f2c6f85759d155cfeb80cca3e785acb289fc0eb5bb779f6b08ae907e632ad09bd24ba9948d70944a2d1b128cf2122eb2090ff4a623440484bd6ad29003fe31829880ade3ed908ca8b4af78593f02415a4badf1da6c880755ba1dc193e2f6de6c1746c7974e85b9204107d241a09a2dbe6
