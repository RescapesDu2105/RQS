drop table REALISER;
drop table Film_Genre;
drop table JOUER;
drop table Films_Copies;
drop table Films;
drop table posters;
drop table genres;
drop table Certifications;
drop table Artists;

CREATE TABLE Artists (
    IdArt     NUMBER(7),
    NomArt	  VARCHAR2(24 char),
    CONSTRAINT artist_pk 		PRIMARY KEY (IdArt),
    CONSTRAINT artist_name_ck 	CHECK (NomArt IS NOT NULL)
);

CREATE TABLE Certifications (
    IdCerti      	NUMBER GENERATED ALWAYS AS IDENTITY,
    NomCerti    	VARCHAR2(5), --95 QUantile = 5
    CONSTRAINT certi_pk 			PRIMARY KEY (IdCerti),
	CONSTRAINT cert_NomCerti_ck 	CHECK (NomCerti IN (null,'G', 'PG', 'PG-13', 'R', 'NC-17')),
    CONSTRAINT cert_NomCerti_un 	UNIQUE (NomCerti)
);


CREATE TABLE genres (
    IdGenre   	  NUMBER(5) ,-- MAX=5
    NomGenre 	  VARCHAR2(15),-- 95 quantile=11 et 995 quantile=15
    CONSTRAINT genres_pk 		PRIMARY KEY (IdGenre),
    CONSTRAINT genres_NomGenre_ck 	CHECK (NomGenre IS NOT NULL),
    CONSTRAINT genres_NomGenre_un 	UNIQUE (NomGenre)
);

CREATE TABLE posters (
	IdPoster 	NUMBER 	GENERATED ALWAYS AS IDENTITY,
	--film		NUMBER ,
	PathImage 	VARCHAR2(32),
	Image 		BLOB DEFAULT EMPTY_BLOB(),
	CONSTRAINT posters_pk PRIMARY KEY (IdPoster)
);

-- Voir les valeurs d'analyse CI
CREATE TABLE Films (
    IdFilm			NUMBER(6),
    Titre			VARCHAR2(43 char) NOT NULL,
	Titre_Original  VARCHAR2(43 char),
    status        	VARCHAR2 (15 CHAR), 
    tagline  	  	VARCHAR2(107 char),
    Date_Real  		DATE,
    Vote_Average  	NUMBER(2,1),
    vote_count    	NUMBER(4) NOT NULL,
    certification 	NUMBER,
    Duree       	NUMBER(6),
    Budget        	NUMBER(10,2) NOT NULL,
    poster        	NUMBER,
    CONSTRAINT films_pk 					PRIMARY KEY (IdFilm),
	CONSTRAINT films_vote_count_minVal_ck 	CHECK (vote_count IS NULL OR vote_count >= 0),
	CONSTRAINT films_certification_fk 		FOREIGN KEY (certification) REFERENCES certifications(IdCerti),
	CONSTRAINT films_Duree_minVal_ck 		CHECK (Duree IS NULL OR Duree >= 0),
	CONSTRAINT films_Budget_minVal_ck 		CHECK (Budget IS NULL OR Budget >= 0),
	CONSTRAINT films_poster_fk  			FOREIGN KEY (poster) REFERENCES posters(IdPoster)
);



CREATE TABLE REALISER (
    Film    NUMBER(6) CONSTRAINT REALISER_Film_fk REFERENCES Films (IdFilm),
    Artist  NUMBER(7) CONSTRAINT REALISER_Artist_fk REFERENCES Artists (IdArt),
    CONSTRAINT movie_director_pk 	PRIMARY KEY (Film, Artist)
);

CREATE TABLE Film_Genre (
    genre 	NUMBER(5) CONSTRAINT Film_Genre_genre_fk REFERENCES genres (IdGenre),
    Film 	NUMBER(6) CONSTRAINT Film_Genre_Film_fk REFERENCES Films (IdFilm),
    CONSTRAINT Films_Genre_pk 	PRIMARY KEY (genre, Film)
);
CREATE TABLE JOUER (
    Film  		NUMBER(6) CONSTRAINT JOUER_movie_fk REFERENCES Films (IdFilm),
    Artist 		NUMBER(7) CONSTRAINT JOUER_artist_fk REFERENCES Artists (IdArt),
	Role		VARCHAR2(24 char),
    CONSTRAINT films_actor_pk 	PRIMARY KEY (Film, Artist)
);

CREATE TABLE Films_Copies (
	id      	NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	movie  		NUMBER(6) CONSTRAINT copy_movie_fk REFERENCES films (IdFilm),
	nbCopie		NUMBER(2) CONSTRAINT nbCopie_Ck	CHECK(nbCopie>=0),
	CONSTRAINT Films_Copies_pk 	PRIMARY KEY (id)
);