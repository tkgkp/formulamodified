:!UTF-8
Magazyny@Bilans miesiąca w magazynie@mag_0010@{?exec('upr_cm','sql')||sql_mag:=ST.MAG().SYM;sql_dat:=date();1||0?}@&sql_mag;&sql_dat;1@@N@@T@
Magazyny@Dokumenty z transportem@mag_0011@exec('upr_cm','sql')@@@N@@T@
Magazyny@Materiały przeterminowane@mag_0014@@@@N@@T@
Magazyny@Miesięczne zestawienie saldowo - obrotowe za bieżący miesiąc@mag_0006@{?exec('upr_cm','sql')||sql_mag:=ST.MAG().SYM;sql_dat:=date(ST.AR,ST.AM,1);1||0?}@&sql_mag;&sql_dat;1@@N@@T@
Magazyny@Niewycenione pozycje dokumentów magazynowych@mag_0002@exec('upr_cm','sql')@@@T@MAGAZYN,TYP,SYMBOL,INDEKS@T@
Magazyny@Normy minimalne i maksymalne dla bieżącego magazynu@mag_0016@@@@N@@T@
Magazyny@Opłaty dodatkowe w zakresie dat@mag_0018@@@@T@@T@
Magazyny@Stany wartościowe wg grup na podany dzień@mag_0004@{?exec('upr_cm','sql')||sql_mag:=ST.MAG().SYM;sql_dat:=date();1||0?}@&sql_mag;&sql_dat;1@@N@@T@
Magazyny@Stany wartościowe wg towarów na podany dzień@mag_0008@{?exec('upr_cm','sql')||sql_mag:=ST.MAG().SYM;sql_dat:=date();1||0?}@&sql_mag;&sql_dat;1@@N@@T@
Magazyny@Stany wg lokalizacji@mag_0017@@@@N@@T@
Magazyny@Zestawienie dokumentów dla zlecenia@mag_0001@exec('upr_cm','sql')@@@N@@T@
Magazyny@Zestawienie dokumentów dla zlecenia (z grupowaniem)@mag_0022@exec('upr_cm','sql')@@@T@@T@
Magazyny@Zestawienie dokumentów przychodowych z definicją podsum@mag_0012@exec('upr_cm','sql') & exec('x_null','sql')@@@T@@T@
Magazyny@Zestawienie dokumentów rozchodowych z definicją podsum@mag_0013@exec('upr_cm','sql') & exec('x_null','sql')@@@T@@T@
Opakowania@Analiza czasu zalegania opakowań zwrotnych@opak_003@@@@N@@T@
Opakowania@Bilans opakowań zwrotnych wg kontrahentów@opak_004@@@@N@@T@
Opakowania@Magazyny opakowań@opak_000@@@@N@@T@
Opakowania@Stany opakowań na dzień@opak_002@@VAR_DEL.delete('tabelka'); 1@@N@@T@
Opakowania@Stany opakowań u kontrahentów na dzień@opak_001@exec('filtr_kh','kontrahent','N','N'); 1@VAR_DEL.delete('tabelka'); 1@@N@@T@
Zamówienia@Analiza zamówień wewnętrznych z transportem@zam_006@@@@N@@T@
Zamówienia@Zamówienia materiałów@zew_009@@@@N@@T@
Zamówienia@Zamówienia materiałów (z grupowaniem)@zam_grp@@@@T@@T@
