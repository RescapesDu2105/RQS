

create or replace PACKAGE BODY packageAlimCB

    FUNCTION Delete_Spaces(chaine varchar2)RETURN varchar2 IS 
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
        NewOriginalTitle movies_ext.OriginalTitl%TYPE;
        NewStatus movies_ext.Status %TYPE;
        NewVoteAverage movies_ext.VoteAverage%TYPE;
        NewVoteCount movies_ext.VoteCount%TYPE;
        NewRuntime movies_ext.Runtime%TYPE;
        NewCertification movies_ext.Certification %TYPE;
        NewPoster movies_ext.Poster_Path%TYPE;
        NewBudget movies_ext.Budget%TYPE;
        NewTagline movies_ext.Tagline%TYPE;
       -- NewActors movies_ext.Actors%TYPE;
       -- NewDirectors movies_ext.Directors%TYPE; vu que c'est des champs a split
    BEGIN
        dbms_output.put_line('cc');
    END TraiterFilm;
        
    

END packageAlimCB;

create or replace PACKAGE BODY packageAlimCB

    FUNCTION Delete_Spaces(chaine varchar2)RETURN varchar2 IS 
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
        NewOriginalTitle movies_ext.OriginalTitl%TYPE;
        NewStatus movies_ext.Status %TYPE;
        NewVoteAverage movies_ext.VoteAverage%TYPE;
        NewVoteCount movies_ext.VoteCount%TYPE;
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
            
            NewID:=Delete_Spaces(l_movies(indx).id);
            NewTitle:=Delete_Spaces(l_movies(indx).Title);
            NewOriginalTitle:=Delete_Spaces(l_movies(indx).OriginalTitle);
            NewStatus:=Delete_Spaces(l_movies(indx).Status);
            NewVoteAverage:=Delete_Spaces(l_movies(indx).VoteAverage);
            NewVoteCount:=Delete_Spaces(l_movies(indx).VoteCount);
            NewRuntime:=Delete_Spaces(l_movies(indx).Runtime);
            NewCertification:=Delete_Spaces(l_movies(indx).Certification);
            NewPoster:=Delete_Spaces(l_movies(indx).Poster_PATH);
            NewBudget:=Delete_Spaces(l_movies(indx).Budget);
            NewTagline:=Delete_Spaces(l_movies(indx).Tagline);
                    
        END LOOP;
    END TraiterFilm;
        
    

END packageAlimCB;