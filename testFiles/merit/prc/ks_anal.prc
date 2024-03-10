:!UTF-8
proc ks_anal
desc
 Tabela dla potrzeb wydruku obrotów kont analitycznych
end desc
params
 ROK    STRING[2], Kod roku
 NROK   STRING[20],Nazwa roku
 WAL    STRING[3], Kod waluty
 WZ     INTEGER,   Czy uwzględniac parametr scalania dla wzorca (1/0)
 ODD    STRING[8], Jednostka księgowa
 UT_KS  STRING[1], Podsumowanie po każdym poziomie (T/N)
 SO     STRING[1], BO (S)aldo/(O)broty
 RK     INTEGER, 1-pozabil,2-bil,3-wszystkie,4-wynikowe,5-bez pozabil
 ZK     INTEGER,   (0)Prefix,(2)Maska,(4)Zakres
 PRFX   STRING[35],Prefix
 MASKA  STRING[35],Maska
 KS_OD  STRING[6], (Zakres) Od konta
 KS_DO  STRING[6], (Zakres) Do konta
 SCH    STRING[8], Schemat kont
 PZ     STRING[1], Druk. pozycje zerowe (T/N)
 SEP    STRING[1], Separator
 SYNT   INTEGER,   Dł. syntetyki
 ZAM    STRING[1], Okres zamknięty (T/N)
 RSCH   INTEGER,   Ref schematu kont
 STAMP  STRING[29],USER tm_stamp
 DOD    DATE,      Od daty
 DDO    DATE,      Do daty
 ZBO    INTEGER,   Obroty narastająco z BO
 PS     INTEGER,   Konta aktywno-pasywne z podwójnymi saldami (1/0)
 BZ     STRING[1], Czy uwzględnić bilans zamknięcia
 KURS   STRING[10], Kurs waluty
 ZOIS   INTEGER,   Czy generowane dla zakładki Zestawienie obrotów i sald w Księgach rach. (1/0)
end params
sql
select ' ' as REK, KS.SYM as KS, KS.SALDO as KSSALDO, 0 as SCAL, AN.SYM as KONTO,
       0 as POZ,
       '                                                                                ' as OPIS,
       cast(0 as real_type) as BOWN, cast(0 as real_type) as BOMA,
       cast(0 as real_type) as OBWN, cast(0 as real_type) as OBMA,
       cast(0 as real_type) as ONWN, cast(0 as real_type) as ONMA,
       cast(0 as real_type) as SAWN, cast(0 as real_type) as SAMA
       from AN join KS using (AN.KS, KS.REFERENCE)
where AN.SYM is null
end sql
formula
 exec('F','object');
 ROK_F.cntx_psh(); ROK_F.index('KOD'); ROK_F.prefix(REF.FIRMA,:ROK);
 _ar:=SSTALE.AR; _ao:=SSTALE.AO; _arok:=BILANSP.AROK; _asep:=BILANSP.ASEP; _asynt:=BILANSP.ASYNT;
 {? ROK_F.first() & ROK_F.KOD=:ROK
 || AN.cntx_psh(); AN.use('koan__'+ROK_F.KOD); AN.prefix();
    OBR.cntx_psh(); OBR.use('obroty'+ROK_F.KOD); OBR.prefix();
    OKRO_F.cntx_psh(); OKRO_F.index('ROK'); OKRO_F.prefix(ROK_F.ref());
    {? OKRO_F.first()
    || SSTALE.AR:=ROK_F.ref(); SSTALE.AO:=OKRO_F.ref();
       BILANSP.AROK:=ROK_F.ref();
       BILANSP.ASEP:=ROK_F.SEP;
       BILANSP.ASYNT:=ROK_F.SYNT;
       {? :ZOIS=0
       || exec('ks_anal','!fks_ksr_zbos',:ROK,:SEP,:RS,:WAL,:WZ,:ODD,:UT_KS,:SO,:RK,:ZK,:PRFX,:MASKA,:KS_OD,:KS_DO,:SCH,:PZ,:SYNT,:ZAM,:RSCH,:STAMP,:DOD,:DDO,:ZBO,:PS,:BZ,#:KURS)
       || exec('ks_anal_zois','!fks_ksr_zbos',:ROK,:SEP,:RS,:WAL,:WZ,:ODD,:UT_KS,:SO,:RK,:ZK,:PRFX,:MASKA,:KS_OD,:KS_DO,:SCH,:PZ,:SYNT,:ZAM,:RSCH,:STAMP,:DOD,:DDO,:ZBO,:PS,:BZ,#:KURS)
       ?};
       {? :STAMP<>''
       || TMPSIK.index('TEXT1'); TMPSIK.prefix('K',:STAMP);
          {? TMPSIK.first() || {! |? TMPSIK.del() !} ?}
       ?}
    ?};
    OKRO_F.cntx_pop(); AN.cntx_pop(); OBR.cntx_pop()
 ?};
 SSTALE.AR:=_ar; SSTALE.AO:=_ao; BILANSP.AROK:=_arok; BILANSP.ASEP:=_asep; BILANSP.ASYNT:=_asynt;
 ROK_F.cntx_pop()
end formula
end proc

#Sign Version 2.0 jowisz:1048 2023/06/23 14:17:50 2003349b1ce2f14d697b3b0906412e81cb7ed7705205c948731034e5b5f37f06e2b2bf4f59c38deb50859e27788a99494984b2c6c8d799cd90a88496a922f6a3707acd9f7fe386745d591ad2533c55543851c6348a23b5e4fdfc68d4b73d19c7178964e2c53868e74b830e984aa35ff1912f7c4c11a37dd711d94cbad1d86064
