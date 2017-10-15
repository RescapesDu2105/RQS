create or replace PACKAGE packageAlimCB
IS
    
    Type Actors_Record IS RECORD(
    idAct NUMBER,
    NomAct varchar2(50),
    RoleAct varchar2(50));
    Type Liste_Actors IS TABLE OF Actors_Record INDEX BY Binary_Integer;    
    
    TYPE Liste_Movie_Id IS TABLE OF movies_ext.id%TYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Movies   IS TABLE OF movies_ext%ROWTYPE INDEX BY BINARY_INTEGER;

    FUNCTION Delete_Spaces(chaine IN varchar2)
    RETURN varchar2;
    PROCEDURE alimCB(l_movie_id IN Liste_Movie_Id);
    --PROCEDURE alimCB(NbAjout IN NUMBER);
    
    PROCEDURE TraiterFilm(l_movies IN Liste_Movies);
    PROCEDURE TraiterGenre(Movie_Id IN movies_ext.id%TYPE, genre IN movies_ext.genres%TYPE);
    PROCEDURE TraiterRealisateur(Movie_Id IN movies_ext.id%TYPE, direct IN movies_ext.directors%TYPE);
    PROCEDURE TraiterActeur(Movie_Id IN movies_ext.id%TYPE, act IN movies_ext.actors%TYPE);

END packageAlimCB;