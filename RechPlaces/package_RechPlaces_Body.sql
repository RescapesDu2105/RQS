create or replace PACKAGE BODY package_RechPlaces
AS
    PROCEDURE RecupererFilms(complexe IN VARCHAR2, acteursInput IN VARCHAR2, realisateursInput IN VARCHAR2, genresInput IN VARCHAR2, titreInput IN VARCHAR2) 
    IS        
        requete VARCHAR2(512);
        TYPE t_collection IS TABLE OF FILMS@orcl@cc1%ROWTYPE INDEX BY BINARY_INTEGER;
        l_collection t_collection;
    BEGIN   
        requete := 'SELECT * FROM Films@orcl@' || complexe;
        EXECUTE IMMEDIATE requete BULK COLLECT INTO l_collection;
        
        htp.print ('<html><body>');
        FOR i in l_collection.first..l_collection.last LOOP
            htp.print('<p>' || l_collection(i).Titre || '</p>');
        END LOOP;
        htp.print('</body></html>');
    END RecupererFilms;
    
    PROCEDURE RecupererFilms(complexe IN VARCHAR2, acteursInput IN VARCHAR2, realisateursInput IN VARCHAR2, genresInput IN VARCHAR2, titreInput IN VARCHAR2, popInput IN NUMBER, perInput IN NUMBER) IS
    BEGIN            
        htp.print ('<html><body><p>' || popInput || '</p> <p>' || perInput || '</p> </body></html>');
    END RecupererFilms;
    
    PROCEDURE RecupererFilms(complexe IN VARCHAR2, acteursInput IN VARCHAR2, realisateursInput IN VARCHAR2, genresInput IN VARCHAR2, titreInput IN VARCHAR2, popInput IN NUMBER) IS
    BEGIN            
        htp.print ('<html><body><p>' || popInput || '</p></body></html>');
    END RecupererFilms;
    
    PROCEDURE RecupererFilms(complexe IN VARCHAR2, acteursInput IN VARCHAR2, realisateursInput IN VARCHAR2, genresInput IN VARCHAR2, titreInput IN VARCHAR2, perInput IN NUMBER) IS
    BEGIN            
        htp.print ('<html><body><p>' || perInput || '</p></body></html>');
    END RecupererFilms;

END package_RechPlaces;