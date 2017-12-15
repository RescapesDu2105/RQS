create or replace PACKAGE BODY package_RechPlaces
AS
    PROCEDURE RecupererFilms(complexe IN VARCHAR2, acteursInput IN VARCHAR2, realisateursInput IN VARCHAR2, genresInput IN VARCHAR2, titreInput IN VARCHAR2) 
    IS     
        split apex_t_varchar2;
        requete VARCHAR2(4096);
        --TYPE t_collection IS TABLE OF FILMS@orcl@cc1%ROWTYPE INDEX BY BINARY_INTEGER;
        --l_collection t_collection;

        TYPE t_cursor is REF CURSOR;
        --l_cursor t_cursor;
        l_cursor SYS_REFCURSOR;

        req UTL_HTTP.REQ;
        actJSON CLOB;
    BEGIN   
        requete := 
            'SELECT f.*, av.ComplexePopularite, av.ComplexePerenite, c.NomCerti, p.PathImage,
                CURSOR (
                    SELECT j.ARTIST As IdArt, a.NomArt, j.Role
                    FROM Jouer@orcl@' || complexe || ' j INNER JOIN Artists@orcl@' || complexe || ' a ON j.Artist = a.IdArt WHERE f.IdFilm = j.Film) AS Artists,
                CURSOR (
                    SELECT g.NomGenre
                    FROM Film_Genre@orcl@' || complexe || ' fg INNER JOIN Genres@orcl@' || complexe || ' g ON fg.genre = g.IdGenre WHERE fg.Film = f.IdFilm) AS Genres,
                CURSOR (
                    SELECT r.NomArt
                    FROM Realiser@orcl@' || complexe || ' fr INNER JOIN Artists@orcl@' || complexe || ' r ON fr.Artist = r.IdArt WHERE f.IdFilm = fr.Film) AS Realisateurs
            FROM Films@orcl@' || complexe || ' f, Archive_Views av, Certifications c, Posters p 
            WHERE ';

        IF (LENGTH(acteursInput) > 0) THEN
            requete := requete || 
                'EXISTS (
                    SELECT * 
                    FROM ARTISTS INNER JOIN JOUER ON ARTISTS.IdArt = JOUER.Artist 
                    WHERE JOUER.Film = f.IdFilm AND regexp_like(UPPER(ARTISTS.NomArt), ''';
            split := apex_string.split(acteursInput, '\s*[ ]\s*');
            FOR i in split.first..split.last LOOP
                requete := requete || '^' || UPPER(split(i)) || '*|';
            END LOOP;        
            requete := SUBSTR(requete, 0, LENGTH(requete) - 1) || ''')) AND ';
        END IF;

        IF (LENGTH(genresInput) > 0) THEN
            requete := requete || 
                'EXISTS (
                    SELECT * 
                    FROM GENRES INNER JOIN FILM_GENRE ON GENRES.IdGenre = FILM_GENRE.Genre
                    WHERE FILM_GENRE.Film = f.IdFilm 
                    AND regexp_like(UPPER(GENRES.NomGenre), ''';
            split := apex_string.split(genresInput, '\s*[ ]\s*');
            FOR i in split.first..split.last LOOP
                requete := requete || '^' || UPPER(split(i)) || '*|';
            END LOOP;
            requete := SUBSTR(requete, 0, LENGTH(requete) - 1) || ''')) AND ';
        END IF;

        IF (LENGTH(realisateursInput) > 0) THEN
            requete := requete ||
                'EXISTS (
                    SELECT * 
                    FROM ARTISTS INNER JOIN REALISER ON ARTISTS.IdArt = REALISER.Artist 
                    WHERE REALISER.Film = f.IdFilm 
                    AND regexp_like(UPPER(ARTISTS.NomArt), ''';
            split := apex_string.split(realisateursInput, '\s*[ ]\s*');
            FOR i in split.first..split.last LOOP
                requete := requete || '^' || UPPER(split(i)) || '*|';
            END LOOP;
            requete := SUBSTR(requete, 0, LENGTH(requete) - 1) || ''')) AND ';
        END IF;

        IF(LENGTH(titreInput)> 0) THEN
            requete := requete || 'regexp_like(UPPER(f.Titre), ''';    
            split := apex_string.split(titreInput, '\s*[ ]\s*');
            FOR i in split.first..split.last LOOP
                requete := requete || '^' || UPPER(split(i)) || '*|';
            END LOOP;
            requete := SUBSTR(requete, 0, LENGTH(requete) - 1) || ''')) AND ';
        END IF;

        requete := requete ||
            'EXISTS (
                SELECT * 
                FROM Programmations@orcl@' || complexe || ' prog
                WHERE prog.Movie = f.IdFilm ';     
            
        IF(titreInput IS NULL AND realisateursInput IS NULL AND genresInput IS NULL AND acteursInput IS NULL) THEN
            requete := requete || '
                AND TO_DATE(CURRENT_DATE, ''DD/MM/YYYY'') BETWEEN TO_DATE(DEBUT, ''DD/MM/YYYY'') AND TO_DATE(FIN, ''DD/MM/YYYY'')';
        END IF;
        
        requete := requete || ')
            AND av.IdFilm = f.IdFilm
            AND av.IdComplexes = SUBSTR(''' || complexe || ''', 3, 1)
            AND c.IdCerti = f.Certification
            AND p.IdPoster = f.Poster 
            ORDER BY av.ComplexePopularite DESC, ComplexePerenite DESC, f.IdFilm';


                --AND TO_DATE(Fin, ''DD/MM/YYYY'') < TO_DATE(CURRENT_DATE, ''DD/MM/YYYY'')

        DBMS_OUTPUT.PUT_LINE(requete);
        OPEN l_cursor FOR requete;

        APEX_JSON.initialize_clob_output;

        APEX_JSON.open_object;
        APEX_JSON.write('films', l_cursor);
        APEX_JSON.close_object;

        DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);
        actJSON := APEX_JSON.get_clob_output;
        APEX_JSON.free_output;

        htp.print(actJSON);

    --EXCEPTION
        --WHEN OTHERS THEN;        
    END RecupererFilms;

    PROCEDURE RecupererFilms(complexe IN VARCHAR2, acteursInput IN VARCHAR2, realisateursInput IN VARCHAR2, genresInput IN VARCHAR2, titreInput IN VARCHAR2, popInput IN NUMBER, perInput IN NUMBER)
    IS      
        split apex_t_varchar2;
        requete VARCHAR2(4096);
        --TYPE t_collection IS TABLE OF FILMS@orcl@cc1%ROWTYPE INDEX BY BINARY_INTEGER;
        --l_collection t_collection;

        TYPE t_cursor is REF CURSOR;
        --l_cursor t_cursor;
        l_cursor SYS_REFCURSOR;

        req UTL_HTTP.REQ;
        actJSON CLOB;
    BEGIN   
        requete := 
            'SELECT f.*, av.ComplexePopularite, av.ComplexePerenite, c.NomCerti, p.PathImage,
                CURSOR (
                    SELECT j.ARTIST As IdArt, a.NomArt, j.Role
                    FROM Jouer@orcl@' || complexe || ' j INNER JOIN Artists@orcl@' || complexe || ' a ON j.Artist = a.IdArt WHERE f.IdFilm = j.Film) AS Artists,
                CURSOR (
                    SELECT g.NomGenre
                    FROM Film_Genre@orcl@' || complexe || ' fg INNER JOIN Genres@orcl@' || complexe || ' g ON fg.genre = g.IdGenre WHERE fg.Film = f.IdFilm) AS Genres,
                CURSOR (
                    SELECT r.NomArt
                    FROM Realiser@orcl@' || complexe || ' fr INNER JOIN Artists@orcl@' || complexe || ' r ON fr.Artist = r.IdArt WHERE f.IdFilm = fr.Film) AS Realisateurs
            FROM Films@orcl@' || complexe || ' f, Archive_Views av, Certifications c, Posters p 
            WHERE ';

        IF (LENGTH(acteursInput) > 0) THEN
            requete := requete || 
                'EXISTS (
                    SELECT * 
                    FROM ARTISTS INNER JOIN JOUER ON ARTISTS.IdArt = JOUER.Artist 
                    WHERE JOUER.Film = f.IdFilm AND regexp_like(UPPER(ARTISTS.NomArt), ''';
            split := apex_string.split(acteursInput, '\s*[ ]\s*');
            FOR i in split.first..split.last LOOP
                requete := requete || '^' || UPPER(split(i)) || '*|';
            END LOOP;        
            requete := SUBSTR(requete, 0, LENGTH(requete) - 1) || ''')) AND ';
        END IF;

        IF (LENGTH(genresInput) > 0) THEN
            requete := requete || 
                'EXISTS (
                    SELECT * 
                    FROM GENRES INNER JOIN FILM_GENRE ON GENRES.IdGenre = FILM_GENRE.Genre
                    WHERE FILM_GENRE.Film = f.IdFilm 
                    AND regexp_like(UPPER(GENRES.NomGenre), ''';
            split := apex_string.split(genresInput, '\s*[ ]\s*');
            FOR i in split.first..split.last LOOP
                requete := requete || '^' || UPPER(split(i)) || '*|';
            END LOOP;
            requete := SUBSTR(requete, 0, LENGTH(requete) - 1) || ''')) AND ';
        END IF;

        IF (LENGTH(realisateursInput) > 0) THEN
            requete := requete ||
                'EXISTS (
                    SELECT * 
                    FROM ARTISTS INNER JOIN REALISER ON ARTISTS.IdArt = REALISER.Artist 
                    WHERE REALISER.Film = f.IdFilm 
                    AND regexp_like(UPPER(ARTISTS.NomArt), ''';
            split := apex_string.split(realisateursInput, '\s*[ ]\s*');
            FOR i in split.first..split.last LOOP
                requete := requete || '^' || UPPER(split(i)) || '*|';
            END LOOP;
            requete := SUBSTR(requete, 0, LENGTH(requete) - 1) || ''')) AND ';
        END IF;

        IF(LENGTH(titreInput)> 0) THEN
            requete := requete || 'regexp_like(UPPER(f.Titre), ''';    
            split := apex_string.split(titreInput, '\s*[ ]\s*');
            FOR i in split.first..split.last LOOP
                requete := requete || '^' || UPPER(split(i)) || '*|';
            END LOOP;
            requete := SUBSTR(requete, 0, LENGTH(requete) - 1) || ''')) AND ';
        END IF;

        requete := requete ||
            'EXISTS (
                SELECT * 
                FROM Programmations@orcl@' || complexe || ' prog
                WHERE prog.Movie = f.IdFilm ';     
            
        /*IF(titreInput IS NULL AND realisateursInput IS NULL AND genresInput IS NULL AND acteursInput IS NULL) THEN
            requete := requete || '
                AND TO_DATE(CURRENT_DATE, ''DD/MM/YYYY'') BETWEEN TO_DATE(DEBUT, ''DD/MM/YYYY'') AND TO_DATE(FIN, ''DD/MM/YYYY'')';
        END IF;*/
        
        requete := requete || ')
            AND av.IdFilm = f.IdFilm
            AND av.IdComplexes = SUBSTR(''' || complexe || ''', 3, 1)
            AND c.IdCerti = f.Certification
            AND p.IdPoster = f.Poster 
            AND av.ComplexePopularite > ' || popInput || '
            AND av.ComplexePerenite > ' || perInput || '
            ORDER BY av.ComplexePopularite DESC, ComplexePerenite DESC, f.IdFilm';


                --AND TO_DATE(Fin, ''DD/MM/YYYY'') < TO_DATE(CURRENT_DATE, ''DD/MM/YYYY'')

        DBMS_OUTPUT.PUT_LINE('TEST ' || requete);
        OPEN l_cursor FOR requete;

        APEX_JSON.initialize_clob_output;

        APEX_JSON.open_object;
        APEX_JSON.write('films', l_cursor);
        APEX_JSON.close_object;

        DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);
        actJSON := APEX_JSON.get_clob_output;
        APEX_JSON.free_output;

        htp.print(actJSON);
        
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