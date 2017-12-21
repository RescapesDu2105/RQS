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
    
    PACKAGE_RECHPLACES.RecupererFilms('cc1', acteurs, realisateurs, genres, titre);
    
END;
/