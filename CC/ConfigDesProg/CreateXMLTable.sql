DROP TABLE archives;
DROP TABLE reservation;
DROP TABLE seances;
DROP TABLE programmations;
DROP TABLE salles;
DROP TABLE complexes;
DROP TABLE clients;

CREATE TABLE clients OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/client.xsd"
    ELEMENT "client" ;
ALTER TABLE clients ADD CONSTRAINT client_pk PRIMARY KEY(XMLDATA."IDCLIENT");

CREATE TABLE complexes OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/complexe.xsd"
    ELEMENT "complexe" ;
ALTER TABLE complexes ADD CONSTRAINT complexe_pk PRIMARY KEY(XMLDATA."IDCOMPLEXE");

CREATE TABLE salles OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/salle.xsd"
    ELEMENT "salle" ;
ALTER TABLE salles ADD CONSTRAINT salle_pk PRIMARY KEY(XMLDATA."IDSALLE");
ALTER TABLE salles ADD CONSTRAINT salle_complexe_ref FOREIGN KEY(XMLDATA."COMPLEXE") 
    REFERENCES complexes(XMLDATA."IDCOMPLEXE");

CREATE TABLE programmations OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/programmation.xsd"
    ELEMENT "programmation" ;
ALTER TABLE programmations ADD CONSTRAINT programmation_pk PRIMARY KEY(XMLDATA."IDDEMANDE");
ALTER TABLE programmations ADD CONSTRAINT programmation_film_copie_copy_fk FOREIGN KEY(XMLDATA."COPY") 
    REFERENCES films_copies(id);
ALTER TABLE programmations ADD CONSTRAINT programmation_film_copie_movie_fk FOREIGN KEY(XMLDATA."MOVIE") 
    REFERENCES films_copies(movie);    

CREATE TABLE seances OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/seance.xsd"
    ELEMENT "seance" ;
ALTER TABLE seances ADD CONSTRAINT seance_pk PRIMARY KEY(XMLDATA."IDSEANCE");
ALTER TABLE seances ADD CONSTRAINT seance_programmation_ref FOREIGN KEY(XMLDATA."IDPROGRAMMATION") 
    REFERENCES programmations(XMLDATA."IDDEMANDE");
ALTER TABLE seances ADD CONSTRAINT seance_reservation_ref FOREIGN KEY(XMLDATA."IDPROGRAMMATION") 
    REFERENCES programmations(XMLDATA."IDDEMANDE");

CREATE TABLE reservations OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/reservation.xsd"
    ELEMENT "reservation" ;
ALTER TABLE reservations ADD CONSTRAINT reservation_pk PRIMARY KEY(XMLDATA."IDRESERVATION");
ALTER TABLE reservations ADD CONSTRAINT reservation_seance_ref FOREIGN KEY(XMLDATA."SEANCE") 
    REFERENCES seances(XMLDATA."IDSEANCE");
ALTER TABLE reservations ADD CONSTRAINT reservation_client_ref FOREIGN KEY(XMLDATA."CLIENT") 
    REFERENCES clients(XMLDATA."IDCLIENT");


CREATE TABLE archives OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/archive.xsd"
    ELEMENT "archive";
ALTER TABLE archives ADD CONSTRAINT archives_pk PRIMARY KEY(XMLDATA."IDARCHIVE");
ALTER TABLE archives ADD CONSTRAINT archives_copy_fk FOREIGN KEY(XMLDATA."IDCOPIE") 
    REFERENCES films_copies(id);