create or replace PACKAGE packageAlimCB
IS
    TYPE Liste_Movie_Id IS TABLE OF movies_ext.id%TYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Movies   IS TABLE OF movies_ext%ROWTYPE INDEX BY BINARY_INTEGER;

    FUNCTION Delete_Spaces(chaine IN varchar2)
    RETURN varchar2;
    FUNCTION TRUNC_Chaine(chaine in varchar2 , quantile IN number)
    RETURN varchar2;
    FUNCTION Analyse_Certi(Certification IN varchar2)
    RETURN varchar2;
    PROCEDURE alimCB(l_movie_id IN Liste_Movie_Id);
    PROCEDURE alimCB(NbAjout IN NUMBER);
    
    PROCEDURE TraiterFilm(l_movies IN Liste_Movies);
    PROCEDURE TraiterGenre(Movie_Id IN movies_ext.id%TYPE, genre IN movies_ext.genres%TYPE);
    PROCEDURE TraiterRealisateur(Movie_Id IN movies_ext.id%TYPE, direct IN movies_ext.directors%TYPE);
    PROCEDURE TraiterActeur(Movie_Id IN movies_ext.id%TYPE, act IN movies_ext.actors%TYPE);
    PROCEDURE InsertData(Movie_Id IN movies_ext.id%TYPE , Movie_Title IN movies_ext.Title%TYPE , Movie_OriginalTitle IN
    movies_ext.Original_Title%TYPE , Movie_statut IN movies_ext.Status%TYPE,Movie_date IN movies_ext.Release_Date%TYPE 
    ,Movie_vote_avg IN movies_ext.Vote_Average%TYPE ,  Movie_vote_ct IN movies_ext.Vote_Count%TYPE , Movie_runtime IN 
    movies_ext.Runtime%TYPE , Movie_certification IN movies_ext.Certification%TYPE , movie_poster IN movies_ext.Poster_PATH%TYPE,
    movie_budget IN movies_ext.Budget%TYPE , Movie_Tagline IN movies_ext.Tagline%TYPE);

END packageAlimCB;