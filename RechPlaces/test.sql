CREATE OR REPLACE PROCEDURE Test(NomTable IN VARCHAR2)
IS
    requete VARCHAR2(512);
    TYPE t_collection IS TABLE OF FILMS@orcl@cc1%ROWTYPE INDEX BY BINARY_INTEGER;
    l_collection t_collection;
BEGIN
    requete := 'SELECT * FROM Films@orcl@' || NomTable; 
    
    EXECUTE IMMEDIATE requete BULK COLLECT INTO l_collection;     

    FOR i in l_collection.first..l_collection.last LOOP
        DBMS_OUTPUT.PUT_LINE(l_collection(i).Titre);
    END LOOP;
END Test;    
/

DECLARE
    
    
    
BEGIN

    Test('cc1');

EXCEPTION
    WHEN OTHERS THEN RAISE;

END;
/

/*
SELECT * 
FROM Films@orcl@cc1;
*/