create or replace PACKAGE package_AlimCC
IS
    TYPE Liste_Copie IS TABLE OF films_copies%ROWTYPE INDEX BY BINARY_INTEGER;  
    TYPE Liste_Films_Copies IS TABLE OF Films_Copies%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_JOUER IS TABLE OF JOUER%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Artists IS TABLE OF Artists%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Film_Genre IS TABLE OF Film_Genre%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_genres IS TABLE OF genres%ROWTYPE INDEX BY BINARY_INTEGER;
    l_artists Liste_Artists;
    l_jouer Liste_Jouer;
    l_film_genre Liste_Film_Genre;
    l_copie Liste_Copie;
    l_genres Liste_Genres;
    
    films_temp Films%ROWTYPE;
    certifications_temp Certifications%ROWTYPE;
    posters_temp posters%ROWTYPE;
    realiser_temp REALISER%ROWTYPE;
    
    PROCEDURE AlimCC(p_idFilm IN NUMBER);
    PROCEDURE Take_Copy(p_idFilm IN NUMBER , nbCopy IN NUMBER);
    PROCEDURE Recup_Data(p_idFilm IN NUMBER);
    PROCEDURE Insert_Data(p_complexe IN NUMBER);
    PROCEDURE Send_Copy(p_complexe IN NUMBER);
    
    FUNCTION Info_Connue(p_idFilm IN NUMBER , p_complexe IN NUMBER)
        RETURN boolean;
    FUNCTION Generate_Number_Copy(p_idFilm IN NUMBER)
        RETURN NUMBER;
END package_AlimCC;