Insert into CERTIFICATIONS (IDCERTI,NOMCERTI) values ('81','PG');

Insert into POSTERS (IDPOSTER,PATHIMAGE) values ('162','/6u1fYtxG5eqjhtCPDx04pJphQRW.jpg');

Insert into FILMS (IDFILM,TITRE,TITRE_ORIGINAL,STATUS,TAGLINE,DATE_REAL,VOTE_AVERAGE,VOTE_COUNT,CERTIFICATION,DUREE,BUDGET,POSTER) values ('1891','Star Wars: Episode V - The Empire Stri(...)','Star Wars: Episode V - The Empire Stri(...)','Released','The Adventure Continues...',to_date('21/05/80','DD/MM/RR'),'7,6','1833','81','124','18000000','162');

Insert into ARTISTS (IDART,NOMART) values ('2','Mark Hamill');
Insert into ARTISTS (IDART,NOMART) values ('3','Harrison Ford');
Insert into ARTISTS (IDART,NOMART) values ('4','Carrie Fisher');
Insert into ARTISTS (IDART,NOMART) values ('12248','Alec Guinness');
Insert into ARTISTS (IDART,NOMART) values ('6','Anthony Daniels');
Insert into ARTISTS (IDART,NOMART) values ('130','Kenny Baker');
Insert into ARTISTS (IDART,NOMART) values ('24343','Peter Mayhew');
Insert into ARTISTS (IDART,NOMART) values ('24342','David Prowse');
Insert into ARTISTS (IDART,NOMART) values ('132538','Jack Purvis');
Insert into ARTISTS (IDART,NOMART) values ('15152','James Earl Jones');
Insert into ARTISTS (IDART,NOMART) values ('10930','Irvin Kershner');
Insert into ARTISTS (IDART,NOMART) values ('3799','Billy Dee Williams');
Insert into ARTISTS (IDART,NOMART) values ('7908','Frank Oz');
Insert into ARTISTS (IDART,NOMART) values ('33185','Jeremy Bulloch');
Insert into ARTISTS (IDART,NOMART) values ('27165','John Hollis');
Insert into ARTISTS (IDART,NOMART) values ('132539','Des Webb');
Insert into ARTISTS (IDART,NOMART) values ('20128','Clive Revill');
Insert into ARTISTS (IDART,NOMART) values ('740','Julian Glover');
Insert into ARTISTS (IDART,NOMART) values ('10734','Kenneth Colley');
Insert into ARTISTS (IDART,NOMART) values ('7907','John Ratzenberger');

Insert into REALISER (FILM,ARTIST) values ('1891','10930');

Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','2','Luke Skywalker');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','3','Han Solo');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','4','Princess Leia');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','24342','Darth Vader');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','3799','Lando Calrissian');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','6','C-3PO');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','24343','Chewbacca');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','15152','Darth Vader (Voice)');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','130','R2-D2');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','7908','Yoda (Voice)');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','12248','Ben ''Obi-wan'' Kenobi');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','33185','Boba Fett');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','27165','Lando''s aide');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','132538','Chief Ugnaught');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','132539','Snow Creature');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','20128','Emperor (voice)');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','740','Imperial Force Gene(...)');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','10734','Imperial Force Admi(...)');
Insert into JOUER (FILM,ARTIST,ROLE) values ('1891','7907','Rebel Force Major Derlin');

Insert into GENRES (IDGENRE,NOMGENRE) values ('28','Action');
Insert into GENRES (IDGENRE,NOMGENRE) values ('12','Adventure');
Insert into GENRES (IDGENRE,NOMGENRE) values ('878','Science Fiction');

Insert into FILM_GENRE (GENRE,FILM) values ('12','1891');
Insert into FILM_GENRE (GENRE,FILM) values ('28','1891');
Insert into FILM_GENRE (GENRE,FILM) values ('878','1891');

Insert into FILMS_COPIES (ID,MOVIE) values ('852','1891');
Insert into FILMS_COPIES (ID,MOVIE) values ('853','1891');

INSERT INTO programmations VALUES(28,5,'12/11/2017','12/12/2017',1891,852,1,'14:00');
INSERT INTO programmations VALUES(29,5,'08/08/2017','08/09/2017',1891,853,2,'17:00');
commit;
