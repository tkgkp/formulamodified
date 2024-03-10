:!UTF-8

select 0 Lp, p.ip, p.t, nazwisko, pierwsze, d, od, do, r.rn, r.rt, az, nr, ng  from nwu join r using (nwu.r, r.reference) join p using (nwu.p, p.reference) join osoba using (p.osoba, osoba.reference) where nwu.az<>'T' and nwu.az<>'N' and nwu.az<>'W' and nwu.az<>'D'