create or replace PACKAGE package_AlimCC
IS
    TYPE Liste_Copie IS TABLE OF films_copies%ROWTYPE INDEX BY BINARY_INTEGER;
    
    PROCEDURE Take_Copy;
    PROCEDURE Check_MovieDescription(l_copy IN Liste_Copie , p_complexe IN NUMBER);
END package_AlimCC;