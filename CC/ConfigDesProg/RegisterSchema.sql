--Si c'est la premiere executer le deuxieme block PL/SQL
BEGIN
    DBMS_XMLSCHEMA.DELETESCHEMA(
      'http://cc/archive.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
      
  DBMS_XMLSCHEMA.DELETESCHEMA(
      'http://cc/complexe.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
      
  DBMS_XMLSCHEMA.DELETESCHEMA(
      'http://cc/client.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
      
  DBMS_XMLSCHEMA.DELETESCHEMA(
      'http://cc/reservation.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);

  DBMS_XMLSCHEMA.DELETESCHEMA(
      'http://cc/salle.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);

  DBMS_XMLSCHEMA.DELETESCHEMA(
      'http://cc/seance.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
      
    DBMS_XMLSCHEMA.DELETESCHEMA(
        'http://cc/programmation.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
END;
/

BEGIN
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/archive.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'archive.xsd'),
        LOCAL => TRUE, 
        GENTYPES => TRUE, 
        GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8'));
        
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/complexe.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'complexe.xsd'),
        LOCAL => TRUE, 
        GENTYPES => TRUE, 
        GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8'));
    
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/client.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'client.xsd'),
        LOCAL => TRUE, 
        GENTYPES => TRUE, 
        GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8'));
        
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/reservation.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'reservation.xsd'),
        LOCAL => TRUE, 
        GENTYPES => TRUE, 
        GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8'));
        
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/salle.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'salle.xsd'),
        LOCAL => TRUE, 
        GENTYPES => TRUE, 
        GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8'));
        
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/seance.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'seance.xsd'),
        LOCAL => TRUE, 
        GENTYPES => TRUE, 
        GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8'));
    
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/programmation.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'programmation.xsd'),
        LOCAL => TRUE, 
        GENTYPES => TRUE, 
        GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8'));
        
END;
/