create or replace PACKAGE packageAlimCB
IS
    TYPE Liste_Movie_Id IS TABLE OF movies_ext.id%TYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Movies   IS TABLE OF movies_ext%ROWTYPE INDEX BY BINARY_INTEGER;

    FUNCTION Delete_Spaces(chaine IN varchar2)
    RETURN varchar2;
    PROCEDURE alimCB(l_movie_id IN Liste_Movie_Id);
    --PROCEDURE alimCB(NbAjout IN NUMBER);
    
    PROCEDURE TraiterFilm(l_movies IN Liste_Movies);

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
       -- NewActors movies_ext.Actors%TYPE;
       -- NewDirectors movies_ext.Directors%TYPE; vu que c'est des champs a split
    BEGIN
        dbms_output.put_line('cc');
    END TraiterFilm;
        
    

END packageAlimCB;