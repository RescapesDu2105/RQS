BEGIN  
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/artistes.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'artistes.xsd'),
        LOCAL => TRUE, 
		GENTYPES => TRUE, 
		GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8')
    );
	
	DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/genres.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'genres.xsd'),
        LOCAL => TRUE, 
		GENTYPES => TRUE, 
		GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8')
    );
	
    DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/film_genre.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'film_genre.xsd'),
        LOCAL => TRUE, 
		GENTYPES => TRUE, 
		GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8')
    );
END ;