:!UTF-8
00001@1@Stan zlecenia@S@1@
00001@1@'u#'@
00001@1@'*'@
00001@1@@
00001@1@@
00001@1@exec('zlstan_f3','sql')@
00001@1@exec('zlstan_po','sql')@
00001@2@Powołane od@D@0@
00001@2@@
00001@2@date(0,0,0)@
00001@2@@
00001@2@@
00001@2@@
00001@2@@
00001@3@Powołane do@D@0@
00001@3@@
00001@3@date()@
00001@3@@
00001@3@@
00001@3@@
00001@3@@
00001@4@Warsztatowe/ Produkcyjne@S@1@
00001@4@'u#'@
00001@4@'*'@
00001@4@@
00001@4@@
00001@4@exec('wp_f3','sql')@
00001@4@exec('wp_po','sql')@
00001@5@Proste/ Złożone@S@1@
00001@5@'u#'@
00001@5@'*'@
00001@5@@
00001@5@@
00001@5@exec('pz_f3','sql')@
00001@5@exec('pz_po','sql')@
00001@6@Wydział@S@8@
00001@6@'xxxxxxxx#'@
00001@6@ST.A_WYD().KOD@
00001@6@@
00001@6@@
00001@6@exec('slo_f3','sql',XINFO.SLWYDZIA)@
00001@6@exec('slo_po','sql',XINFO.SLWYDZIA)@
00001@7@Dla kontrahenta@S@8@
00001@7@'xxxxxxxx#'@
00001@7@'*'@
00001@7@@
00001@7@@
00001@7@exec('kh_f3','sql')@
00001@7@exec('kh_po','sql')@
00002@1@Kod grupy@S@20@
00002@1@'xxxxxxxxxxxxxxxxxxxx#'@
00002@1@'*'@
00002@1@@
00002@1@@
00002@1@exec('grupa_f3','sql')@
00002@1@exec('grupa_po','sql')@
00002@2@Wyrób/półfabrykat@S@1@
00002@2@'u#'@
00002@2@'*'@
00002@2@@
00002@2@@
00002@2@exec('wpm_f3','sql',0)@
00002@2@exec('wpm_po','sql',0)@
00002@3@Typ karty@S@3@
00002@3@'xxx#'@
00002@3@'*'@
00002@3@@
00002@3@@
00002@3@exec('tpktl_f3','sql')@
00002@3@exec('tpktl_po','sql')@
00002@4@Kod produktu@S@20@
00002@4@'xxxxxxxxxxxxxxxxxxxx#'@
00002@4@'*'@
00002@4@@
00002@4@@
00002@4@exec('towar_f3','sql')@
00002@4@exec('towar_po','sql')@
00002@5@Archiwalna?@S@1@
00002@5@'u#'@
00002@5@'N'@
00002@5@@
00002@5@@
00002@5@exec('tn_f3','sql','Karty archiwalne?')@
00002@5@exec('tn_po','sql','Karty archiwalne?')@
00003@1@Stan zlecenia@S@1@
00003@1@'u#'@
00003@1@'*'@
00003@1@@
00003@1@@
00003@1@exec('zlstan_f3','sql')@
00003@1@exec('zlstan_po','sql')@
00003@2@Grupa towarowa@S@20@
00003@2@'xxxxxxxxxxxxxxxxxxxx#'@
00003@2@'*'@
00003@2@@
00003@2@@
00003@2@exec('grupa_f3','sql')@
00003@2@exec('grupa_po','sql')@
00004@1@Stan zlecenia@S@1@
00004@1@'u#'@
00004@1@'*'@
00004@1@@
00004@1@@
00004@1@exec('zlstan_f3','sql')@
00004@1@exec('zlstan_po','sql')@
00004@2@Grupa towarowa@S@20@
00004@2@'xxxxxxxxxxxxxxxxxxxx#'@
00004@2@'*'@
00004@2@@
00004@2@@
00004@2@exec('grupa_f3','sql')@
00004@2@exec('grupa_po','sql')@
00005@1@Stan zlecenia@S@1@
00005@1@'u#'@
00005@1@'*'@
00005@1@@
00005@1@@
00005@1@exec('zlstan_f3','sql')@
00005@1@exec('zlstan_po','sql')@
00005@2@Numer roku@I@0@
00005@2@@
00005@2@ST.AR@
00005@2@@
00005@2@@
00005@2@@
00005@2@@
00005@3@Numer okresu@I@0@
00005@3@@
00005@3@ST.AM@
00005@3@@
00005@3@@
00005@3@exec('okres_f3','sql',PAR_SQL.PAR2I)@
00005@3@exec('okres_po','sql',PAR_SQL.PAR2I)@
00005@4@Analiza/ Kalkulacja@S@1@
00005@4@'u#'@
00005@4@'1'@
00005@4@@
00005@4@@
00005@4@exec('ak_f3','sql')@
00005@4@exec('ak_po','sql')@
00005@5@Numer rubryki@I@0@
00005@5@@
00005@5@16@
00005@5@@
00005@5@@
00005@5@exec('anrub_f3','sql')@
00005@5@exec('anrub_po','sql')@
00005@6@Numer rubryki@I@0@
00005@6@@
00005@6@26@
00005@6@@
00005@6@@
00005@6@exec('anrub_f3','sql')@
00005@6@exec('anrub_po','sql')@
00005@7@Numer rubryki@I@0@
00005@7@@
00005@7@101@
00005@7@@
00005@7@@
00005@7@exec('anrub_f3','sql')@
00005@7@exec('anrub_po','sql')@
00005@8@Numer rubryki@I@0@
00005@8@@
00005@8@102@
00005@8@@
00005@8@@
00005@8@exec('anrub_f3','sql')@
00005@8@exec('anrub_po','sql')@
00006@1@Stan karty@S@1@
00006@1@'u#'@
00006@1@'*'@
00006@1@@
00006@1@@
00006@1@exec('tktlstan_f3','sql')@
00006@1@exec('tktlstan_po','sql')@
00006@2@Archiwalna@S@1@
00006@2@'u#'@
00006@2@'N'@
00006@2@@
00006@2@@
00006@2@exec('tn_f3','sql','Karty archiwalne?')@
00006@2@exec('tn_po','sql','Karty archiwalne?')@
00006@3@Numer rubryki@I@0@
00006@3@@
00006@3@11@
00006@3@@
00006@3@@
00006@3@exec('krub_f3','sql')@
00006@3@exec('krub_po','sql')@
00006@4@Numer rubryki@I@0@
00006@4@@
00006@4@21@
00006@4@@
00006@4@@
00006@4@exec('krub_f3','sql')@
00006@4@exec('krub_po','sql')@
00006@5@Numer rubryki@I@0@
00006@5@@
00006@5@100@
00006@5@@
00006@5@@
00006@5@exec('krub_f3','sql')@
00006@5@exec('krub_po','sql')@
00006@6@Numer rubryki@I@0@
00006@6@@
00006@6@200@
00006@6@@
00006@6@@
00006@6@exec('krub_f3','sql')@
00006@6@exec('krub_po','sql')@
00008@1@Stan zlecenia@S@1@
00008@1@'u#'@
00008@1@'*'@
00008@1@@
00008@1@@
00008@1@exec('zlstan_f3','sql')@
00008@1@exec('zlstan_po','sql')@
00008@2@Numer roku@I@0@
00008@2@@
00008@2@ST.AR@
00008@2@@
00008@2@@
00008@2@@
00008@2@@
00008@3@Numer okresu@I@0@
00008@3@@
00008@3@ST.AM@
00008@3@@
00008@3@@
00008@3@exec('okres_f3','sql',PAR_SQL.PAR2I)@
00008@3@exec('okres_po','sql',PAR_SQL.PAR2I)@
00008@4@Analiza/ Kalkulacja@S@1@
00008@4@'u#'@
00008@4@'1'@
00008@4@@
00008@4@@
00008@4@exec('ak_f3','sql')@
00008@4@exec('ak_po','sql')@
00008@5@Numer rubryki@I@0@
00008@5@@
00008@5@16@
00008@5@@
00008@5@@
00008@5@exec('anrub_f3','sql')@
00008@5@exec('anrub_po','sql')@
00008@6@Numer rubryki@I@0@
00008@6@@
00008@6@26@
00008@6@@
00008@6@@
00008@6@exec('anrub_f3','sql')@
00008@6@exec('anrub_po','sql')@
00008@7@Numer rubryki@I@0@
00008@7@@
00008@7@101@
00008@7@@
00008@7@@
00008@7@exec('anrub_f3','sql')@
00008@7@exec('anrub_po','sql')@
00008@8@Numer rubryki@I@0@
00008@8@@
00008@8@102@
00008@8@@
00008@8@@
00008@8@exec('anrub_f3','sql')@
00008@8@exec('anrub_po','sql')@
00010@1@Wyrób/ półfabrykat@S@1@
00010@1@'u#'@
00010@1@'*'@
00010@1@@
00010@1@@
00010@1@exec('wpm_f3','sql',0)@
00010@1@exec('wpm_po','sql',0)@
00010@2@Stan zlecenia@S@1@
00010@2@'u#'@
00010@2@'*'@
00010@2@@
00010@2@@
00010@2@exec('zlstan_f3','sql')@
00010@2@exec('zlstan_po','sql')@
00010@3@Grupa towarowa@S@20@
00010@3@'xxxxxxxxxxxxxxxxxxxx#'@
00010@3@'*'@
00010@3@@
00010@3@@
00010@3@exec('grupa_f3','sql')@
00010@3@exec('grupa_po','sql')@
00010@4@Produkt@S@20@
00010@4@'xxxxxxxxxxxxxxxxxxxx#'@
00010@4@'*'@
00010@4@@
00010@4@@
00010@4@exec('towar_f3','sql')@
00010@4@exec('towar_po','sql',1)@
00010@5@Technologia@S@20@
00010@5@'xxxxxxxxxxxxxxxxxxxx#'@
00010@5@'*'@
00010@5@@
00010@5@@
00010@5@exec('tktl_f3','sql',PAR_SQL.PAR4S)@
00010@5@exec('tktl_po','sql',PAR_SQL.PAR4S)@
00010@6@Wersja@S@6@
00010@6@'xxxxxx#'@
00010@6@'*'@
00010@6@@
00010@6@@
00010@6@exec('tktlwer_f3','sql',PAR_SQL.PAR4S,PAR_SQL.PAR5S)@
00010@6@exec('tktlwer_po','sql',PAR_SQL.PAR4S,PAR_SQL.PAR5S)@
00015@1@Numer roku@I@0@
00015@1@@
00015@1@ST.AR@
00015@1@@
00015@1@@
00015@1@@
00015@1@@
00015@2@Numer okresu@I@0@
00015@2@@
00015@2@ST.AM@
00015@2@@
00015@2@@
00015@2@exec('okres_f3','sql',PAR_SQL.PAR1I)@
00015@2@exec('okres_po','sql',PAR_SQL.PAR1I)@
00015@3@Symbol zlecenia@S@20@
00015@3@'xxxxxxxx#'@
00015@3@'*'@
00015@3@@
00015@3@@
00015@3@exec('zlec_f3','sql')@
00015@3@exec('zlec_po','sql')@
00015@4@Nazwisko pracownika@S@20@
00015@4@'xxxxxxxx#'@
00015@4@'*'@
00015@4@@
00015@4@@
00015@4@exec('prac_f3','sql')@
00015@4@exec('prac_po','sql')@
00018@1@Kod produktu@S@20@
00018@1@'xxxxxxxxxxxxxxxxxxxx#'@
00018@1@'*'@
00018@1@@
00018@1@@
00018@1@exec('towar_f3','sql')@
00018@1@exec('towar_po','sql')@
00018@2@Stan karty@S@1@
00018@2@'u#'@
00018@2@'*'@
00018@2@@
00018@2@@
00018@2@exec('tktlstan_f3','sql')@
00018@2@exec('tktlstan_po','sql')@
00018@3@Numer rubryki@I@0@
00018@3@@
00018@3@11@
00018@3@@
00018@3@@
00018@3@exec('krub_f3','sql')@
00018@3@exec('krub_po','sql')@
00018@4@Numer rubryki@I@0@
00018@4@@
00018@4@21@
00018@4@@
00018@4@@
00018@4@exec('krub_f3','sql')@
00018@4@exec('krub_po','sql')@
00018@5@Numer rubryki@I@0@
00018@5@@
00018@5@100@
00018@5@@
00018@5@@
00018@5@exec('krub_f3','sql')@
00018@5@exec('krub_po','sql')@
00018@6@Numer rubryki@I@0@
00018@6@@
00018@6@200@
00018@6@@
00018@6@@
00018@6@exec('krub_f3','sql')@
00018@6@exec('krub_po','sql')@
00018@7@Nazwa rubryki@F@0@
00018@7@@
00018@7@exec('krub_name','sql',PAR_SQL.PAR3I)@
00018@7@@
00018@7@@
00018@7@@
00018@7@@
00018@8@Nazwa rubryki@F@0@
00018@8@@
00018@8@exec('krub_name','sql',PAR_SQL.PAR4I)@
00018@8@@
00018@8@@
00018@8@@
00018@8@@
00018@9@Nazwa rubryki@F@0@
00018@9@@
00018@9@exec('krub_name','sql',PAR_SQL.PAR5I)@
00018@9@@
00018@9@@
00018@9@@
00018@9@@
00018@10@Nazwa rubryki@F@0@
00018@10@@
00018@10@exec('krub_name','sql',PAR_SQL.PAR6I)@
00018@10@@
00018@10@@
00018@10@@
00018@10@@
