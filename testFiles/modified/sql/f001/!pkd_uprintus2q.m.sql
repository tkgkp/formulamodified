:!UTF-8


SELECT 
  0 as LP,
  B_ROLE.NAME as "Uprawnienie",
KOD,
DANE,
OSOBA.NAZWISKO,
OSOBA.RODOWE,
OSOBA.PIERWSZE,
OSOBA.DRUGIE,
OSOBA.IMEX,
AKT,
PORTAL,
LDAP,
WEBLOGIN,
EMAIL

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
  Uprawnienie,NAZWISKO,PIERWSZE
