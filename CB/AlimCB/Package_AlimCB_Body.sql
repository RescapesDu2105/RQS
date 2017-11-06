create or replace PACKAGE BODY packageAlimCB
AS
    FUNCTION Delete_Spaces(chaine IN varchar2)RETURN varchar2 IS 
    BEGIN 
        RETURN REGEXP_REPLACE(chaine, '[[:space:]]', '' );
    END Delete_Spaces;
    
    PROCEDURE alimCB(l_movie_id IN Liste_Movie_Id)
    AS
    l_movies Liste_Movies;
    BEGIN
        --dbms_output.put_line('cc');
        FOR indx IN l_movie_id.FIRST..l_movie_id.LAST LOOP
        SELECT * INTO l_movies(indx)
        FROM movies_ext
        WHERE movies_ext.id=l_movie_id(indx);
        END LOOP;
        TraiterFilm(l_movies);
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
       -- NewGenres movies_ext.Genres%TYPE;
       -- NewActors movies_ext.Actors%TYPE;
       -- NewDirectors movies_ext.Directors%TYPE; vu que c'est des champs a split
    BEGIN
        FOR indx IN l_movies.FIRST..l_movies.LAST LOOP
            
            --controle des champs
            NewID:=Delete_Spaces(l_movies(indx).id);
            NewTitle:=Delete_Spaces(l_movies(indx).Title);
            NewOriginalTitle:=Delete_Spaces(l_movies(indx).Original_Title);
            NewStatus:=Delete_Spaces(l_movies(indx).Status);
            NewTagline:=Delete_Spaces(l_movies(indx).Tagline);
            --NewVoteAverage:=Delete_Spaces(l_movies(indx).Vote_Average);
            --NewVoteCount:=Delete_Spaces(l_movies(indx).Vote_Count);
            --NewRuntime:=Delete_Spaces(l_movies(indx).Runtime);
            NewCertification:=Delete_Spaces(l_movies(indx).Certification);
            --NewPoster:=Delete_Spaces(l_movies(indx).Poster_PATH);
            --NewBudget:=Delete_Spaces(l_movies(indx).Budget);
            --NewTagline:=Delete_Spaces(l_movies(indx).Tagline);
            
            InsertData(NewID,NewTitle,NewOriginalTitle,NewStatus,l_movies(indx).release_date,l_movies(indx).Vote_Average,
            l_movies(indx).Vote_Count,l_movies(indx).Runtime,NewCertification,l_movies(indx).Poster_PATH,l_movies(indx).Budget,NewTagline);
            TraiterGenre(l_movies(indx).id,l_movies(indx).genres);
            --dbms_output.put_line('ok : '|| indx );
            TraiterRealisateur(l_movies(indx).id, l_movies(indx).directors);
            TraiterActeur(l_movies(indx).id, l_movies(indx).actors);
                    
        END LOOP;
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
                SELECT IdGenre into IdTemp
                FROM GENRES
                WHERE IdGenre=idGen ;
                
                INSERT INTO Film_Genre VALUES(idGen,Movie_Id);
                commit;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                INSERT INTO Genres VALUES(idGen,NomGenre);
                INSERT INTO Film_Genre VALUES(idGen,Movie_Id);
                commit;
            END ;
            i:=i+1;
        END LOOP;
    EXCEPTION
        When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
    END TraiterGenre;
    
    PROCEDURE TraiterRealisateur(Movie_Id IN movies_ext.id%TYPE, direct IN movies_ext.directors%TYPE)
    as
        ChainReal varchar2(25);
        idReal NUMBER;
        NomReal varchar2(25);
        IdTemp NUMBER;
        i number:=1;
    BEGIN    
        LOOP
            ChainReal := REGEXP_SUBSTR(direct,'[^‖]+',1,i);
            EXIT WHEN ChainReal IS NULL;
            idReal := cast(REGEXP_SUBSTR(ChainReal,'[^․]+',1,1) as number);
            NomReal:=SUBSTR(REGEXP_SUBSTR(ChainReal,'[^‖]+',1,1),cast((regexp_instr(ChainReal,'․',1,1)+1)as number));    
            
            BEGIN
                SELECT IdArt into IdTemp
                FROM ARTISTS
                WHERE IdArt=idReal ;
                
                INSERT INTO REALISER VALUES(Movie_Id,idReal);
                commit;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                INSERT INTO ARTISTS VALUES(idReal,NomReal);
                INSERT INTO REALISER VALUES(Movie_Id,idReal);
                commit;
            END ;
            i:=i+1;
        END loop;
    END TraiterRealisateur;
    
    PROCEDURE TraiterActeur(Movie_Id IN movies_ext.id%TYPE, act IN movies_ext.actors%TYPE)
    as
        ChainAct varchar2(255);
        idAct NUMBER;
        NomAct varchar2(25);
        RoleAct varchar2(25);
        IdTemp NUMBER;
        i number:=1;
    BEGIN
        LOOP
            ChainAct := REGEXP_SUBSTR(act,'[^‖]+',1,i);
            EXIT WHEN ChainAct IS NULL;
            idAct := cast(REGEXP_SUBSTR(ChainAct,'[^․]+',1,1) as number);
            NomAct:=REGEXP_SUBSTR(ChainAct,'[^․]+',1,2);    
            RoleAct:=SUBSTR(REGEXP_SUBSTR(ChainAct,'[^‖]+',1,1),cast((regexp_instr(ChainAct,'․',1,2)+1)as number));
            
            BEGIN
                SELECT IdArt into IdTemp
                FROM ARTISTS
                WHERE IdArt=idAct ;
                
                INSERT INTO Jouer VALUES(Movie_Id,idAct,RoleAct);
                commit;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                INSERT INTO ARTISTS VALUES(idAct,NomAct);
                INSERT INTO Jouer VALUES(Movie_Id,idAct,RoleAct);
                commit;
                When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
            END ;
            i:=i+1;
        END loop;
    commit;
    END TraiterActeur;
    
    PROCEDURE InsertData(Movie_Id IN movies_ext.id%TYPE , Movie_Title IN movies_ext.Title%TYPE , Movie_OriginalTitle IN
    movies_ext.Original_Title%TYPE , Movie_statut IN movies_ext.Status%TYPE,Movie_date IN movies_ext.Release_Date%TYPE 
    ,Movie_vote_avg IN movies_ext.Vote_Average%TYPE ,  Movie_vote_ct IN movies_ext.Vote_Count%TYPE , Movie_runtime IN 
    movies_ext.Runtime%TYPE , Movie_certification IN movies_ext.Certification%TYPE , movie_poster IN movies_ext.Poster_PATH%TYPE,
    movie_budget IN movies_ext.Budget%TYPE , Movie_Tagline IN movies_ext.Tagline%TYPE)
    AS
        Liens_Image varchar2(150);
        StatusTemp status.NomStatus%TYPE;
        StatusIdTemp status.IdStatus%TYPE;
        CertiTemp Certifications.NomCerti%TYPE;
        CertiIdTemp Certifications.IdCerti%TYPE;
        PosterIdTemp Posters.IdPoster%TYPE;
    BEGIN
        --Verif des status :
        BEGIN
            SELECT status.NomStatus into StatusTemp
            FROM status
            WHERE status.NomStatus=Movie_statut;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN INSERT INTO Status(NomStatus) Values(Movie_statut);
            --When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
        END ;
        
        --Le path peut-etre null :
        IF movie_poster IS NOT NULL THEN
            Liens_Image:='http://image.tmdb.org/t/p/w185'||movie_poster;
            INSERT INTO POSTERS(PathImage,Image)VALUES(movie_poster,httpuritype(Liens_Image).getblob());
        ELSE
            INSERT INTO POSTERS(PathImage,Image)VALUES(null,null);
        END IF ;
        --Trier les certification ou déclencheur
        BEGIN
            SELECT IdCerti INTO CertiIdTemp
            FROM Certifications
            WHERE Nomcerti='G';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN INSERT INTO Certifications(Nomcerti) VALUES('G');
            --When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
        END;
        --Afin de pouvoir aller rechercher les id "generer"
        commit;
        
        --Recuperation des id "generer"
        SELECT IdStatus INTO StatusIdTemp
        FROM Status
        WHERE NomStatus=Movie_statut;
        --/!\ valeur modifier par déclencheur
        SELECT IdCerti INTO CertiIdTemp
        FROM Certifications
        WHERE Nomcerti='G';
        SELECT IdPoster INTO PosterIdTemp
        FROM Posters
        WHERE PathImage=movie_poster;
        
        INSERT INTO Films VALUES(Movie_Id,Movie_Title,Movie_OriginalTitle,StatusIdTemp,Movie_Tagline,Movie_date,
        Movie_vote_avg,Movie_vote_ct,CertiIdTemp,Movie_runtime,movie_budget,PosterIdTemp);
        commit;
    EXCEPTION
        When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
    END InsertData;

END packageAlimCB;