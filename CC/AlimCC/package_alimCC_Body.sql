create or replace PACKAGE BODY package_AlimCC
AS
    PROCEDURE Take_Copy AS
        nbCopys NUMBER(2,0);
        l_copy Liste_Copie;
        l_copy_temp Liste_Copie;
        l_id_film Liste_Id_Movie;
        l_id_arecup Liste_Id_Movie;
        i NUMBER;
        isPresent boolean;
    BEGIN
    
        select abs(((DBMS_RANDOM.NORMAL)*COUNT(*))/6+1) INTO nbCopys
        FROM films_copies;
        IF nbCopys>0 THEN
            i:=1;
            FOR l_copy_temp IN (select * from films_copies order by dbms_random.value)
            LOOP
                EXIT WHEN i > nbCopys;
                l_copy(i) := l_copy_temp;
                i:=i+1;
            END LOOP;
            
            l_id_film(1):=l_copy(1).movie;
            FOR indx IN l_copy.FIRST .. l_copy.LAST LOOP
                isPresent:=false;
                FOR jndx IN l_id_film.first .. l_id_film.LAST LOOP
                    IF l_copy(indx).movie=l_id_film(jndx) THEN
                        isPresent:=true;
                    END IF;
                END LOOP;
                IF isPresent=false THEN
                    l_id_film(l_id_film.LAST+1):=l_copy(indx).movie;
                END IF;
            END LOOP;
            
            /*FOR indx IN l_copy.FIRST .. l_copy.LAST LOOP
                dbms_output.put_line('copye : '||l_copy(indx).movie);
            END LOOP;*/
            
            /*FOR indx IN l_id_film.FIRST .. l_id_film.LAST LOOP
                dbms_output.put_line('film : '||l_id_film(indx));
            END LOOP;    */
            
            l_id_arecup:=Check_MovieDescription(l_id_film,1);
            Recup_Data(l_id_arecup);
        END IF;
             
    END Take_Copy;

    FUNCTION Check_MovieDescription(l_id_film IN Liste_Id_Movie , p_complexe IN NUMBER) RETURN Liste_Id_Movie 
    IS
        id_temp films.idFilm%TYPE;
        requeteBlock varchar2(2000);
        l_id_film_temp Liste_Id_Movie;
        l_copy_temp Liste_Id_Movie;
        isPresent boolean;
    BEGIN
        FOR indx IN l_id_film.FIRST .. l_id_film.LAST LOOP
        requeteBlock:='
            SELECT IdFilm
            FROM FILMS@orcl@cc'||p_complexe||'
            WHERE idFilm='||l_id_film(indx);
            EXECUTE IMMEDIATE requeteBlock BULK COLLECT INTO l_id_film_temp;
        END LOOP;
        
        IF l_id_film_temp.count>0 THEN
            FOR indx IN l_id_film.FIRST .. l_id_film.LAST LOOP
                isPresent:=false;
                FOR jndx IN l_id_film_temp.FIRST .. l_id_film_temp.LAST LOOP
                    IF l_id_film(indx) = l_id_film_temp(jndx) THEN
                        isPresent:=TRUE;
                    END IF;
                END LOOP;
                IF isPresent=FALSE THEN
                    l_copy_temp(l_copy_temp.LAST+1):=l_id_film(indx);
                END IF;
            END LOOP;
            RETURN l_copy_temp;
        ELSE
            RETURN l_id_film;
        END IF;
    END Check_MovieDescription;
    
    
    PROCEDURE Recup_Data(l_id_film IN Liste_Id_Movie) AS
    BEGIN
        FOR indx IN l_id_film.FIRST .. l_id_film.LAST LOOP
            SELECT * INTO l_films(indx)
            FROM films
            WHERE idFilm=l_id_film(indx);
            
            SELECT Jouer.* INTO l_jouer(indx)
            FROM Jouer JOIN Films
            ON Jouer.Film=Films.idFilm
            Where Films.idFilm=l_id_film(indx);
            
            SELECT Realiser.* INTO l_realiser(indx)
            FROM Realiser JOIN Films
            ON Realiser.Film=Films.idFilm
            Where Films.idFilm=l_id_film(indx);
            
            SELECT Artists.* INTO l_artists(indx)
            FROM Artists JOIN Jouer
            ON Artists.idArt=Jouer.Artist
            WHERE Jouer.Film=l_id_film(indx);
            
            SELECT Certifications.* INTO l_certification(indx)
            FROM Certifications JOIN Films
            ON Certifications.idCerti=Films.Certification
            WHERE Films.idFilm=l_id_film(indx);
            
            SELECT Posters.* INTO l_posters(indx)
            FROM Posters JOIN Films
            ON Posters.idPoster=Films.Poster
            WHERE Films.idFilm=l_id_film(indx);
            
            SELECT Film_Genre.* INTO l_film_genre(indx)
            FROM Film_Genre JOIN Films
            ON Film_Genre.Film=Films.idFilm
            WHERE Films.idFilm=l_id_film(indx);
            
            SELECT Genres.* INTO l_genres(indx)
            FROM Genres JOIN Film_Genre
            ON Genres.idGenre=Film_Genre.Genre
            WHERE Film_Genre.Film=l_id_film(indx);
        END LOOP;
        
    END Recup_Data;
    
END package_AlimCC;
--dbms_output.put_line(Liste(indx));