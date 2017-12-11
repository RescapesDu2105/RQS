create or replace PACKAGE package_AlimCC
IS
    TYPE Liste_Copie IS TABLE OF films_copies%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Id_Movie IS TABLE OF Films.idFilm%TYPE INDEX BY BINARY_INTEGER;
    
    TYPE Liste_Films IS TABLE OF Films%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Artists IS TABLE OF Artists%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Certifications IS TABLE OF Certifications%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_genres IS TABLE OF genres%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_posters IS TABLE OF posters%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_REALISER IS TABLE OF REALISER%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Film_Genre IS TABLE OF Film_Genre%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_JOUER IS TABLE OF JOUER%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Films_Copies IS TABLE OF Films_Copies%ROWTYPE INDEX BY BINARY_INTEGER;
    l_films Liste_Films;
    l_certification Liste_Certifications;
    l_artists Liste_Artists;
    l_genres Liste_Genres;
    l_posters Liste_Posters;
    l_realiser Liste_Realiser;
    l_film_genre Liste_Film_Genre;
    l_jouer Liste_Jouer;
    
    PROCEDURE Take_Copy;
    FUNCTION Check_MovieDescription(l_id_film IN Liste_Id_Movie , p_complexe IN NUMBER)
    RETURN Liste_Id_Movie;
    PROCEDURE Recup_Data(l_id_film IN Liste_Id_Movie);
END package_AlimCC;