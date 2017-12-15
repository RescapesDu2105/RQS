DECLARE
    acteurs VARCHAR2(100);
    realisateurs VARCHAR2(100);
    genres VARCHAR2(100);
    titre VARCHAR2(100);
    apex apex_t_varchar2;
    split apex_t_varchar2;
BEGIN
    acteurs := '';
    realisateurs := ''; --'IRVIN KERSHNER';
    genres := '';--'SCIENCE FICTION';
    titre := '';--'STAR';    
    
    --split := apex_string.split(acteurs, '\s*[ ]\s*');
    --DBMS_OUTPUT.PUT_LINE(split(1));
    
    PACKAGE_RECHPLACES.RecupererFilms('cc1', acteurs, realisateurs, genres, titre);
    
END;
/

SELECT f.*, av.ComplexePopularite, av.ComplexePerenite, c.NomCerti, p.PathImage,
                CURSOR (
                    SELECT j.ARTIST As IdArt, a.NomArt, j.Role
                    FROM Jouer@orcl@cc1 j INNER JOIN Artists@orcl@cc1 a ON j.Artist = a.IdArt WHERE f.IdFilm = j.Film) AS Artists,
                CURSOR (
                    SELECT g.NomGenre
                    FROM Film_Genre@orcl@cc1 fg INNER JOIN Genres@orcl@cc1 g ON fg.genre = g.IdGenre WHERE fg.Film = f.IdFilm) AS Genres,
                CURSOR (
                    SELECT r.NomArt
                    FROM Realiser@orcl@cc1 fr INNER JOIN Artists@orcl@cc1 r ON fr.Artist = r.IdArt WHERE f.IdFilm = fr.Film) AS Realisateurs
            FROM Films@orcl@cc1 f, Archive_Views av, Certifications c, Posters p 
            WHERE EXISTS (
                    SELECT * 
                    FROM ARTISTS INNER JOIN JOUER ON ARTISTS.IdArt = JOUER.Artist 
                    WHERE JOUER.Film = f.IdFilm AND regexp_like(UPPER(ARTISTS.NomArt), '^HARR*')) 
            AND EXISTS (
                SELECT * 
                FROM Programmations@orcl@cc1 prog
                WHERE prog.Movie = f.IdFilm )
            AND av.IdFilm = f.IdFilm
            AND av.IdComplexes = SUBSTR('cc1', 3, 1)
            AND c.IdCerti = f.Certification
            AND p.IdPoster = f.Poster 
            ORDER BY av.ComplexePopularite DESC, ComplexePerenite DESC, f.IdFilm;
SELECT * 
FROM ARTISTS INNER JOIN JOUER ON ARTISTS.IdArt = JOUER.Artist 
WHERE JOUER.Film = 11 AND regexp_like(UPPER(ARTISTS.NomArt), '^HARR*');
  
SELECT CURRENT_DATE, TO_DATE(prog.DEBUT, 'DD/MM/YYYY'), TO_DATE(prog.FIN, 'DD/MM/YYYY')
FROM Programmations@orcl@cc1 prog
--WHERE CURRENT_DATE BETWEEN TO_DATE(prog.DEBUT, 'DD/MM/YYYY') AND TO_DATE(prog.FIN, 'DD/MM/YYYY')
;    

SELECT NomArt FROM Artists@orcl@cc1 WHERE regexp_like(UPPER(ARTISTS.NomArt), 'FORD');

DECLARE
  l_cursor SYS_REFCURSOR;
  requete VARCHAR2(2048);
BEGIN
   requete := 
        'SELECT f.*, av.ComplexePopularite, av.ComplexePerenite, c.NomCerti,  
            CURSOR (SELECT j.ARTIST As IdArt, a.NomArt AS NomArt
                    FROM Jouer@orcl@cc1 j INNER JOIN Artists@orcl@cc1 a ON j.Artist = a.IdArt
                    WHERE f.IdFilm = j.Film) AS Artists
        FROM Films@orcl@CC1 f, Archive_Views av, Certifications c 
        WHERE EXISTS (
            SELECT * 
            FROM ARTISTS INNER JOIN JOUER ON ARTISTS.IdArt = JOUER.Artist 
            WHERE JOUER.Film = f.IdFilm 
            AND regexp_like(UPPER(ARTISTS.NomArt), ''FORD'')) 
        AND EXISTS (
            SELECT * 
            FROM GENRES INNER JOIN FILM_GENRE ON GENRES.IdGenre = FILM_GENRE.Genre 
            WHERE FILM_GENRE.Film = f.IdFilm 
            AND regexp_like(UPPER(GENRES.NomGenre), ''^SCIENCE*|^FICTION*'')) 
        AND EXISTS (
            SELECT * 
            FROM ARTISTS INNER JOIN REALISER ON ARTISTS.IdArt = REALISER.Artist 
            WHERE REALISER.Film = f.IdFilm 
            AND regexp_like(UPPER(ARTISTS.NomArt), ''^IRVIN*|^KERSHNER*'')) 
        AND EXISTS (
            SELECT * 
            FROM ARTISTS INNER JOIN REALISER ON ARTISTS.IdArt = REALISER.Artist 
            WHERE REALISER.Film = f.IdFilm 
            AND regexp_like(UPPER(ARTISTS.NomArt), ''^IRVIN*|^KERSHNER*'')) 
        AND regexp_like(UPPER(f.Titre), ''^STAR*'')
        AND EXISTS (
            SELECT * 
            FROM Programmations@orcl@cc1 
            WHERE Movie = f.IdFilm
            AND TO_DATE(Fin, ''DD/MM/YYYY'') < TO_DATE(CURRENT_DATE, ''DD/MM/YYYY''))        
        AND av.IdFilm = f.IdFilm
        AND av.IdComplexes = SUBSTR(''cc1'', 3, 1)
        AND c.IdCerti = f.Certification
        ORDER BY f.IdFilm';
        
        OPEN l_cursor FOR requete;
    /*OPEN l_cursor FOR
        SELECT f.*,
            CURSOR (SELECT j.ARTIST As IdArt, a.NomArt AS NomArt
                    FROM Jouer@orcl@cc1 j JOIN Artists@orcl@cc1 a ON j.Artist = a.IdArt
                    WHERE f.IdFilm = j.Film) AS Artists
        FROM Films@orcl@CC1 f
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
        AND EXISTS (
            SELECT * 
            FROM ARTISTS INNER JOIN REALISER ON ARTISTS.IdArt = REALISER.Artist 
            WHERE REALISER.Film = f.IdFilm 
            AND regexp_like(UPPER(ARTISTS.NomArt), '^IRVIN*|^KERSHNER*')) 
        AND regexp_like(UPPER(f.Titre), '^STAR*')
        ORDER BY f.IdFilm;
*/
    APEX_JSON.initialize_clob_output;
    
    APEX_JSON.open_object;
    APEX_JSON.write('films', l_cursor);
    APEX_JSON.close_object;
    
    DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);
    APEX_JSON.free_output;
    --CLOSE l_cursor;
END;
/
