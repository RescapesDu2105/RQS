create or replace PACKAGE BODY package_RechPlaces
AS
    PROCEDURE RecupererFilms(complexe IN VARCHAR2, acteursInput IN VARCHAR2, realisateursInput IN VARCHAR2, genresInput IN VARCHAR2, titreInput IN VARCHAR2) 
    IS     
        split apex_t_varchar2;
        requete VARCHAR2(1500);
        TYPE t_collection IS TABLE OF FILMS@orcl@cc1%ROWTYPE INDEX BY BINARY_INTEGER;
        l_collection t_collection;
    BEGIN   
        requete := 'SELECT DISTINCT * FROM Films@orcl@' || complexe || ' WHERE EXISTS (SELECT * FROM ARTISTS INNER JOIN JOUER ON ARTISTS.IdArt = JOUER.Artist WHERE JOUER.Film = f.IdFilm AND regexp_like(UPPER(ARTISTS.NomArt), ''';        
        
        split := apex_string.split(acteursInput, '\s*[ ]\s*');
        FOR i in split.first..split.last LOOP
            requete := requete || '^' || split(i) || '*|';
        END LOOP;        
        requete := SUBSTR(requete, 0, LENGTH(requete) - 1);
        requete := requete || ''')) AND EXISTS (SELECT * FROM GENRES INNER JOIN FILM_GENRE ON GENRES.IdGenre = FILM_GENRE.Genre WHERE FILM_GENRE.Film = f.IdFilm AND regexp_like(UPPER(GENRES.NomGenre), ''';      
                   
                      
        split := apex_string.split(genresInput, '\s*[ ]\s*');
        FOR i in split.first..split.last LOOP
            requete := requete || '^' || split(i) || '*|';
        END LOOP;
        requete := SUBSTR(requete, 0, LENGTH(requete) - 1);
        requete := requete || ''')) AND EXISTS (SELECT * FROM ARTISTS INNER JOIN REALISER ON ARTISTS.IdArt = REALISER.Artist WHERE REALISER.Film = f.IdFilm AND regexp_like(UPPER(ARTISTS.NomArt), ''';
            
        split := apex_string.split(realisateursInput, '\s*[ ]\s*');
        FOR i in split.first..split.last LOOP
            requete := requete || '^' || split(i) || '*|';
        END LOOP;
        requete := SUBSTR(requete, 0, LENGTH(requete) - 1);
        requete := requete || ''')) AND EXISTS (SELECT * FROM ARTISTS INNER JOIN REALISER ON ARTISTS.IdArt = REALISER.Artist WHERE REALISER.Film = f.IdFilm AND regexp_like(UPPER(ARTISTS.NomArt), ''';
           
        split := apex_string.split(realisateursInput, '\s*[ ]\s*');
        FOR i in split.first..split.last LOOP
            requete := requete || '^' || split(i) || '*|';
        END LOOP;
        requete := SUBSTR(requete, 0, LENGTH(requete) - 1);
        requete := requete || ''')) AND regexp_like(UPPER(f.Titre), ''';
        
        split := apex_string.split(titreInput, '\s*[ ]\s*');
        FOR i in split.first..split.last LOOP
            requete := requete || '^' || split(i) || '*|';
        END LOOP;
        requete := SUBSTR(requete, 0, LENGTH(requete) - 1);
        requete := requete || ''') AND EXISTS (SELECT Movie FROM Programmations@orcl@cc1 WHERE Movie = f.IdFilm) AND TO_DATE(Fin, ''DD/MM/YYYY'') > TO_DATE(CURRENT_DATE, ''DD/MM/YYYY'')';
            
        
        EXECUTE IMMEDIATE requete BULK COLLECT INTO l_collection;
        htp.print ('<html><body><p> Test : ' || l_collection(1).Titre || '</p></body></html>');
        DBMS_OUTPUT.PUT_LINE(requete);
            
        /*SELECT DISTINCT *
        FROM Films@orcl@cc1 f
        WHERE EXISTS (
            SELECT *
            FROM ARTISTS INNER JOIN JOUER ON ARTISTS.IdArt = JOUER.Artist
            WHERE JOUER.Film = f.IdFilm
            AND regexp_like(UPPER(ARTISTS.NomArt), '^HARRISON*|^FORD*|^CARRIE*|^FISHER*'))
        AND EXISTS (
            SELECT *
            FROM GENRES INNER JOIN FILM_GENRE ON GENRES.IdGenre = FILM_GENRE.Genre
            WHERE FILM_GENRE.Film = f.IdFilm
            AND regexp_like(UPPER(GENRES.NomGenre), '^SCIENCE*|^FICTION*'))
        AND EXISTS (
            SELECT *
            FROM ARTISTS INNER JOIN REALISER ON ARTISTS.IdArt = REALISER.Artist
            WHERE REALISER.Film = f.IdFilm
            AND regexp_like(UPPER(ARTISTS.NomArt), '^IRVIN*|^KERSHNER*'))
        AND regexp_like(UPPER(f.Titre), '^STAR*')
        AND EXISTS (
            SELECT Movie 
            FROM Programmations@orcl@cc1
            WHERE Movie = f.IdFilm)
            AND TO_DATE(Fin, 'DD/MM/YYYY') > TO_DATE(CURRENT_DATE, 'DD/MM/YYYY');*/
            
        
        /*requete := 
            'SELECT * 
            FROM Films@orcl@' || complexe || ' 
            WHERE IdFilm IN (
                SELECT Movie 
                FROM Programmations@orcl@' || complexe || '
                WHERE TO_DATE(FIN, ''DD/MM/YYYY'') > TO_DATE(CURRENT_DATE, ''DD/MM/YYYY'')';

        EXECUTE IMMEDIATE requete BULK COLLECT INTO l_collection;*/
/*
        htp.print ('<html><body>');
        FOR i in l_collection.first..l_collection.last LOOP
            htp.print('<p>' || l_collection(i).Titre || '</p>');
        END LOOP;
        htp.print('</body></html>');*/


    --EXCEPTION
        --WHEN OTHERS THEN;        
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