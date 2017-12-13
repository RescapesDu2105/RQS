create or replace PACKAGE BODY packageAlimCB
AS
    FUNCTION Delete_Spaces(chaine IN varchar2)RETURN varchar2 IS 
    BEGIN 
        RETURN REGEXP_REPLACE(chaine, '[[:cntrl:]]|[[:space:]]{2,}', ' ' );
	EXCEPTION
		WHEN OTHERS THEN 
        dbms_output.put_line('ici');
        RAISE;
    END Delete_Spaces;

    FUNCTION TRUNC_Chaine(chaine in varchar2 , quantile IN number)RETURN varchar2 
    IS
        resultat varchar2(1024 CHAR);
    BEGIN
        IF LENGTH(chaine)>quantile THEN
            Ajout_Log_Error(CURRENT_TIMESTAMP, 'AlimCB', '-20001', chaine || 'dépasse : '|| quantile);
            resultat:=substr(chaine,1,quantile-5) || '(...)';
        return resultat;
        ELSE
            return chaine;
        END IF ;
	EXCEPTION
		WHEN OTHERS THEN 
        RAISE;
    END TRUNC_Chaine;

    FUNCTION Analyse_Certi(Certification IN varchar2) RETURN varchar2
    IS
        NewCerti varchar2(5);
    BEGIN
        IF CERTIFICATION IS NOT NULL THEN
            IF Certification NOT IN ('G', 'PG', 'PG-13', 'R', 'NC-17') THEN
                CASE 
                    WHEN Certification = 'Y' THEN NewCerti := 'G';
                    WHEN Certification = 'Young' THEN NewCerti := 'G';
                    WHEN Certification = 'TV-G' THEN NewCerti := 'G';
                    WHEN Certification = 'TV-PG' THEN NewCerti := 'PG';
                    WHEN Certification = 'NR' THEN NewCerti := 'PG';
                    WHEN Certification = 'TV-14' THEN NewCerti := 'PG-13';
                    WHEN Certification = 'TVMA' THEN NewCerti := 'PG-13';
                    WHEN Certification = 'TV-MA' THEN NewCerti := 'PG-13';
                    WHEN Certification = 'TV-14 V' THEN NewCerti := 'PG-13';
                    WHEN Certification = '15' THEN NewCerti := 'PG-13';
                    WHEN Certification = '12' THEN NewCerti := 'PG-13';
                    WHEN Certification = ' USA:R' THEN NewCerti := 'R';
                    WHEN Certification = '16' THEN NewCerti := 'R';
                    WHEN Certification = '18' THEN NewCerti := 'NC-17';
                    WHEN Certification = 'R18' THEN NewCerti := 'NC-17';
                    WHEN Certification = 'x' THEN NewCerti := 'NC-17';
                    WHEN Certification = 'X' THEN NewCerti := 'NC-17';
                    WHEN Certification = 'XXX' THEN NewCerti := 'NC-17';
                    WHEN Certification = 'adult' THEN NewCerti := 'NC-17';
                    ELSE NewCerti := null;
                END CASE;
            ELSE
                NewCerti:=CERTIFICATION;
            END IF;
        END IF;
        RETURN NewCerti;
	EXCEPTION
		WHEN OTHERS THEN 
        dbms_output.put_line('ici');
        RAISE;
    END Analyse_Certi;

    PROCEDURE alimCB(l_movie_id IN Liste_Movie_Id)
    AS
    l_movies Liste_Movies;
    BEGIN
        FOR indx IN l_movie_id.FIRST..l_movie_id.LAST LOOP
            SELECT * INTO l_movies(indx)
            FROM movies_ext
            WHERE movies_ext.id=l_movie_id(indx);
        END LOOP;
        TraiterFilm(l_movies);
	EXCEPTION
		WHEN OTHERS THEN 
        dbms_output.put_line('ici');
        RAISE;
    END alimCB;

    PROCEDURE alimCB(NbAjout IN NUMBER)
    AS
		l_movie_id Liste_Movie_Id;
		Film movies_ext%ROWTYPE;
		i NUMBER := 1;
	BEGIN
		IF (NbAjout <= 0) THEN
			Ajout_Log_Error(CURRENT_TIMESTAMP, 'AlimCB', '-25', 'Le nombre d''ajout dans AlimCB ne peut pas etre inferieur a 0'); 
		ELSE
			FOR Film IN (select * from movies_ext order by dbms_random.value)
			LOOP
				EXIT WHEN i > NbAjout;
				l_movie_id(i) := Film.id;
				i := i + 1;
			END LOOP;
			alimCB(l_movie_id);
		END IF;
	EXCEPTION
		WHEN OTHERS THEN 
        dbms_output.put_line('ici');
        RAISE;
    END alimCB;

    PROCEDURE TraiterFilm(l_movies IN Liste_Movies)
    AS
        NewID movies_ext.id%TYPE;
        NewTitle movies_ext.title%TYPE;
        NewOriginalTitle movies_ext.Original_Title%TYPE;
        NewStatus movies_ext.Status %TYPE;
        NewVoteAverage movies_ext.Vote_Average%TYPE;
        NewVoteCount movies_ext.Vote_Count%TYPE;
        NewRuntime movies_ext.Runtime%TYPE;
        NewCertification movies_ext.Certification %TYPE;
        NewPoster movies_ext.Poster_Path%TYPE;
        NewBudget movies_ext.Budget%TYPE;
        NewTagline movies_ext.Tagline%TYPE;
        
        EXC_NEWCOPY EXCEPTION;
    BEGIN
        FOR indx IN l_movies.FIRST..l_movies.LAST LOOP

            --dbms_output.put_line(indx);
            --controle des champs
            BEGIN
                NewID:=Delete_Spaces(l_movies(indx).id);
                NewTitle:=Delete_Spaces(l_movies(indx).Title);
                NewOriginalTitle:=Delete_Spaces(l_movies(indx).Original_Title);
                NewStatus:=Delete_Spaces(l_movies(indx).Status);
                NewTagline:=Delete_Spaces(l_movies(indx).Tagline);
                NewCertification:=Delete_Spaces(l_movies(indx).Certification);

                InsertData(NewID,NewTitle,NewOriginalTitle,NewStatus,l_movies(indx).release_date,l_movies(indx).Vote_Average,
                l_movies(indx).Vote_Count,l_movies(indx).Runtime,NewCertification,l_movies(indx).Poster_PATH,l_movies(indx).Budget,NewTagline);
                TraiterGenre(l_movies(indx).id,l_movies(indx).genres);
                TraiterRealisateur(l_movies(indx).id, l_movies(indx).directors);
                TraiterActeur(l_movies(indx).id, l_movies(indx).actors);
                TraiterCopies(l_movies(indx).id);    

                --Package_VerifActeur.VerifActeur(l_movies(indx).id);
                BEGIN
                    FOR p_complexe IN 1..6 LOOP
                        package_AlimCC.AlimCC(l_movies(indx).id,p_complexe);
                    END LOOP;
                EXCEPTION
                    WHEN OTHERS THEN RAISE;   
                END;

                commit;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN 
                    Dbms_Output.Put_Line('Creation de nouvelle copie');
                WHEN OTHERS THEN 
                    Ajout_Log_Error(CURRENT_TIMESTAMP, 'AlimCB', SQLCODE, SQLERRM);
                ROLLBACK;
            END ;

        END LOOP;
	EXCEPTION
		WHEN OTHERS THEN RAISE;
    END TraiterFilm;

    PROCEDURE TraiterGenre(Movie_Id IN movies_ext.id%TYPE, genre IN movies_ext.genres%TYPE)
    AS  
        ChaineGen varchar2(25);
        idGen NUMBER;
        NomGenre varchar2(25);
        IdTemp NUMBER;
        i number:=1;
    BEGIN
        LOOP
            ChaineGen := REGEXP_SUBSTR(genre,'[^‖]+',1,i);
            EXIT WHEN ChaineGen IS NULL;
            idGen := cast(REGEXP_SUBSTR(ChaineGen,'[^․]+',1,1) as number);
            NomGenre:=SUBSTR(REGEXP_SUBSTR(ChaineGen,'[^‖]+',1,1),cast((regexp_instr(ChaineGen,'․',1,1)+1)as number));    

            BEGIN
                INSERT INTO Genres VALUES(idGen,NomGenre);
                INSERT INTO Film_Genre VALUES(idGen,Movie_Id);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    INSERT INTO Film_Genre VALUES(idGen,Movie_Id);
                    Ajout_Log_Error(CURRENT_TIMESTAMP, 'AlimCB', SQLCODE, SQLERRM);
                When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
                RAISE;
            END;

            i:=i+1;
        END LOOP;
	EXCEPTION
		WHEN OTHERS THEN Ajout_Log_Error(CURRENT_TIMESTAMP, 'AlimCB', SQLCODE, SQLERRM);
    END TraiterGenre;

    PROCEDURE TraiterRealisateur(Movie_Id IN movies_ext.id%TYPE, direct IN movies_ext.directors%TYPE)
    as
        ChainReal varchar2(4000);
        idReal NUMBER;
        NomReal varchar2(4000);
        IdTemp NUMBER;
        i number:=1;
    BEGIN    
        LOOP
            ChainReal := REGEXP_SUBSTR(direct,'[^‖]+',1,i);
            EXIT WHEN ChainReal IS NULL;
            idReal := cast(REGEXP_SUBSTR(ChainReal,'[^․]+',1,1) as number);
            NomReal:=SUBSTR(REGEXP_SUBSTR(ChainReal,'[^‖]+',1,1),cast((regexp_instr(ChainReal,'․',1,1)+1)as number));    

            BEGIN
                NomReal:=TRUNC_Chaine(NomReal,24);
                INSERT INTO ARTISTS VALUES(idReal,NomReal);
                INSERT INTO REALISER VALUES(Movie_Id,idReal);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    INSERT INTO REALISER VALUES(Movie_Id,idReal);
                    Ajout_Log_Error(CURRENT_TIMESTAMP, 'AlimCB', SQLCODE, SQLERRM);
                WHEN OTHERS THEN RAISE;
            END;

            i:=i+1;
        END loop;
    END TraiterRealisateur;

    PROCEDURE TraiterCopies (Movie_Id IN movies_ext.id%TYPE)
    AS
        NbCopies NUMBER;
    BEGIN
        NbCopies :=ABS(DBMS_RANDOM.NORMAL *3 +6);
        FOR indx IN 1..NbCopies LOOP
            INSERT INTO Films_Copies(movie) VALUES(Movie_Id);
        END LOOP;
        
        UPDATE FILMS 
        set nbcopyMax=NbCopies
        WHERE idFilm=Movie_Id;
        
    EXCEPTION
        WHEN OTHERS THEN RAISE;
    END TraiterCopies;

    PROCEDURE TraiterActeur(Movie_Id IN movies_ext.id%TYPE, act IN movies_ext.actors%TYPE)
    as
        ChainAct varchar2(4000);
        idAct NUMBER;
        NomAct varchar2(4000);
        RoleAct varchar2(4000);
        IdTemp NUMBER;
        i number:=1;
    BEGIN
        LOOP
            ChainAct := REGEXP_SUBSTR(act,'[^‖]+',1,i);
            EXIT WHEN ChainAct IS NULL;
            idAct := cast(REGEXP_SUBSTR(ChainAct,'[^․]+',1,1) as number);
            NomAct:=REGEXP_SUBSTR(ChainAct,'[^․]+',1,2);    
            RoleAct:=SUBSTR(REGEXP_SUBSTR(ChainAct,'[^‖]+',1,1),cast((regexp_instr(ChainAct,'․',1,2)+1)as number));
            RoleAct:=TRUNC_Chaine(RoleAct,24);

            BEGIN
                NomAct:=TRUNC_Chaine(NomAct,24);
                INSERT INTO ARTISTS VALUES(idAct,NomAct);
                INSERT INTO Jouer VALUES(Movie_Id,idAct,RoleAct);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    INSERT INTO Jouer VALUES(Movie_Id,idAct,RoleAct);
                    Ajout_Log_Error(CURRENT_TIMESTAMP, 'AlimCB', SQLCODE, SQLERRM);
                WHEN OTHERS THEN RAISE;
            END;

            i:=i+1;
        END loop;
    END TraiterActeur;

    PROCEDURE InsertData(Movie_Id IN movies_ext.id%TYPE , Movie_Title IN movies_ext.Title%TYPE , Movie_OriginalTitle IN
    movies_ext.Original_Title%TYPE , Movie_statut IN movies_ext.Status%TYPE,Movie_date IN movies_ext.Release_Date%TYPE 
    ,Movie_vote_avg IN movies_ext.Vote_Average%TYPE ,  Movie_vote_ct IN movies_ext.Vote_Count%TYPE , Movie_runtime IN 
    movies_ext.Runtime%TYPE , Movie_certification IN movies_ext.Certification%TYPE , movie_poster IN movies_ext.Poster_PATH%TYPE,
    movie_budget IN movies_ext.Budget%TYPE , Movie_Tagline IN movies_ext.Tagline%TYPE)
    AS
        EXC_NEWCOPY EXCEPTION;
        
        Liens_Image varchar2(150);
        CertiTemp Certifications.NomCerti%TYPE;
        CertiIdTemp Certifications.IdCerti%TYPE;
        PosterIdTemp Posters.IdPoster%TYPE;

        newCerti varchar2(5);
        newMovieTitle varchar2(43 char);
        newOriginalTitle varchar2(43 char);
        newTagLine varchar(107 char);
    BEGIN      
        BEGIN
            --Le path peut-etre null :
            IF movie_poster IS NOT NULL THEN
                Liens_Image:='http://image.tmdb.org/t/p/w185'||movie_poster;
                INSERT INTO POSTERS(PathImage,Image)VALUES(movie_poster,httpuritype(Liens_Image).getblob()) Returning IdPoster into PosterIdTemp;
            ELSE
                INSERT INTO POSTERS(PathImage,Image)VALUES(null,null);
            END IF ;
        EXCEPTION
            When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
            RAISE;
        END;

        newCerti:=Analyse_Certi(Movie_certification);
        BEGIN
            IF newCerti IS NOT NULL THEN
                SELECT IdCerti INTO CertiIdTemp
                FROM Certifications
                WHERE Nomcerti=newCerti;
            ELSIF newCerti IS NULL THEN
                SELECT IdCerti INTO CertiIdTemp
                FROM Certifications
                WHERE Nomcerti IS NULL;
            END IF ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN INSERT INTO certifications(Nomcerti) VALUES(newCerti) returning IdCerti into CertiIdTemp;
            WHEN OTHERS 
                THEN Ajout_Log_Error(CURRENT_TIMESTAMP, 'AlimCB', SQLCODE, SQLERRM);
                    Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
                    RAISE;
        END;

        newMovieTitle:=TRUNC_Chaine(Movie_Title,43);
        newOriginalTitle:=TRUNC_Chaine(Movie_OriginalTitle,43);
        newTagLine:=TRUNC_Chaine(Movie_Tagline,107);
        
        INSERT INTO Films VALUES(Movie_Id,newMovieTitle,newOriginalTitle,Movie_statut,newTagLine,Movie_date,
        Movie_vote_avg,Movie_vote_ct,CertiIdTemp,Movie_runtime,movie_budget,PosterIdTemp,0);
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
            TraiterCopies(Movie_Id);
        When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
            RAISE;
    END InsertData;
--dbms_output.put_line(Liste(indx));
END packageAlimCB;