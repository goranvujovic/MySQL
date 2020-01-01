-- II grupa 01.12.2015

-- 1. prikazati imena,prezimena, plate, naziv projekta i 
-- broj radnih sati za svakog radnika na svakom projektu na kojem radi
-- podatke sortirati po nazivima projekata u opadajucem redosljedu 

select r.ime, r.prz, r.plt, p.nap, rp.brc
from radnik r, projekat p, radproj rp
where rp.MBR = r.MBR and rp.SPR = p.SPR
order by p.nap desc;

-- 2. prikazati nazive projekata i ukupan broj radnih sati na njima

select p.nap, sum(rp.brc)
from  projekat p, radproj rp
where  rp.SPR = p.SPR
group by p.nap;

-- 3. prikazati ime, prezime, platu radnika i njegovo ukupno angazovanje i broj projekata na kojima radi

select r.ime,r.prz,r.plt, sum(rp.brc), count(rp.spr)
from radnik r, radproj rp
where rp.MBR = r.MBR
group by r.ime,r.prz,r.plt;

-- 4. Za svaki projekat izlistati njegov naziv i ime rukovodioca kao i broj ljudi koji radi na tom projektu


select p.nap, r.ime, r. prz, count (rp.mbr)
from radnik r, projekat p, radproj rp
where p.ruk = r.MBR and rp.SPR = p.SPR 
group by p.nap, r.ime, r. prz
order by p.nap;  

/*
select p.nap, r.ime, r. prz, rp.mbr
from radnik r, projekat p, radproj rp
where p.ruk = r.MBR and rp.SPR = p.SPR 
order by p.nap;  
*/

-- 5. prikazati ime prezime radnika i ime i prezime njegovog sefa kao i broj projekata na kojima radnik radi

select r1.ime "Ime radnika", r1.prz "Prezime radnika", r2. ime "Ime sefa", r2.prz "Prezime sefa", count(rp.spr) "Broj projekata"
from radnik r1, radnik r2, radproj rp
where r1.sef = r2.mbr and rp.mbr = r1.mbr
group by r1.ime, r1.prz, r2.ime, r2.prz;

-- 6. prikazati sifre projekata i ukupan broj radnika koji radi na njima 
-- ali samo za one projekte na kojima radi vise od 3 radnika

select spr, count (mbr)
from radproj 
group by spr
having  count (mbr) >3;

-- 7. Prikazati imena i prezimena onih radnika koji rade na vise od 2 projekta 

select r.ime, r.prz 
from radnik r, radproj rp
where r.mbr = rp.mbr 
group by r.ime,r.prz
having count(rp.spr) > 2;

-- 8. prikazati imena i prezimena svih radnika koji rukovode sa najmanje dva projekta. 
-- podatke sortirati u opadajucem redosljedu po prezimenu

select r.ime, r.prz 
from radnik r, projekat p
where p.ruk = r.mbr 
group by r.ime, r.prz 
having count(p.spr) >=2
order by r.prz desc;

-- 9. prikazati naziv projekta ime i prezime rukovodioca toga projekta i ukupni budzet projekta 
-- (tj ukupnu platu svih radnika koji rade na njemu) u recenicama oblika 
-- "Projektom NAZIV rukovodi IME PREZIME a ukupan budzet na njemu je BUDZET"
-- podatke prikazati samo za one projekte na kojima radi vise od dva radnika
-- i podatke sortirati po nazivu projekta

-- select p.nap, r1.ime, r1.prz, sum (r2.plt)
select 'Projektom ' || p.nap || ' rukovodi ' || r1.ime || ' ' || r1.prz || ' a ukupan budzet na njemu je ' || sum(r2.plt) 
from projekat p, radnik r1, radnik r2, radproj rp
where p.ruk = r1.mbr and rp.mbr = r2.mbr and rp.spr =p.spr 
group by p.nap, r1.ime, r1.prz
having count(rp.mbr) >2
order by p.nap asc;

-- 10.a. prikazati imena i prezimena radnika, njihove plate i broj radnika kojima su oni sefovi. 

select  r1.ime, r1. prz, r1.plt, count (r2.mbr)
from radnik r1, radnik r2
where r2.sef = r1.mbr
group by r1.ime, r1. prz, r1.plt;

-- 10.b podatke prikazati samo za one radnike koji ujedno i rukovode nekim projektom

select  r1.ime, r1. prz, r1.plt, count (r2.mbr)
from radnik r1, radnik r2, projekat p
where r2.sef = r1.mbr and p.ruk = r1.mbr
group by r1.ime, r1. prz, r1.plt
having count(p.spr) > 0;

-- 10.c  sortirati izlaz po platama u opadajucem redosljedu

select  r1.ime, r1. prz, r1.plt, count (r2.mbr)
from radnik r1, radnik r2, projekat p
where r2.sef = r1.mbr and p.ruk = r1.mbr
group by r1.ime, r1. prz, r1.plt
having count(p.spr) > 0
order by r1.plt desc;

-- 11. uvecati plate svim radnicima koji rade na barem 3 projekta za 10%

update radnik 
set plt = plt * 1.1
where mbr  in ( select mbr 
                          from radproj
                          group by mbr
                          having count(spr) >=3);
