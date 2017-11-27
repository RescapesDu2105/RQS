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
	
	DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/realiser.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'realiser.xsd'),
        LOCAL => TRUE, 
		GENTYPES => TRUE, 
		GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8')
    );
	
	DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/jouer.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'jouer.xsd'),
        LOCAL => TRUE, 
		GENTYPES => TRUE, 
		GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8')
    );
	
	DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/films.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'films.xsd'),
        LOCAL => TRUE, 
		GENTYPES => TRUE, 
		GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8')
    );
	
	DBMS_XMLSCHEMA.REGISTERSCHEMA(
        SCHEMAURL => 'http://cc/films_copies.xsd',
        SCHEMADOC => BFILENAME('DIRXML', 'films_copies.xsd'),
        LOCAL => TRUE, 
		GENTYPES => TRUE, 
		GENTABLES => FALSE,
        CSID => NLS_CHARSET_ID('AL32UTF8')
    );
END ;