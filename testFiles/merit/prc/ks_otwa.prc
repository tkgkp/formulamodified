:!UTF-8
proc ks_otwa
desc
 Tabela dla potrzeb wudruku bilansu otwarcia
end desc
params
 ROK   STRING[2], Kod roku
 NROK  STRING[20],Nazwa roku
 SA    STRING[1], (S)yntetycznie/(A)nalitycznie
 WAL   STRING[3], Kod waluty
 WALN  STRING[3], Kod waluty narodowej
 ODD   STRING[8], Jednostka księgowa
 UT_KS STRING[1], Wyszczególnienie korekt (T/N)
 SO    STRING[1], (S)aldo/(O)broty
 RK    INTEGER,   (1)pozabilansowe,(2)bilansowe,(3)wszystkie,(4)wynikowe, (5)wszystkie bez pozabilansowych
 PS    STRING[1], Podwójne salda (T/N)
 ZK    INTEGER,   (0)Prefix,(1)wszystkie,(2)Maska,(4)Zakres
 PRFX  STRING[35],Prefix
 MASKA STRING[35],Maska
 KS_OD STRING[6], (Zakres) Od konta
 KS_DO STRING[6], (Zakres) Do konta
 SCH   STRING[8],  Schemat kont
 PZ    STRING[1], Druk. pozycje zerowe (T/N)
 SEP   STRING[1], Separator
 SYNT  INTEGER,   Dł. syntetyki
 ZAM   STRING[1], Okres zamknięty (T/N)
 RSCH  INTEGER,   Ref schematu kont
 STAMP STRING[29],USER tm_stamp
 KURS  STRING[10],Kurs waluty
end params
formula
{? :NROK='' & :ROK<>'' || :NROK:=:ROK ?};
{? :SA='' || :SA:='S' ?};
{? :WALN='' & :WAL<>'' || :WALN:=:WAL ?};
{? :UT_KS='' || :UT_KS:='N' ?};
{? :SO='' || :SO:='S' ?};
{? :RK=0 || :RK:=3 ?};
{? :PS='' || :PS:='N'?};
{? :PZ='' || :PZ:='T' ?}
end formula
sql
select ' ' as REK, KS.SYM as KS, KS.SALDO as KSSALDO, AN.SYM as KONTO,  KS.NAZ as OPIS,
       cast(0 as real_type) as BOWN, cast(0 as real_type) as BOMA,
       cast(0 as real_type) as BZWN, cast(0 as real_type) as BZMA,
       cast(0 as real_type) as KBOWN, cast(0 as real_type) as KBOMA,
       0 as POZ from AN join KS using (AN.KS, KS.REFERENCE)
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
       exec('ks_otwa','!fks_ksr_zbos',:ROK,:SEP,:RS,:SA,:WAL,:WALN,:ODD,:UT_KS,:SO,:RK,:PS,:ZK,:PRFX,:MASKA,:KS_OD,:KS_DO,:SCH,:PZ,:SYNT,:ZAM,:RSCH,:STAMP,#:KURS);
       {? :STAMP<>'' || TMPSIK.index('TEXT1'); TMPSIK.prefix('K',:STAMP); {?TMPSIK.first() || {! |? TMPSIK.del() !} ?} ?}
    ?};
    OKRO_F.cntx_pop(); AN.cntx_pop(); OBR.cntx_pop()
 ?};
 SSTALE.AR:=_ar; SSTALE.AO:=_ao; BILANSP.AROK:=_arok; BILANSP.ASEP:=_asep; BILANSP.ASYNT:=_asynt;
 ROK_F.cntx_pop()
end formula
end proc

#Sign Version 2.0 jowisz:1028 2019/06/07 16:02:37 e3eb4c6c76cfd7aee0af7b0f09bf3f3b85bcbd70542e528f1de32e9ea54ca120653d1b422769d27ec45bcc667e17f703b2a4959a490b29cecf21af97b046045d332c758cdb1965900f9178ba6cac5148cad17d30591df196fc22d34b30544f907dd93de5789a615e4f30f103d05ba16de804073c6560fe1269ea0644007d6947
