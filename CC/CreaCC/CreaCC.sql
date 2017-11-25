BEGIN  
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/artiste.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'artiste.xsd'),
        LOCAL => TRUE, 
		GENTYPES => TRUE, 
		GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8')
    );
END ;