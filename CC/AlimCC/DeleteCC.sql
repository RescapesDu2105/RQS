DECLARE
     req VARCHAR2(20000);
BEGIN
    FOR i IN 1 .. 6 LOOP
    req:='
        delete from programmations@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    
    req:='
        delete from FILMS_COPIES@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    req:='
        DELETE FROM JOUER@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    req:='
        DELETE FROM realiser@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    req:='
        DELETE FROM ARTISTS@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    req:='
        DELETE FROM Film_Genre@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    req:='
        DELETE FROM GENRES@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    req:='
        DELETE FROM films@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    req:='
        DELETE FROM certifications@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    req:='
        DELETE FROM posters@orcl@cc'||i;
        EXECUTE IMMEDIATE req;
    END loop;
    commit;
END ;
/