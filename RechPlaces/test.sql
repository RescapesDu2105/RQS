DECLARE
    acteurs VARCHAR2(100);
    realisateurs VARCHAR2(100);
    genres VARCHAR2(100);
    titre VARCHAR2(100);
    apex apex_t_varchar2;
    split apex_t_varchar2;
BEGIN
    acteurs := '';
    realisateurs := ''; --'IRVIN KERSHNER';
    genres := '';--'SCIENCE FICTION';
    titre := '';--'STAR';    
    
    --split := apex_string.split(acteurs, '\s*[ ]\s*');
    --DBMS_OUTPUT.PUT_LINE(split(1));
    
    PACKAGE_RECHPLACES.RecupererFilms('cc1', acteurs, realisateurs, genres, titre);
    
END;
/