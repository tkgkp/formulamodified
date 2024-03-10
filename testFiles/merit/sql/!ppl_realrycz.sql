:!UTF-8
/*
   Wypłaty umów "zryczałtowanych"
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Rok do analizy danych
*/
select
   0 as "LP",
   ZC.RC as "Umowa ryczałtowa",
   RH.R as "Rok",
   RH.M as "Miesiąc",
   sum(LS.KW) "Brutto"
from
   R join
   @LS using (R.REFERENCE,LS.RB) join
   RH using (LS.RH,RH.REFERENCE) join
   ZC using (RH.ZLE,ZC.REFERENCE) join
   P using (ZC.P,P.REFERENCE)
where
   LS.REFERENCE like ('l'||SUBSTR(to_string(:_b),3,2)||'__zl%') and
   (P.REFERENCE in (select :_a.REF from :_a)) and
   R.RN=500 and
   RH in (select LS.RH from @LS join R where LS.REFERENCE like ('l'||SUBSTR(to_string(:_b),3,2)||'__zl%') and R.RN=31)
group by
   ZC.RC,
   RH.R,
   RH.M

