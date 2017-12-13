create or replace PACKAGE BODY package_AlimCC
AS
    PROCEDURE AlimCC(p_idFilm IN NUMBER,p_complexe IN NUMBER) AS
        nbGeneretad NUMBER;
        isConnu BOOLEAN;
        EXC_PlusdeCopieDispo EXCEPTION;
    BEGIN
        dbms_output.put_line(p_complexe);
        l_artists.delete;
        l_jouer.delete;
        l_film_genre.delete;
        l_copie.delete;
        l_genres.delete;
        l_programmation.delete;
        isConnu:=FALSE;
        nbGeneretad:=Generate_Number_Copy(p_idFilm);
        IF nbGeneretad>0 THEN 
            Take_Copy(p_idFilm,nbGeneretad);
            isConnu:=Info_Connue(p_idFilm,p_complexe);
            IF isConnu=FALSE THEN
                Recup_Data(p_idFilm,p_complexe);
                Insert_Data(p_complexe);
            END IF;
            Send_Copy(p_complexe);
        END IF;
    EXCEPTION
        WHEN EXC_PlusdeCopieDispo THEN dbms_output.put_line('Plus du copie disponible pour le film : '||p_idFilm);
        WHEN OTHERS THEN RAISE;
    END AlimCC;
    
    PROCEDURE AlimCC AS
        l_id_Film Liste_id_Film;
    BEGIN
        SELECT idFilm BULK COLLECT INTO l_id_Film
        FROM FILMS;
        
        FOR p_complexe IN 1..6 LOOP
            FOR indx IN l_id_Film.FIRST .. l_id_Film.LAST LOOP
                AlimCC(l_id_Film(indx),p_complexe);
            END LOOP;
        END LOOP;
    END AlimCC;
    
    FUNCTION Generate_Number_Copy(p_idFilm IN NUMBER) RETURN NUMBER
    IS 
        nbCopy NUMBER(2,0);
    BEGIN
        select abs(((DBMS_RANDOM.NORMAL)*COUNT(*))/6+1) INTO nbCopy
        FROM films_copies
        WHERE movie=p_idFilm;
        
        RETURN nbCopy;
    END Generate_Number_Copy;
    
    PROCEDURE Take_Copy(p_idFilm IN NUMBER , nbCopy IN NUMBER) AS
        nbCopyDispo NUMBER;
        EXC_PlusdeCopieDispo EXCEPTION;
    BEGIN
        SELECT COUNT(*) INTO nbCopyDispo
        FROM films_copies
        WHERE movie=p_idFilm;
        
        IF nbCopyDispo>nbCopy OR nbCopyDispo=nbCopy THEN
            SELECT * BULK COLLECT INTO l_copie
            FROM films_copies
            WHERE movie=p_idFilm
            AND ROWNUM<nbCopy+1;
        ELSIF nbCopyDispo>0 THEN
            SELECT * BULK COLLECT INTO l_copie
            FROM films_copies
            WHERE movie=p_idFilm
            AND ROWNUM<nbCopyDispo+1;
        ELSE
            RAISE EXC_PlusdeCopieDispo;
        END IF;          
        
    EXCEPTION
        WHEN EXC_PlusdeCopieDispo THEN RAISE;
        WHEN OTHERS THEN RAISE;
    END Take_Copy; 
    
    FUNCTION Info_Connue(p_idFilm IN NUMBER , p_complexe IN NUMBER) RETURN boolean
    IS
        idTemp NUMBER:=0;
        requeteBlock varchar2(2000);
    BEGIN
        requeteBlock:='
            SELECT IdFilm
            FROM FILMS@orcl@cc'||p_complexe||'
            WHERE idFilm='||p_idFilm;
            EXECUTE IMMEDIATE requeteBlock INTO idTemp;
            IF idTemp <>0 AND idTemp=p_idFilm THEN RETURN TRUE; END IF;
            
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN FALSE;
        WHEN OTHERS THEN RAISE;
    END Info_Connue;
    
    PROCEDURE Recup_Data(p_idFilm IN NUMBER , p_complexe IN NUMBER) AS
    BEGIN
        SELECT * INTO films_temp
        FROM films
        WHERE idFilm=p_idFilm;
        
        SELECT Jouer.* BULK COLLECT INTO l_jouer
        FROM Jouer JOIN Films
        ON Jouer.Film=Films.idFilm
        Where Films.idFilm=p_idFilm;
        
        SELECT Realiser.* INTO realiser_temp
        FROM Realiser JOIN Films
        ON Realiser.Film=Films.idFilm
        Where Films.idFilm=p_idFilm; 
        
        select Artists.* BULK COLLECT INTO l_artists
        from artists
        WHERE idArt IN (
            SELECT JOUER.Artist
            FROM jouer JOIN films
            ON JOUER.film=films.idFilm
            WHERE films.idFilm=p_idFilm)
        OR idArt IN(
            SELECT REALISER.Artist
            FROM REALISER JOIN films
            ON REALISER.film=films.idFilm
            WHERE films.idFilm=p_idFilm);
        
        SELECT Certifications.* INTO certifications_temp
        FROM Certifications JOIN Films
        ON Certifications.idCerti=Films.Certification
        WHERE Films.idFilm=p_idFilm;
        
        SELECT Posters.* INTO posters_temp
        FROM Posters JOIN Films
        ON Posters.idPoster=Films.Poster
        WHERE Films.idFilm=p_idFilm;
        
        SELECT Film_Genre.* BULK COLLECT INTO l_film_genre
        FROM Film_Genre JOIN Films
        ON Film_Genre.Film=Films.idFilm
        WHERE Films.idFilm=p_idFilm;
        
        SELECT Genres.* BULK COLLECT INTO l_genres
        FROM Genres JOIN Film_Genre
        ON Genres.idGenre=Film_Genre.Genre
        WHERE Film_Genre.Film=p_idFilm;
        
        BEGIN
            FOR indx IN l_copie.FIRST .. l_copie.LAST LOOP
                SELECT * INTO l_programmation(indx)
                FROM PROGRAMMATIONS_VIEW
                WHERE copy=l_copie(indx).id
                AND complexe=p_complexe;
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
          
    END Recup_Data;
    
    PROCEDURE Insert_Data(p_complexe IN NUMBER) AS
        requeteBlock varchar2(2000);
    BEGIN

        requeteBlock:='
            INSERT INTO POSTERS@orcl@cc'||p_complexe||'(IdPoster,PathImage,Image) VALUES(:idPoster , :PathImage,:IMAGE)';
            EXECUTE IMMEDIATE requeteBlock USING posters_temp.idPoster, posters_temp.PathImage,posters_temp.IMAGE; 
            
        BEGIN
            requeteBlock:='
                INSERT INTO CERTIFICATIONS@orcl@cc'||p_complexe||'(idCerti,nomCerti) VALUES(:idCerti , :nomCerti)';
                EXECUTE IMMEDIATE requeteBlock USING certifications_temp.idCerti,certifications_temp.nomCerti;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN NULL;
        END ;
        
        requeteBlock:='
            INSERT INTO FILMS@orcl@cc'||p_complexe||' 
            VALUES(:idFilm ,:Titre , :Titre_Original,:status,:tagline,:Date_real, :vote_average,:vote_count,:certification,:duree,
                :budget,:poster)';
        EXECUTE IMMEDIATE requeteBlock USING films_temp.idFilm ,films_temp.Titre , films_temp.Titre_Original,films_temp.status,
                films_temp.tagline,films_temp.Date_real, films_temp.vote_average,films_temp.vote_count,films_temp.certification,
                films_temp.duree,films_temp.budget,films_temp.poster;
                
        FOR indx IN l_genres.FIRST .. l_genres.LAST LOOP
            BEGIN
                requeteBlock:='
                    INSERT INTO genres@orcl@cc'||p_complexe||'(idGenre,nomGenre) VALUES(:idGenre , :nomGenre)';
                    EXECUTE IMMEDIATE requeteBlock USING l_genres(indx).idGenre,l_genres(indx).nomGenre;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END ;
        END LOOP;
        
        FOR indx IN l_film_genre.FIRST .. l_film_genre.LAST LOOP
            BEGIN
                requeteBlock:='
                    INSERT INTO film_genre@orcl@cc'||p_complexe||'(genre,film) VALUES(:genre , :film)';
                    EXECUTE IMMEDIATE requeteBlock USING l_film_genre(indx).genre,l_film_genre(indx).film;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END ;
        END LOOP;
        
        FOR indx IN l_artists.FIRST .. l_artists.LAST LOOP
            BEGIN
                requeteBlock:='
                    INSERT INTO artists@orcl@cc'||p_complexe||'(idArt,nomArt) VALUES(:idArt , :nomArt)';
                    EXECUTE IMMEDIATE requeteBlock USING l_artists(indx).idArt,l_artists(indx).nomArt;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END ;            
        END LOOP;
        
        requeteBlock:='
            INSERT INTO realiser@orcl@cc'||p_complexe||'(Film,artist) VALUES(:Film , :artist)';
        EXECUTE IMMEDIATE requeteBlock USING realiser_temp.Film,realiser_temp.artist;
        
        FOR indx IN l_jouer.FIRST .. l_jouer.LAST LOOP
            BEGIN
                requeteBlock:='
                    INSERT INTO jouer@orcl@cc'||p_complexe||'(film,artist,role) VALUES(:film , :artist ,:role)';
                    EXECUTE IMMEDIATE requeteBlock USING l_jouer(indx).film,l_jouer(indx).artist,l_jouer(indx).role;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END ;            
        END LOOP;
        
        IF l_programmation.count>0 THEN
            FOR indx IN l_programmation.FIRST .. l_programmation.LAST LOOP
                requeteBlock:='
                    INSERT INTO programmations@orcl@cc'||p_complexe||'(IdDemande,complexe,debut,fin,movie,copy,
                        salle,heure) VALUES(:IdDemande,:complexe,:debut,:fin,:movie,:copy,:salle,:heure)';
                 EXECUTE IMMEDIATE requeteBlock USING l_programmation(indx).IdDemande,l_programmation(indx).complexe,
                 l_programmation(indx).debut,l_programmation(indx).fin,l_programmation(indx).movie,l_programmation(indx).copy,
                 l_programmation(indx).salle,l_programmation(indx).heure;
            END LOOP;
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN 
        dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
    END Insert_Data;

    PROCEDURE Send_Copy(p_complexe IN NUMBER) AS
        requeteBlock varchar2(2000); 
    BEGIN
        FOR indx IN l_copie.FIRST .. l_copie.LAST LOOP
            requeteBlock:='
                INSERT INTO films_copies@orcl@cc'||p_complexe||'(id,movie) VALUES(:id,:movie)';
                EXECUTE IMMEDIATE requeteBlock USING l_copie(indx).id,l_copie(indx).movie;
                DELETE FROM films_copies WHERE id=l_copie(indx).id;
        END LOOP;
    END Send_Copy;

END package_AlimCC;
--dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
--dbms_output.put_line(Liste(indx));