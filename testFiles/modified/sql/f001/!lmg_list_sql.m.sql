:!UTF-8
Magazyny@1 - (13.) Zestawienie dokumentów wg KTM - zużycie MAT@qmag_130@@@@N@@N@
Magazyny@1 - (13a.) Zestawienie dokumentów wg KTM - zużycie MAT (wartosciowo)@qmag_131@@@@N@@N@
Magazyny@1 - (13b.) Zestawienie dokumentów wg KTM - zużycie SUR, SUR2, MMO, MSU@qmag_132@@@@N@@N@
Magazyny@1 - (13c.) Zestawienie dokumentów wg KTM - zużycie SUR (wartosciowo)@qmag_133@@@@N@@N@
Magazyny@1 - (13d.) Zakupy surowców (przychody zew. do mag. typu SUR)@qmag_135@@@@N@@N@
Magazyny@1 - (13z.) Zużycie w okresie@qmag_134@@@@N@@N@
Magazyny@10 - (29.) Wysyłki do INTRASTAT (po dokumentach WZ, NIP)@qwysylki2@sql_mag:='WYR';sql_dat:=ST.AR;1@&sql_mag;&sql_dat;1@@N@@N@
Magazyny@2 - (14.)  Zestawienie dokumentów wg KTM - zużycie MAP (z PZ)@qmag_140@@@@N@@N@
Magazyny@3 - (12a.) Zestawienie dokumentów wgedług kodów towarowych-ilosc@qmag_120a@@@@N@@N@
Magazyny@3 - (12b.) Zestawienie dokumentów wgedług kodów towarowych-wart@qmag_120b@@@@N@@N@
Magazyny@3 - (17.) Zestawienie dokumentów wgedług kodów towarowych-konto@qmag_170@@@@N@@N@
Magazyny@3 - (17a.) Zestawienie dokumentów wgedług kodów towarowych-konto (bez cen)@qmag_170a@@@@N@@N@
Magazyny@3 - (17b.) Zestawienie dokumentów wgedług kodów towarowych-sumy@qmag_170b@@@@N@@N@
Magazyny@4 - (18.)  Zużycie surowców@qmag_180@@@@N@@N@
Magazyny@4 - (18a.) Zużycie surowców (PZ-RW-RWL-RWZ+ZW+ZWM)@qmag_181@@@@N@@N@
Magazyny@4 - (18b.) Zużycie surowców (RW+RWL+RWZ-ZW-ZWM)@qmag_182@@@@N@@N@
Magazyny@5 - (21.) Zestawienie dokumentów vs. operator@qmag_210@@@@N@@N@
Magazyny@5 - (21a.) Zestawienie dokumentów vs. operator (z paletami)@qmag_211@@@@N@@N@
Magazyny@6 - (23.) Dokumenty nie zaakcptowane@qmag_230@@@@N@@N@
Magazyny@7 - (26.) Towary z przypisanym opakowaniem@qmag_260@@@@N@@N@
Magazyny@8 - (28.) Stany magazynowe według atrybutów dostawy/terminu ważności@qmag_280@@@@N@@N@
Magazyny@9 - (30.) Stany magazynowe wg atrybutów dostawy/term. ważności (rez.,dost.)@qmag_300@@@@N@@N@
Magazyny@Analiza użycia dostaw materiałów (MAT,04) po dacie dostawy@qmag_907a@@@@N@@N@
Magazyny@Analiza użycia dostaw surowców (SUR,07) po dacie dostawy@qmag_907@@@@N@@N@
Magazyny@NUCO - Niewycenione pozycje dokumentów magazynowych@qmag_0002@exec('upr_cm','sql')@@@T@MAGAZYN,TYP,SYMBOL,INDEKS@N@
Magazyny@NUCO - Stany wartościowe wg towarów na podany dzień@qmag_0008@{?exec('upr_cm','sql')||sql_mag:=ST.MAG().SYM;sql_dat:=date();1||0?}@&sql_mag;&sql_dat;1@@N@@N@
Magazyny@Wydane towary niespełniające norm@mag_wydane_tow_poza_norma@@@@N@@N@
Magazyny@Zestawienie dokumentów ALL@qmag_004@@@@N@@N@
Magazyny@Zestawienie dokumentów ALL (bez_cen)@qmag_004a@@@@N@@N@
Magazyny@Zestawienie dokumentów ALL wg stanów@qmag_003@@@@N@@N@
Magazyny@Zestawienie dokumentów dla zlecenia (z grupowaniem)1@mag_0022a@exec('upr_cm','sql')@@@T@@N@
Magazyny@Zestawienie dokumentów dla zlecenia 2@mag_0022b@exec('upr_cm','sql')@@@N@@N@
Magazyny@Zestawienie dokumentów przychodowych (IS)@mag_0012a@exec('upr_cm','sql') & exec('x_null','sql')@@@T@@N@
Magazyny@Zestawienie dokumentów przychodowych z definicją podsum - ilościowe@qmag_001@exec('upr_cm','sql') & exec('x_null','sql')@@@T@@N@
Magazyny@Zestawienie dokumentów rozchodowych (IS)@mag_0013a@exec('upr_cm','sql') & exec('x_null','sql')@@@T@@N@
Magazyny@Zestawienie dokumentów rozchodowych z definicją podsum - ilościowe@qmag_002@exec('upr_cm','sql') & exec('x_null','sql')@@@T@@N@
Stan magazynu@Analiza partii wyrobu@anal_partii@@@@N@@N@
