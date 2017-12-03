--commanter le delete Schema si c'est la premiere fois
BEGIN
    DBMS_XMLSCHEMA.DELETESCHEMA(
        'http://cc/programmation.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
    
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/programmation.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'programmation.xsd'),
        LOCAL => TRUE, 
        GENTYPES => TRUE, 
        GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8'));
END;
/

DROP TABLE programmations;
CREATE TABLE programmations OF XMLType
    XMLTYPE STORE AS OBJECT RELATIONAL
    XMLSCHEMA "http://cc/programmation.xsd"
    ELEMENT "programmation" ;
ALTER TABLE programmations ADD CONSTRAINT programmation_pk PRIMARY KEY(XMLDATA."IDDEMANDE");
ALTER TABLE programmations ADD CONSTRAINT programmation_film_copie_copy_fk FOREIGN KEY(XMLDATA."COPY") 
    REFERENCES films_copies(id);
ALTER TABLE programmations ADD CONSTRAINT programmation_film_copie_movie_fk FOREIGN KEY(XMLDATA."MOVIE") 
    REFERENCES films_copies(movie);

--commanter le delete Schema si c'est la premiere fois
BEGIN
    DBMS_XMLSCHEMA.DELETESCHEMA(
        'http://cc/feedback.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
    
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/feedback.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'feedback.xsd'),
        LOCAL => TRUE, 
        GENTYPES => TRUE, 
        GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8'));
END;
/    