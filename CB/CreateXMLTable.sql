DROP TABLE archives CASCADE CONSTRAINTS;
DROP TABLE reservations CASCADE CONSTRAINTS;
DROP TABLE seances CASCADE CONSTRAINTS;
DROP TABLE programmations CASCADE CONSTRAINTS;
DROP TABLE salles CASCADE CONSTRAINTS;
DROP TABLE complexes CASCADE CONSTRAINTS;
DROP TABLE clients CASCADE CONSTRAINTS;

CREATE TABLE clients (
    idClient NUMBER GENERATED ALWAYS AS IDENTITY,
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
    nbPlaces NUMBER,
    idComplexe NUMBER,
    CONSTRAINT salle_complexe_ref FOREIGN KEY(idComplexe) 
        REFERENCES complexes(idComplexe),
    CONSTRAINT salles_pk PRIMARY KEY (idSalle,idComplexe));

CREATE TABLE programmations OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/programmation.xsd"
    ELEMENT "programmation" ;
ALTER TABLE programmations ADD CONSTRAINT programmation_pk PRIMARY KEY(XMLDATA."IDDEMANDE");
ALTER TABLE programmations ADD CONSTRAINT programmation_film_copie_copy_fk FOREIGN KEY(XMLDATA."COPY") 
    REFERENCES films_copies(id);  

CREATE TABLE seances (    
    idSeance NUMBER GENERATED ALWAYS AS IDENTITY,
    idProgrammation NUMBER,
    idSalle NUMBER,
    dateSeance DATE,
    nbPlaceVendues NUMBER,
    CONSTRAINT seance_pk PRIMARY KEY (idSeance),
	CONSTRAINT seance_programmation_ref FOREIGN KEY(idProgrammation) 
        REFERENCES programmations(XMLDATA."IDDEMANDE"),
    CONSTRAINT seance_salle_ref FOREIGN KEY(idSalle) 
        REFERENCES SALLES(idSalle));

CREATE TABLE reservations (
    idResevations NUMBER GENERATED ALWAYS AS IDENTITY,
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
ALTER TABLE archives ADD CONSTRAINT archives_film_fk FOREIGN KEY(XMLDATA."IDFILM") 
    REFERENCES films(idFilm);