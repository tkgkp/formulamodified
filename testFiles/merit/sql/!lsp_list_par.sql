:!UTF-8
fakt_001@1@Kontrahent@S@50@
fakt_001@1@@
fakt_001@1@exec('no_limit','sql')@
fakt_001@1@@
fakt_001@1@@
fakt_001@1@exec('kh','sql')@
fakt_001@1@exec('f3_only','sql')@
fakt_001@2@Bieżący oddział@F@0@
fakt_001@2@@
fakt_001@2@ST.ODDZ@
fakt_001@2@@
fakt_001@2@@
fakt_001@2@@
fakt_001@2@@
fakt_001@3@Od daty wystawienia@D@0@
fakt_001@3@@
fakt_001@3@date(ST.AR,ST.AM,1)@
fakt_001@3@@
fakt_001@3@@
fakt_001@3@@
fakt_001@3@@
fakt_001@4@Do daty wystawienia@D@0@
fakt_001@4@@
fakt_001@4@date(ST.AR,ST.AM,0)@
fakt_001@4@@
fakt_001@4@@
fakt_001@4@@
fakt_001@4@@
fakt_001@5@Od daty sprzedaży@D@0@
fakt_001@5@@
fakt_001@5@date(ST.AR,ST.AM,1)@
fakt_001@5@@
fakt_001@5@@
fakt_001@5@@
fakt_001@5@@
fakt_001@6@Do daty sprzedaży@D@0@
fakt_001@6@@
fakt_001@6@date(ST.AR,ST.AM,0)@
fakt_001@6@@
fakt_001@6@@
fakt_001@6@@
fakt_001@6@@
fakt_001@7@Od terminu płatności@D@0@
fakt_001@7@@
fakt_001@7@date(ST.AR,ST.AM,1)@
fakt_001@7@@
fakt_001@7@@
fakt_001@7@@
fakt_001@7@@
fakt_001@8@Do terminu płatności@D@0@
fakt_001@8@@
fakt_001@8@date(ST.AR,ST.AM,0)@
fakt_001@8@@
fakt_001@8@@
fakt_001@8@@
fakt_001@8@@
fakt_001@9@Uprawnione STS@F@0@
fakt_001@9@@
fakt_001@9@exec('stss','users',OPERATOR.USER,'STS')@
fakt_001@9@@
fakt_001@9@@
fakt_001@9@@
fakt_001@9@@
fakt_002@1@Symbol dokumentu@S@20@
fakt_002@1@@
fakt_002@1@''@
fakt_002@1@@
fakt_002@1@@
fakt_002@1@@
fakt_002@1@@
fakt_002@2@Oddział@F@0@
fakt_002@2@@
fakt_002@2@ST.ODDZ@
fakt_002@2@@
fakt_002@2@@
fakt_002@2@@
fakt_002@2@@
fakt_002@3@Od daty wystawienia@D@0@
fakt_002@3@@
fakt_002@3@date(ST.AR,ST.AM,1)@
fakt_002@3@@
fakt_002@3@@
fakt_002@3@@
fakt_002@3@@
fakt_002@4@Do daty wystawienia@D@0@
fakt_002@4@@
fakt_002@4@date(ST.AR,ST.AM,0)@
fakt_002@4@@
fakt_002@4@@
fakt_002@4@@
fakt_002@4@@
fakt_002@5@Uprawnione STS@F@0@
fakt_002@5@@
fakt_002@5@exec('stss','users',OPERATOR.USER,'STS')@
fakt_002@5@@
fakt_002@5@@
fakt_002@5@@
fakt_002@5@@
fakt_003@1@PKWiU@S@20@
fakt_003@1@@
fakt_003@1@@
fakt_003@1@@
fakt_003@1@@
fakt_003@1@exec('pkwiuf3','sql')@
fakt_003@1@@
fakt_003@2@Oddział@F@0@
fakt_003@2@@
fakt_003@2@ST.ODDZ@
fakt_003@2@@
fakt_003@2@@
fakt_003@2@@
fakt_003@2@@
fakt_003@3@Od daty wystawienia@D@0@
fakt_003@3@@
fakt_003@3@date(ST.AR,ST.AM,1)@
fakt_003@3@@
fakt_003@3@@
fakt_003@3@@
fakt_003@3@@
fakt_003@4@Do daty wystawienia@D@0@
fakt_003@4@@
fakt_003@4@date(ST.AR,ST.AM,0)@
fakt_003@4@@
fakt_003@4@@
fakt_003@4@@
fakt_003@4@@
fakt_003@5@Uprawnione STS@F@0@
fakt_003@5@@
fakt_003@5@exec('stss','users',OPERATOR.USER,'STS')@
fakt_003@5@@
fakt_003@5@@
fakt_003@5@@
fakt_003@5@@
fakt_003@6@Materiał@F@0@
fakt_003@6@@
fakt_003@6@exec('m_pkwiu','sql')@
fakt_003@6@@
fakt_003@6@@
fakt_003@6@@
fakt_003@6@@
fakt_003@7@_fo300201@F@0@
fakt_003@7@@
fakt_003@7@exec('get','#params',300201,2)@
fakt_003@7@@
fakt_003@7@@
fakt_003@7@@
fakt_003@7@@
fakt_004@1@Kod kontrahenta@S@8@
fakt_004@1@@
fakt_004@1@@
fakt_004@1@@
fakt_004@1@@
fakt_004@1@_akt:=fld();KH.index('KOD'); KH.prefix(2); KH.win_sel('WER'); {? KH.select || KH.KOD || _akt ?}@
fakt_004@1@@
fakt_004@2@Nazwa kontrahenta@S@50@
fakt_004@2@@
fakt_004@2@@
fakt_004@2@@
fakt_004@2@@
fakt_004@2@_akt:=fld(); KH.index('KOD'); KH.prefix(2); KH.win_sel('WER'); {? KH.select || KH.NAZ || _akt ?}@
fakt_004@2@@
fakt_004@3@Miasto kontrahenta@S@20@
fakt_004@3@@
fakt_004@3@@
fakt_004@3@@
fakt_004@3@@
fakt_004@3@@
fakt_004@3@@
fakt_004@4@Ulica kontrahenta@S@20@
fakt_004@4@@
fakt_004@4@@
fakt_004@4@@
fakt_004@4@@
fakt_004@4@@
fakt_004@4@@
fakt_004@5@NIP kontrahenta@S@20@
fakt_004@5@@
fakt_004@5@@
fakt_004@5@@
fakt_004@5@@
fakt_004@5@@
fakt_004@5@@
fakt_004@6@Oddział@F@0@
fakt_004@6@@
fakt_004@6@ST.ODDZ@
fakt_004@6@@
fakt_004@6@@
fakt_004@6@@
fakt_004@6@@
fakt_004@7@Od daty wystawienia@D@0@
fakt_004@7@@
fakt_004@7@@
fakt_004@7@@
fakt_004@7@@
fakt_004@7@@
fakt_004@7@@
fakt_004@8@Do daty wystawienia@D@0@
fakt_004@8@@
fakt_004@8@@
fakt_004@8@@
fakt_004@8@@
fakt_004@8@@
fakt_004@8@@
fakt_004@9@Dla Indeksu@S@50@
fakt_004@9@@
fakt_004@9@exec('no_limit','sql')@
fakt_004@9@@
fakt_004@9@@
fakt_004@9@exec('tow','sql')@
fakt_004@9@exec('f3_only','sql')@
fakt_004@10@Uprawnione STS@F@0@
fakt_004@10@@
fakt_004@10@exec('stss','users',OPERATOR.USER,'STS')@
fakt_004@10@@
fakt_004@10@@
fakt_004@10@@
fakt_004@10@@
fakt_005@1@Termin płatności od@D@0@
fakt_005@1@@
fakt_005@1@date(ST.AR,ST.AM,1)@
fakt_005@1@@
fakt_005@1@@
fakt_005@1@@
fakt_005@1@@
fakt_005@2@Termin płatności do@D@0@
fakt_005@2@@
fakt_005@2@date(ST.AR,ST.AM,0)@
fakt_005@2@@
fakt_005@2@@
fakt_005@2@@
fakt_005@2@@
fakt_005@3@bieżący oddział@F@0@
fakt_005@3@@
fakt_005@3@ST.ODDZ@
fakt_005@3@@
fakt_005@3@@
fakt_005@3@@
fakt_005@3@@
fakt_005@4@Data od wystawienia@D@0@
fakt_005@4@@
fakt_005@4@date(ST.AR,ST.AM,1)@
fakt_005@4@@
fakt_005@4@@
fakt_005@4@@
fakt_005@4@@
fakt_005@5@Data do wystawienia@D@0@
fakt_005@5@@
fakt_005@5@date(ST.AR,ST.AM,0)@
fakt_005@5@@
fakt_005@5@@
fakt_005@5@@
fakt_005@5@@
fakt_005@6@Uprawnione STS@F@0@
fakt_005@6@@
fakt_005@6@exec('stss','users',OPERATOR.USER,'STS')@
fakt_005@6@@
fakt_005@6@@
fakt_005@6@@
fakt_005@6@@
fakt_006@1@bieżący oddział@F@0@
fakt_006@1@@
fakt_006@1@ST.ODDZ@
fakt_006@1@@
fakt_006@1@@
fakt_006@1@@
fakt_006@1@@
fakt_006@2@Od daty wystawienia@D@0@
fakt_006@2@@
fakt_006@2@@
fakt_006@2@@
fakt_006@2@@
fakt_006@2@@
fakt_006@2@@
fakt_006@3@Do daty wystawienia@D@0@
fakt_006@3@@
fakt_006@3@@
fakt_006@3@@
fakt_006@3@@
fakt_006@3@@
fakt_006@3@@
fakt_006@4@Powyżej wartości@R@0@
fakt_006@4@@
fakt_006@4@@
fakt_006@4@@
fakt_006@4@@
fakt_006@4@@
fakt_006@4@@
fakt_006@5@Kod grupy kontrahenta@S@20@
fakt_006@5@@
fakt_006@5@@
fakt_006@5@@
fakt_006@5@@
fakt_006@5@_akt:=fld(); GRKH.index('KOD'); GRKH.prefix(); GRKH.win_sel('SEL'); {? GRKH.select || GRKH.KOD || _akt ?}@
fakt_006@5@{? fld* '\'' || FUN.info('Należy usunąć niedozwolone znaki.'); 0 || 1 ?}@
fakt_006@6@Uprawnione STS@F@0@
fakt_006@6@@
fakt_006@6@exec('stss','users',OPERATOR.USER,'STS')@
fakt_006@6@@
fakt_006@6@@
fakt_006@6@@
fakt_006@6@@
fakt_007@1@Bieżący oddział@F@0@
fakt_007@1@@
fakt_007@1@ST.ODDZ@
fakt_007@1@@
fakt_007@1@@
fakt_007@1@@
fakt_007@1@@
fakt_007@2@Od daty wystawienia@D@0@
fakt_007@2@@
fakt_007@2@@
fakt_007@2@@
fakt_007@2@@
fakt_007@2@@
fakt_007@2@@
fakt_007@3@Do daty wystawienia@D@0@
fakt_007@3@@
fakt_007@3@@
fakt_007@3@@
fakt_007@3@@
fakt_007@3@@
fakt_007@3@@
fakt_007@4@Suma netto grup powyżej@R@0@
fakt_007@4@@
fakt_007@4@@
fakt_007@4@@
fakt_007@4@@
fakt_007@4@@
fakt_007@4@@
fakt_007@5@Uprawnione STS@F@0@
fakt_007@5@@
fakt_007@5@exec('stss','users',OPERATOR.USER,'STS')@
fakt_007@5@@
fakt_007@5@@
fakt_007@5@@
fakt_007@5@@
fakt_008@1@bieżący oddzial@F@0@
fakt_008@1@@
fakt_008@1@ST.ODDZ@
fakt_008@1@@
fakt_008@1@@
fakt_008@1@@
fakt_008@1@@
fakt_008@2@Od daty wystawienia@D@0@
fakt_008@2@@
fakt_008@2@@
fakt_008@2@@
fakt_008@2@@
fakt_008@2@@
fakt_008@2@@
fakt_008@3@Do daty wystawienia@D@0@
fakt_008@3@@
fakt_008@3@@
fakt_008@3@@
fakt_008@3@@
fakt_008@3@@
fakt_008@3@@
fakt_008@4@Uprawnione STS@F@0@
fakt_008@4@@
fakt_008@4@exec('stss','users',OPERATOR.USER,'STS')@
fakt_008@4@@
fakt_008@4@@
fakt_008@4@@
fakt_008@4@@
fakt_009@1@Od daty wystawienia@D@0@
fakt_009@1@@
fakt_009@1@date(ST.AR,ST.AM,1)@
fakt_009@1@@
fakt_009@1@@
fakt_009@1@@
fakt_009@1@@
fakt_009@2@Do daty wystawienia@D@0@
fakt_009@2@@
fakt_009@2@date(ST.AR,ST.AM,0)@
fakt_009@2@@
fakt_009@2@@
fakt_009@2@@
fakt_009@2@@
fakt_009@3@Oddział@S@50@
fakt_009@3@@
fakt_009@3@exec('oddz_bl','sql')@
fakt_009@3@@
fakt_009@3@@
fakt_009@3@exec('oddz','sql','FAKS.ODDZ')@
fakt_009@3@exec('oddz_ae','sql',fld())@
fakt_009@4@Stanowisko sprzedaży@S@50@
fakt_009@4@@
fakt_009@4@exec('fakt_09_sts_bl','sql')@
fakt_009@4@@
fakt_009@4@@
fakt_009@4@exec('sts','sql')@
fakt_009@4@exec('fakt_09_sts_ae','sql',fld())@
fakt_009@5@Typ dok. sprzedaży@S@50@
fakt_009@5@@
fakt_009@5@exec('no_limit','sql')@
fakt_009@5@@
fakt_009@5@@
fakt_009@5@exec('typysp','sql')@
fakt_009@5@exec('f3_only','sql')@
fakt_009@6@Grupa kontrahentów@S@50@
fakt_009@6@@
fakt_009@6@exec('no_limit','sql')@
fakt_009@6@@
fakt_009@6@@
fakt_009@6@exec('grkh','sql')@
fakt_009@6@exec('f3_only','sql')@
fakt_009@7@Kontrahent@S@50@
fakt_009@7@@
fakt_009@7@exec('no_limit','sql')@
fakt_009@7@@
fakt_009@7@@
fakt_009@7@exec('kh','sql')@
fakt_009@7@exec('f3_only','sql')@
fakt_009@8@Handlowiec@S@50@
fakt_009@8@@
fakt_009@8@exec('no_limit','sql')@
fakt_009@8@@
fakt_009@8@@
fakt_009@8@exec('han','sql')@
fakt_009@8@exec('f3_only','sql')@
fakt_009@9@Grupa towar./usług.@S@50@
fakt_009@9@@
fakt_009@9@exec('no_limit','sql')@
fakt_009@9@@
fakt_009@9@@
fakt_009@9@exec('mgr','sql')@
fakt_009@9@exec('f3_only','sql')@
fakt_009@10@Towar/Usługa@S@50@
fakt_009@10@@
fakt_009@10@exec('no_limit','sql')@
fakt_009@10@@
fakt_009@10@@
fakt_009@10@exec('tow','sql')@
fakt_009@10@exec('f3_only','sql')@
fakt_010@1@Od daty wystawienia@D@0@
fakt_010@1@@
fakt_010@1@date(ST.AR,ST.AM,1)@
fakt_010@1@@
fakt_010@1@@
fakt_010@1@@
fakt_010@1@@
fakt_010@2@Do daty wystawienia@D@0@
fakt_010@2@@
fakt_010@2@date(ST.AR,ST.AM,0)@
fakt_010@2@@
fakt_010@2@@
fakt_010@2@@
fakt_010@2@@
fakt_010@3@Od daty otrzy. zal.@D@0@
fakt_010@3@@
fakt_010@3@date(ST.AR,ST.AM,1)@
fakt_010@3@@
fakt_010@3@@
fakt_010@3@@
fakt_010@3@@
fakt_010@4@Do daty otrzy. zal.@D@0@
fakt_010@4@@
fakt_010@4@date(ST.AR,ST.AM,0)@
fakt_010@4@@
fakt_010@4@@
fakt_010@4@@
fakt_010@4@@
fakt_010@5@Od terminu płatności@D@0@
fakt_010@5@@
fakt_010@5@date(ST.AR,ST.AM,1)@
fakt_010@5@@
fakt_010@5@@
fakt_010@5@@
fakt_010@5@@
fakt_010@6@Do terminu płatności@D@0@
fakt_010@6@@
fakt_010@6@date(ST.AR,ST.AM,0)@
fakt_010@6@@
fakt_010@6@@
fakt_010@6@@
fakt_010@6@@
fakt_010@7@Kontrahent@S@50@
fakt_010@7@@
fakt_010@7@exec('no_limit','sql')@
fakt_010@7@@
fakt_010@7@@
fakt_010@7@exec('kh','sql')@
fakt_010@7@exec('f3_only','sql')@
fakt_010@8@Uprawnione STS@F@0@
fakt_010@8@@
fakt_010@8@exec('stss','users',OPERATOR.USER,'STS')@
fakt_010@8@@
fakt_010@8@@
fakt_010@8@@
fakt_010@8@@
fakt_011@1@Oddział@F@0@
fakt_011@1@@
fakt_011@1@ST.ODDZ@
fakt_011@1@@
fakt_011@1@@
fakt_011@1@@
fakt_011@1@@
fakt_011@2@Od daty wystawienia@D@0@
fakt_011@2@@
fakt_011@2@date(ST.AR,ST.AM,1)@
fakt_011@2@@
fakt_011@2@@
fakt_011@2@@
fakt_011@2@@
fakt_011@3@Do daty wystawienia@D@0@
fakt_011@3@@
fakt_011@3@date(ST.AR,ST.AM,0)@
fakt_011@3@@
fakt_011@3@@
fakt_011@3@@
fakt_011@3@@
fakt_011@4@Uprawnione STS@F@0@
fakt_011@4@@
fakt_011@4@exec('stss','users',OPERATOR.USER,'STS')@
fakt_011@4@@
fakt_011@4@@
fakt_011@4@@
fakt_011@4@@
fakt_012@1@Oddział@F@0@
fakt_012@1@@
fakt_012@1@ST.ODDZ@
fakt_012@1@@
fakt_012@1@@
fakt_012@1@@
fakt_012@1@@
fakt_012@2@Od daty wystawienia@D@0@
fakt_012@2@@
fakt_012@2@@
fakt_012@2@@
fakt_012@2@@
fakt_012@2@@
fakt_012@2@@
fakt_012@3@Do daty wystawienia@D@0@
fakt_012@3@@
fakt_012@3@@
fakt_012@3@@
fakt_012@3@@
fakt_012@3@@
fakt_012@3@@
fakt_012@4@Uprawnione STS@F@0@
fakt_012@4@@
fakt_012@4@exec('stss','users',OPERATOR.USER,'STS')@
fakt_012@4@@
fakt_012@4@@
fakt_012@4@@
fakt_012@4@@
fakt_013@1@Oddział@F@0@
fakt_013@1@@
fakt_013@1@ST.ODDZ@
fakt_013@1@@
fakt_013@1@@
fakt_013@1@@
fakt_013@1@@
fakt_013@2@Od daty wystawienia@D@0@
fakt_013@2@@
fakt_013@2@date(ST.AR,ST.AM,1)@
fakt_013@2@@
fakt_013@2@@
fakt_013@2@@
fakt_013@2@@
fakt_013@3@Do daty wystawienia@D@0@
fakt_013@3@@
fakt_013@3@date(ST.AR,ST.AM,0)@
fakt_013@3@@
fakt_013@3@@
fakt_013@3@@
fakt_013@3@@
fakt_013@4@Uprawnione STS@F@0@
fakt_013@4@@
fakt_013@4@exec('stss','users',OPERATOR.USER,'STS')@
fakt_013@4@@
fakt_013@4@@
fakt_013@4@@
fakt_013@4@@
fakt_014@1@Od daty wystawienia@D@0@
fakt_014@1@@
fakt_014@1@@
fakt_014@1@@
fakt_014@1@@
fakt_014@1@@
fakt_014@1@od_daty:=fld(); 1@
fakt_014@2@Do daty wystawienia@D@0@
fakt_014@2@@
fakt_014@2@@
fakt_014@2@@
fakt_014@2@@
fakt_014@2@@
fakt_014@2@do_daty:=fld(); 1@
fakt_014@3@tabelka@F@0@
fakt_014@3@@
fakt_014@3@exec('fakt_014','sql',od_daty,do_daty)@
fakt_014@3@@
fakt_014@3@@
fakt_014@3@@
fakt_014@3@@
fakt_015@1@Oddział@F@0@
fakt_015@1@@
fakt_015@1@ST.ODDZ@
fakt_015@1@@
fakt_015@1@@
fakt_015@1@@
fakt_015@1@@
fakt_015@2@Od daty wystawienia@D@0@
fakt_015@2@@
fakt_015@2@@
fakt_015@2@@
fakt_015@2@@
fakt_015@2@@
fakt_015@2@@
fakt_015@3@Do daty wystawienia@D@0@
fakt_015@3@@
fakt_015@3@@
fakt_015@3@@
fakt_015@3@@
fakt_015@3@@
fakt_015@3@@
fakt_015@4@Dla Indeksu@S@50@
fakt_015@4@@
fakt_015@4@exec('no_limit','sql')@
fakt_015@4@@
fakt_015@4@@
fakt_015@4@exec('tow','sql')@
fakt_015@4@exec('f3_only','sql')@
fakt_015@5@Towar/Usługa@S@1@
fakt_015@5@@
fakt_015@5@@
fakt_015@5@@
fakt_015@5@@
fakt_015@5@@
fakt_015@5@@
fakt_015@6@Uprawnione STS@F@0@
fakt_015@6@@
fakt_015@6@exec('stss','users',OPERATOR.USER,'STS')@
fakt_015@6@@
fakt_015@6@@
fakt_015@6@@
fakt_015@6@@
fakt_016@1@Oddział@F@0@
fakt_016@1@@
fakt_016@1@ST.ODDZ@
fakt_016@1@@
fakt_016@1@@
fakt_016@1@@
fakt_016@1@@
fakt_016@2@Od daty wystawienia@D@0@
fakt_016@2@@
fakt_016@2@@
fakt_016@2@@
fakt_016@2@@
fakt_016@2@@
fakt_016@2@@
fakt_016@3@Do daty wystawienia@D@0@
fakt_016@3@@
fakt_016@3@@
fakt_016@3@@
fakt_016@3@@
fakt_016@3@@
fakt_016@3@@
fakt_016@4@Uprawnione STS@F@0@
fakt_016@4@@
fakt_016@4@exec('stss','users',OPERATOR.USER,'STS')@
fakt_016@4@@
fakt_016@4@@
fakt_016@4@@
fakt_016@4@@
fakt_017@1@Oddział@F@0@
fakt_017@1@@
fakt_017@1@ST.ODDZ@
fakt_017@1@@
fakt_017@1@@
fakt_017@1@@
fakt_017@1@@
fakt_017@2@Od daty wystawienia@D@0@
fakt_017@2@@
fakt_017@2@date(ST.AR,ST.AM,1)@
fakt_017@2@@
fakt_017@2@@
fakt_017@2@@
fakt_017@2@@
fakt_017@3@Do daty wystawienia@D@0@
fakt_017@3@@
fakt_017@3@date(ST.AR,ST.AM,0)@
fakt_017@3@@
fakt_017@3@@
fakt_017@3@@
fakt_017@3@@
fakt_017@4@Uprawnione STS@F@0@
fakt_017@4@@
fakt_017@4@exec('stss','users',OPERATOR.USER,'STS')@
fakt_017@4@@
fakt_017@4@@
fakt_017@4@@
fakt_017@4@@
fakt_018@1@Od daty wystawienia@D@0@
fakt_018@1@@
fakt_018@1@@
fakt_018@1@@
fakt_018@1@@
fakt_018@1@@
fakt_018@1@@
fakt_018@2@Do daty wystawienia@D@0@
fakt_018@2@@
fakt_018@2@@
fakt_018@2@@
fakt_018@2@@
fakt_018@2@@
fakt_018@2@@
fakt_018@3@Procedura@S@20@
fakt_018@3@@
fakt_018@3@exec('no_limit','sql')@
fakt_018@3@@
fakt_018@3@@
fakt_018@3@exec('jpk_slo','sql')@
fakt_018@3@exec('f3_only','sql')@
fakt_019@1@Oddział@F@0@
fakt_019@1@@
fakt_019@1@ST.ODDZ@
fakt_019@1@@
fakt_019@1@@
fakt_019@1@@
fakt_019@1@@
fakt_019@2@Od daty wystawienia@D@0@
fakt_019@2@@
fakt_019@2@date(ST.AR,ST.AM,1)@
fakt_019@2@@
fakt_019@2@@
fakt_019@2@@
fakt_019@2@@
fakt_019@3@Do daty wystawienia@D@0@
fakt_019@3@@
fakt_019@3@date(ST.AR,ST.AM,0)@
fakt_019@3@@
fakt_019@3@@
fakt_019@3@@
fakt_019@3@@
fakt_019@4@SQL@F@0@
fakt_019@4@@
fakt_019@4@exec('pob_dane','oplaty_zest',ST.ODDZ,'S',PAR_SQL.PAR2D,PAR_SQL.PAR3D)@
fakt_019@4@@
fakt_019@4@@
fakt_019@4@@
fakt_019@4@@
ofe_001@1@Od dnia@D@0@
ofe_001@1@@
ofe_001@1@date(ST.AR,ST.AM,1)@
ofe_001@1@@
ofe_001@1@@
ofe_001@1@@
ofe_001@1@@
ofe_001@2@Do dnia@D@0@
ofe_001@2@@
ofe_001@2@date(ST.AR,ST.AM,0)@
ofe_001@2@@
ofe_001@2@@
ofe_001@2@@
ofe_001@2@@
ofe_001@3@Status@S@15@
ofe_001@3@@
ofe_001@3@'Wszystkie'@
ofe_001@3@@
ofe_001@3@@
ofe_001@3@exec('win_f3','sql','Aktywne','Zarchiwizowane','Wszystkie')@
ofe_001@3@exec('valid_po','sql','','Aktywne','Zarchiwizowane','Wszystkie')@
ofe_002@1@Od dnia@D@0@
ofe_002@1@@
ofe_002@1@date(ST.AR,ST.AM,1)@
ofe_002@1@@
ofe_002@1@@
ofe_002@1@@
ofe_002@1@@
ofe_002@2@Do dnia@D@0@
ofe_002@2@@
ofe_002@2@date(ST.AR,ST.AM,0)@
ofe_002@2@@
ofe_002@2@@
ofe_002@2@@
ofe_002@2@@
ofe_002@3@Status@S@15@
ofe_002@3@@
ofe_002@3@'Wszystkie'@
ofe_002@3@@
ofe_002@3@@
ofe_002@3@exec('win_f3','sql','Aktywne','Zarchiwizowane','Wszystkie')@
ofe_002@3@exec('valid_po','sql','','Aktywne','Zarchiwizowane','Wszystkie')@
ofe_002@4@Zamówienie zrealizowane@S@15@
ofe_002@4@@
ofe_002@4@'Wszystkie'@
ofe_002@4@@
ofe_002@4@@
ofe_002@4@exec('win_f3','sql','Całkowicie','C&zęściowo','Wszystkie')@
ofe_002@4@exec('valid_po','sql','','Całkowicie','Częściowo','Wszystkie')@
zam_001@1@Od dnia@D@0@
zam_001@1@@
zam_001@1@date(ST.AR,ST.AM,1)@
zam_001@1@@
zam_001@1@@
zam_001@1@@
zam_001@1@@
zam_001@2@Do dnia@D@0@
zam_001@2@@
zam_001@2@date(ST.AR,ST.AM,0)@
zam_001@2@@
zam_001@2@@
zam_001@2@@
zam_001@2@@
zam_004@1@Od daty zamówienia@D@0@
zam_004@1@@
zam_004@1@date(ST.AR,ST.AM,1)@
zam_004@1@@
zam_004@1@@
zam_004@1@@
zam_004@1@@
zam_004@2@Do daty zamówienia@D@0@
zam_004@2@@
zam_004@2@date(ST.AR,ST.AM,0)@
zam_004@2@@
zam_004@2@@
zam_004@2@@
zam_004@2@@
zam_004@3@Oddział@S@50@
zam_004@3@@
zam_004@3@exec('no_limit','sql')@
zam_004@3@@
zam_004@3@@
zam_004@3@exec('oddz','sql','ZK_N.ODDZ')@
zam_004@3@exec('f3_only','sql')@
zam_004@4@Typ zamówienia@S@50@
zam_004@4@@
zam_004@4@exec('no_limit','sql')@
zam_004@4@@
zam_004@4@@
zam_004@4@exec('typyzam','sql','Z')@
zam_004@4@exec('f3_only','sql')@
zam_004@5@Grupa kontrahentów@S@50@
zam_004@5@@
zam_004@5@exec('no_limit','sql')@
zam_004@5@@
zam_004@5@@
zam_004@5@exec('grkh','sql')@
zam_004@5@exec('f3_only','sql')@
zam_004@6@Kontrahent@S@50@
zam_004@6@@
zam_004@6@exec('no_limit','sql')@
zam_004@6@@
zam_004@6@@
zam_004@6@exec('kh','sql')@
zam_004@6@exec('f3_only','sql')@
zam_004@7@Handlowiec@S@50@
zam_004@7@@
zam_004@7@exec('no_limit','sql')@
zam_004@7@@
zam_004@7@@
zam_004@7@exec('han','sql')@
zam_004@7@exec('f3_only','sql')@
zam_004@8@Grupa towar./usług.@S@50@
zam_004@8@@
zam_004@8@exec('no_limit','sql')@
zam_004@8@@
zam_004@8@@
zam_004@8@exec('mgr','sql')@
zam_004@8@exec('f3_only','sql')@
zam_004@9@Towar/Usługa@S@50@
zam_004@9@@
zam_004@9@exec('no_limit','sql')@
zam_004@9@@
zam_004@9@@
zam_004@9@exec('tow','sql')@
zam_004@9@exec('f3_only','sql')@
zam_006@1@Od dnia@D@0@
zam_006@1@@
zam_006@1@date(ST.AR,ST.AM,1)@
zam_006@1@@
zam_006@1@@
zam_006@1@@
zam_006@1@@
zam_006@2@Do dnia@D@0@
zam_006@2@@
zam_006@2@date(ST.AR,ST.AM,0)@
zam_006@2@@
zam_006@2@@
zam_006@2@@
zam_006@2@@

--Sign Version 2.0 jowisz:1045 2023/08/23 14:35:05 33f0e346883bc3caa36f4052e9a9f639831031ee68be9c78416115d3df8a11d16a212e624d769a0ecf6d71c91deaba0ced2d29b84f472ab6ba5f4174cf2401b5fad3a754a968e604fae2d0fb854561acc442baf848d25b6ac0c163c1179f7ec844a0e6a5f6b39ac27cb12218ce7239de805298b501fd93ade2cd67fd85460c31
