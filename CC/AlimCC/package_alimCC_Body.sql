create or replace PACKAGE BODY package_AlimCC
AS
    PROCEDURE Take_Copy AS
        nbCopys NUMBER(2,0);
        l_copy Liste_Copie;
        l_copy_temp Liste_Copie;
        l_id_film Liste_Id_Movie;
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
            END LOOP;
            
            FOR indx IN l_id_film.FIRST .. l_id_film.LAST LOOP
                dbms_output.put_line('film : '||l_id_film(indx));
            END LOOP;*/          
            l_id_film:=Check_MovieDescription(l_id_film,1);
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
        END LOOP;
        

        EXECUTE IMMEDIATE requeteBlock BULK COLLECT INTO l_id_film_temp;
        dbms_output.put_line(l_id_film_temp.count);
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
    
END package_AlimCC;
--dbms_output.put_line(Liste(indx));