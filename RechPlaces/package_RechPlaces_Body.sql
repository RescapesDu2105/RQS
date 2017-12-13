create or replace PACKAGE BODY package_RechPlaces
AS
    PROCEDURE RecupererFilms(complexe IN VARCHAR2, acteursInput IN VARCHAR2, realisateursInput IN VARCHAR2, genresInput IN VARCHAR2, titreInput IN VARCHAR2) IS
    BEGIN   
        htp.print ('<html><body><p>' || complexe || '</p></body></html>');
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