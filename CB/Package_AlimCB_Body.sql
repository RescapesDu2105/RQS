create or replace PACKAGE BODY packageAlimCB
AS
    FUNCTION Delete_Spaces(chaine IN varchar2)RETURN varchar2 IS 
    BEGIN 
        RETURN REGEXP_REPLACE(chaine, '[[:space:]]', '' );
    END Delete_Spaces;
    
    PROCEDURE alimCB(l_movie_id IN Liste_Movie_Id)
    AS
    BEGIN
        dbms_output.put_line('cc');
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
            --NewVoteAverage:=Delete_Spaces(l_movies(indx).Vote_Average);
            --NewVoteCount:=Delete_Spaces(l_movies(indx).Vote_Count);
            --NewRuntime:=Delete_Spaces(l_movies(indx).Runtime);
            NewCertification:=Delete_Spaces(l_movies(indx).Certification);
            --NewPoster:=Delete_Spaces(l_movies(indx).Poster_PATH);
            --NewBudget:=Delete_Spaces(l_movies(indx).Budget);
            --NewTagline:=Delete_Spaces(l_movies(indx).Tagline);
            
            InsertData(NewID,NewTitle,NewOriginalTitle,NewStatus,l_movies(indx).release_date,l_movies(indx).Vote_Average,
            l_movies(indx).Vote_Count,l_movies(indx).Runtime,NewCertification,l_movies(indx).Poster_PATH,l_movies(indx).Budget,l_movies(indx).Tagline);
            TraiterGenre(l_movies(indx).id,l_movies(indx).genres);
            TraiterRealisateur(l_movies(indx).id, l_movies(indx).directors);
            TraiterActeur(l_movies(indx).id, l_movies(indx).actors);
                    
        END LOOP;
    END TraiterFilm;
    
    PROCEDURE TraiterGenre(Movie_Id IN movies_ext.id%TYPE, genre IN movies_ext.genres%TYPE)
    AS
        idGenre NUMBER;
        NomGenre varchar2(25);
        GenTemp genres%ROWTYPE ;
    BEGIN
        select 
        cast(REGEXP_SUBSTR(genre,'[^․]+') as number) ide,
        SUBSTR(REGEXP_SUBSTR(genre,'[^‖]+'),cast((regexp_instr(genre,'․')+1)as number))as nom
        INTO idGenre,NomGenre
        from Movies_ext
        WHERE id=Movie_Id;
        
        select genres.IdGenre, genres.NomGenre into GenTemp
        FROM genres 
        Where genres.IdGenre=idGenre;
        --Traiter les champs pour mettre les bonnes valeurs
        
        IF GenTemp.IdGenre IS NULL THEN
            INSERT INTO Genres VALUES(idGenre,NomGenre);
            commit;
        END IF ;
    END TraiterGenre;
    
    PROCEDURE TraiterRealisateur(Movie_Id IN movies_ext.id%TYPE, direct IN movies_ext.directors%TYPE)
    as
        idReal NUMBER;
        NomReal varchar2(50);
    BEGIN    
        select 
        cast(REGEXP_SUBSTR(direct,'[^․]+') as number) ide,
        SUBSTR(REGEXP_SUBSTR(direct,'[^‖]+'),cast((regexp_instr(direct,'․')+1)as number))as nom
        INTO idReal,NomReal
        from Movies_ext
        WHERE id=Movie_Id;
        
        INSERT INTO Realiser VALUES(Movie_Id,idReal);
        INSERT INTO Artists values(idReal,NomReal);
        commit;
        
    END TraiterRealisateur;
    
    PROCEDURE TraiterActeur(Movie_Id IN movies_ext.id%TYPE, act IN movies_ext.actors%TYPE)
    as
        l_actors Liste_Actors;
        Actor_Name varchar2(50);
        Actor_Role varchar2(50);
        
    BEGIN    
        with split(champs, debut, fin) as 
        (
            Select actors , 1 debut, instr(actors,'‖') fin 
            from movies_ext
            where id=Movie_Id
            union all
            select champs, fin + 1, instr(champs, '‖', fin+1)
            from split
            where fin <> 0
        )
        select distinct
        cast(substr(tuple, 1, instr(tuple, '․') -1) as number) ide,
        SUBSTR(tuple, instr(tuple, '․')+1, instr(tuple, '․', 1, 2) - instr(tuple, '․')-1) actors,
        substr(tuple, instr(tuple, '․', 1, 2)+1, LENGTH(tuple) - instr(tuple, '․', 1, 2)) roles
        BULK COLLECT INTO l_actors
        from(
            SELECT SUBSTR(champs, debut, coalesce(fin, length(champs)+1) - debut) tuple
            FROM split -- 1.593.318
            WHERE champs IS NOT NULL --1.456.115
            );
            
     FOR i IN l_actors.FIRST..l_actors.LAST LOOP
        Actor_Name:=Delete_Spaces(l_actors(i).NomAct);
        Actor_Role:=Delete_Spaces(l_actors(i).RoleAct);
        
        INSERT INTO Jouer VALUES(Movie_Id,l_actors(i).idAct,Actor_Role);
        INSERT INTO Artists VALUES(l_actors(i).idAct,Actor_Name);
     END LOOP;
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
        CertiTemp Certifications.IdCerti%TYPE;
        PosterTemp Posters.PathImage%TYPE;
    BEGIN
        --Verif des status :
        SELECT status.NomStatus into StatusTemp
        FROM status
        WHERE status.NomStatus=Movie_statut;
        IF StatusTemp IS NULL THEN 
            INSERT INTO Status(NomStatus) Values(Movie_statut);
        END IF ;
        
        Liens_Image:='http://image.tmdb.org/t/p/w185'||movie_poster;
        INSERT INTO POSTERS(PathImage,Image)VALUES(movie_poster,httpuritype(Liens_Image).getblob());
        --Trier les certification ou déclencheur
        INSERT INTO Certifications(Nomcerti) VALUES(Movie_certification);
        --Afin de pouvoir aller rechercher les id "generer"
        commit;
        
        --Recuperation des id "generer"
        SELECT NomStatus INTO StatusTemp
        FROM Status
        WHERE NomStatus=Movie_statut;
        --/!\ valeur modifier par déclencheur
        SELECT Nomcerti INTO CertiTemp
        FROM Certifications
        WHERE Nomcerti=Movie_certification;
        SELECT IdPoster INTO PosterTemp
        FROM Posters
        WHERE PathImage=movie_poster;
        
        INSERT INTO Films VALUES(Movie_Id,Movie_Title,Movie_OriginalTitle,Movie_statut,Movie_Tagline,Movie_date,
        Movie_vote_avg,Movie_vote_ct,Movie_certification,Movie_runtime,movie_budget,movie_poster);
        commit;
    END InsertData;

END packageAlimCB;