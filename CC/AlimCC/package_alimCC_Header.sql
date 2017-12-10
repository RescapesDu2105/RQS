create or replace PACKAGE package_AlimCC
IS
    TYPE Liste_Copie IS TABLE OF films_copies%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE Liste_Id_Movie IS TABLE OF Films.idFilm%TYPE INDEX BY BINARY_INTEGER;
    
    PROCEDURE Take_Copy;
    FUNCTION Check_MovieDescription(l_id_film IN Liste_Id_Movie , p_complexe IN NUMBER)
    RETURN Liste_Id_Movie;
END package_AlimCC;