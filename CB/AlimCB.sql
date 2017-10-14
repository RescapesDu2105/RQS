create or replace PACKAGE packageAlimCB
IS
    TYPE Liste_Movie_Id IS TABLE OF movies_ext.id%TYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Movies   IS TABLE OF movies_ext%ROWTYPE INDEX BY BINARY_INTEGER;

    FUNCTION Delete_Spaces(chaine IN varchar2)
    RETURN varchar2;
    PROCEDURE alimCB(l_movie_id IN Liste_Movie_Id);
    --PROCEDURE alimCB(NbAjout IN NUMBER);
    
    PROCEDURE TraiterFilm(l_movies IN Liste_Movies);
    PROCEDURE TraiterGenre(Movie_Id IN movies_ext.id%TYPE, genre IN movies_ext.genres%TYPE);

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
            
            --controle des champs
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
    
    PROCEDURE TraiterGenre(Movie_Id IN movies_ext.id%TYPE, genre IN movies_ext.genres%TYPE)
    AS
        idGenre NUMBER;
        NomGenre varchar2;
    BEGIN
        select INTO idGenre,NomGenre
        cast(REGEXP_SUBSTR(genre,'[^․]+') as number) ide,
        SUBSTR(REGEXP_SUBSTR(genre,'[^‖]+'),cast((regexp_instr(genre,'․')+1)as number))as nom
        from Movies_ext
        WHERE id=Movie_Id;
        --Mettre le champs a jour + inserer
    END TraiterGenre;
    

END packageAlimCB;