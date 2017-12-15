drop table REALISER CASCADE CONSTRAINTS;
drop table Film_Genre CASCADE CONSTRAINTS;
drop table JOUER CASCADE CONSTRAINTS;
drop table Artists CASCADE CONSTRAINTS;
drop table genres CASCADE CONSTRAINTS;
drop table Films_Copies CASCADE CONSTRAINTS;
drop table Films CASCADE CONSTRAINTS;
drop table posters CASCADE CONSTRAINTS;
drop table Certifications CASCADE CONSTRAINTS;
DROP TABLE archives CASCADE CONSTRAINTS;
DROP TABLE reservations CASCADE CONSTRAINTS;
DROP TABLE seances CASCADE CONSTRAINTS;
DROP TABLE programmations CASCADE CONSTRAINTS;
DROP TABLE salles CASCADE CONSTRAINTS;
DROP TABLE complexes CASCADE CONSTRAINTS;
DROP TABLE clients CASCADE CONSTRAINTS;

CREATE TABLE Artists (
    IdArt     NUMBER(7),
    NomArt	  VARCHAR2(24 char),
    CONSTRAINT artist_pk 		PRIMARY KEY (IdArt),
    CONSTRAINT artist_name_ck 	CHECK (NomArt IS NOT NULL)
);

CREATE TABLE Certifications (
    IdCerti      	NUMBER,
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
	IdPoster 	NUMBER,
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
    Vote_Average  	NUMBER(3,1),
    vote_count    	NUMBER(4) NOT NULL,
    certification 	NUMBER not null,
    Duree       	NUMBER(6),
    Budget        	NUMBER(12,2) NOT NULL,
    poster        	NUMBER not null,
    nbcopyMax       NUMBER,
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
	id      	NUMBER,
	movie  		NUMBER(6) CONSTRAINT copy_movie_fk REFERENCES films (IdFilm),
	CONSTRAINT Films_Copies_pk 	PRIMARY KEY (id)
);

CREATE TABLE clients (
    idClient NUMBER,
    nom VARCHAR2(35),
    prenom VARCHAR2(35),
    datenaiss DATE,
    CONSTRAINT clients_pk PRIMARY KEY(idClient));

CREATE TABLE complexes (
    idComplexe NUMBER,
    adresse VARCHAR2(250),
    CONSTRAINT complexes_pk PRIMARY KEY(idComplexe));

CREATE TABLE salles (            
    idSalle NUMBER,
    numSalle NUMBER,
    nbPlaces NUMBER,
    idComplexe NUMBER,
    CONSTRAINT salles_pk PRIMARY KEY (idSalle),
    CONSTRAINT salle_complexe_ref FOREIGN KEY(idComplexe) 
        REFERENCES complexes(idComplexe));

CREATE TABLE programmations OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/programmation.xsd"
    ELEMENT "programmation" ;
ALTER TABLE programmations ADD CONSTRAINT programmation_pk PRIMARY KEY(XMLDATA."IDDEMANDE");
ALTER TABLE programmations ADD CONSTRAINT programmation_film_copie_copy_fk FOREIGN KEY(XMLDATA."COPY") 
    REFERENCES films_copies(id);  
    
CREATE TABLE seances (    
    idSeance NUMBER ,
    idProgrammation NUMBER,
    idSalle NUMBER,
    dateSeance DATE,
    nbPlaceVendues NUMBER,
    CONSTRAINT seance_pk PRIMARY KEY (idSeance),
	CONSTRAINT seance_programmation_ref FOREIGN KEY(idProgrammation) 
        REFERENCES programmations(XMLDATA."IDDEMANDE"),
    CONSTRAINT seance_salle_ref FOREIGN KEY(idSalle) 
        REFERENCES salles(idSalle));

CREATE TABLE reservations (
    idResevations NUMBER,
    idSeance NUMBER,
    idClient NUMBER,
    CONSTRAINT reservation_pk PRIMARY KEY (idResevations),
    CONSTRAINT reservation_seance_fk FOREIGN KEY(idSeance) 
        REFERENCES seances(idSeance),
    CONSTRAINT reservation_client_fk FOREIGN KEY(idClient) 
        REFERENCES Clients(idClient));

DROP TABLE ARCHIVES;
CREATE TABLE archives OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/archive.xsd"
    ELEMENT "archive"
    VARRAY "XMLDATA"."COMPLEXES"."COMPLEXEVARRAY_TYPE"
        STORE AS TABLE arcvhives_table
        ((PRIMARY KEY (NESTED_TABLE_ID, SYS_NC_ARRAY_INDEX$)));
ALTER TABLE archives ADD CONSTRAINT archives_pk PRIMARY KEY(XMLDATA."IDARCHIVE");
ALTER TABLE archives ADD CONSTRAINT archives_copy_fk FOREIGN KEY(XMLDATA."IDFILM") 
    REFERENCES films(idfilm);