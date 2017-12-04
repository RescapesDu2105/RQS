BEGIN
   DBMS_XMLSCHEMA.DELETESCHEMA(
    'http://cc/programmation.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE
    );
        
  DBMS_XMLSCHEMA.REGISTERSCHEMA(
    SCHEMAURL => 'http://cc/programmation.xsd',
    SCHEMADOC => BFILENAME('DIRXML', 'programmation.xsd'),
    LOCAL => TRUE, GENTYPES => TRUE, GENTABLES => FALSE,
    CSID => NLS_CHARSET_ID('AL32UTF8')
  );
  
END ;
/

CREATE TABLE PROGRAMMATION OF XMLType
XMLTYPE STORE AS OBJECT RELATIONAL
XMLSCHEMA "http://cc/programmation.xsd"
ELEMENT "programmation";

INSERT INTO programmation
VALUES (XMLType(BFILENAME('DIRXML','programmations.xml'),NLS_CHARSET_ID('AL32UTF8')));


