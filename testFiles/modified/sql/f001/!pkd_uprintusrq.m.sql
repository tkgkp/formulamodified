:!UTF-8
/*
   NUCO - Uprawnienia internetowe użytkowników (dawne, w XP, role użytkowników wg I_USERS, I_ROLE i I_USROLE)

   wariant bez użycia tabeli OSOBA
   w XP było: OSOBA.NAZWISKO, OSOBA.PIERWSZE; left join OSOBA using (USERS.OSOBA,OSOBA.REFERENCE)

   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data badania
*/

/*
wariant dla nowego portalu
select
  0 as LP,
  LOGIN as "Użytkownik",
  OPR_NAME as "Uprawnienie",
  ENABLED as "Włączone?"
from
  PORTALU
order by
   2,3
*/


SELECT 
  0 as LP,
  B_ROLE.NAME as "Uprawnienie",
  CASE
    WHEN USERS.OSOBA IS NOT  NULL THEN
      OSOBA.NAZWISKO || ' '||  OSOBA.PIERWSZE 
    ELSE 
     USERS.DANE 
  END as "Użytkownik"
FROM 
  B_USRROL LEFT JOIN
  USERS LEFT JOIN 	  
  B_ROLE LEFT JOIN OSOBA
WHERE
 B_ROLE.NAME IN (SELECT DISTINCT
                              B_ROLE.NAME
                           FROM 
                              B_ACTROL LEFT JOIN	  
                              B_ROLE  LEFT JOIN 
                              B_ACTION  LEFT JOIN
                              B_DOMAIN
                          WHERE
                              B_DOMAIN.NAME='Pracownik')
ORDER BY
  Uprawnienie,Użytkownik
