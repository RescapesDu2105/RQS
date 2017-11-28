CREATE OR REPLACE PACKAGE Package_VerifActeur
IS
    req UTL_HTTP.REQ;
    res UTL_HTTP.RESP;
    reponse VARCHAR(4000);

    actJSON CLOB ;

    TYPE ActeurRec IS RECORD (
        IdAct           Jouer.Artist%TYPE,
        NomAct          PEOPLE_EXT.Name%TYPE,
        DateNaiss       VARCHAR2(10),
        DateDeces       VARCHAR2(10),
        LieuNaiss       PEOPLE_EXT.PLACE_OF_BIRTH%TYPE,
        Profil          PEOPLE_EXT.PROFILE_PATH%TYPE,
       -- Biography       PEOPLE_EXT.BIOGRAPHY%TYPE,
        RoleFilm        Jouer.Role%TYPE
    );
    TYPE Liste_Acteurs IS TABLE OF ActeurRec INDEX BY BINARY_INTEGER;
    l_Acteurs Liste_Acteurs;

    TYPE FilmRec IS RECORD (
        IdFilm          Films.IdFilm%TYPE,
        TitreFilm       Films.Titre%TYPE,
        AnneeSortie     NUMBER(4)
    );
    vFilm FilmRec;
    
    PROCEDURE VerifActeur(p_Id_Film IN Jouer.Film%type);
    PROCEDURE Rollback_Mongo(p_indx IN NUMBER);
    
END Package_VerifActeur;
/

CREATE OR REPLACE PACKAGE BODY Package_VerifActeur
AS    
    PROCEDURE Rollback_Mongo(p_indx IN NUMBER)
    IS        
    BEGIN
        FOR indx IN l_Acteurs.FIRST..p_indx LOOP
            APEX_JSON.initialize_clob_output;
            APEX_JSON.open_object;
            APEX_JSON.write('requete', 'remove');

            APEX_JSON.open_object('informations');  
            APEX_JSON.write('_id', l_Acteurs(indx).IdAct);
            APEX_JSON.write_raw('name', '"' || l_Acteurs(indx).NomAct || '"');
            APEX_JSON.write('birthday', l_Acteurs(indx).DateNaiss);
            APEX_JSON.write_raw('place_of_birth', '"' || l_Acteurs(indx).LieuNaiss || '"');                 

            APEX_JSON.open_array('films');    
            APEX_JSON.open_object;
            APEX_JSON.write('_id', vFilm.IdFilm);
            APEX_JSON.write_raw('titre', '"' || vFilm.TitreFilm || '"');
            APEX_JSON.write('release_date', vFilm.AnneeSortie);
            APEX_JSON.write_raw('character', '"' || l_Acteurs(indx).RoleFilm || '"'); 
            APEX_JSON.close_object;
            APEX_JSON.close_array;

            APEX_JSON.close_object;   
            APEX_JSON.close_object; 
            
           -- DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);
            
            actJSON := APEX_JSON.get_clob_output;
            APEX_JSON.free_output;
            
            req := utl_http.begin_request('http://10.0.2.2:8084/VerifActeur_v2', 'POST',' HTTP/1.1');
            utl_http.set_header(req, 'content-type', 'application/json');
            utl_http.set_header(req, 'Content-Length', length(actJSON));
            utl_http.write_text(req, actJSON);
            res := utl_http.get_response(req);
            UTL_HTTP.END_RESPONSE(res);
            
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN RAISE;
    END Rollback_Mongo;

    PROCEDURE VerifActeur(p_Id_Film IN Jouer.Film%type)
    IS
        Exc_Test EXCEPTION;
    BEGIN
        SELECT IdFilm, Titre, EXTRACT(YEAR FROM DATE_REAL) INTO vFilm.IdFilm, vFilm.TitreFilm, vFilm.AnneeSortie
        FROM Films
        WHERE IdFilm = p_Id_Film;

        SELECT  
            Peop.Id,
            Peop.Name, 
            COALESCE(TO_CHAR(Peop.BIRTHDAY, 'YYYY-MM-DD'), ''), 
            COALESCE(TO_CHAR(Peop.DEATHDAY, 'YYYY-MM-DD'), ''),
            Peop.PLACE_OF_BIRTH,
            Peop.PROFILE_PATH,
            --Peop.Biography,
            J.role as Role
            BULK COLLECT INTO l_Acteurs
        FROM PEOPLE_EXT Peop 
        INNER JOIN Jouer J
            ON J.ARTIST = Peop.Id
        INNER JOIN Films F
            ON J.film=F.idfilm
        WHERE film=p_Id_Film;
        
        DECLARE
            indx NUMBER := l_Acteurs.FIRST;
        BEGIN
            LOOP
                APEX_JSON.initialize_clob_output;
                APEX_JSON.open_object;
                /*APEX_JSON.write('requete', 'verification');
                IF(indx = 3) THEN
                    RAISE_APPLICATION_ERROR('-20002', 'Je teste');
                END IF;  */

                APEX_JSON.open_object('informations');  
                APEX_JSON.write('_id', l_Acteurs(indx).IdAct);
                APEX_JSON.write_raw('name', '"' || l_Acteurs(indx).NomAct || '"');
                APEX_JSON.write('birthday', l_Acteurs(indx).DateNaiss);
                APEX_JSON.write_raw('place_of_birth', '"' || l_Acteurs(indx).LieuNaiss || '"');                 

                APEX_JSON.open_array('films');    
                APEX_JSON.open_object;
                APEX_JSON.write('_id', vFilm.IdFilm);
                APEX_JSON.write_raw('titre', '"' || vFilm.TitreFilm || '"');
                APEX_JSON.write('release_date', vFilm.AnneeSortie);
                APEX_JSON.write_raw('character', '"' || l_Acteurs(indx).RoleFilm || '"'); 
                APEX_JSON.close_object;
                APEX_JSON.close_array;

                APEX_JSON.close_object;   
                APEX_JSON.close_object;   

                --DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);
                DBMS_OUTPUT.put_line(l_Acteurs(indx).IdAct);

                actJSON := APEX_JSON.get_clob_output;
                APEX_JSON.free_output;

                req := utl_http.begin_request('http://10.0.2.2:8084/VerifActeur_v2', 'POST',' HTTP/1.1');
                utl_http.set_header(req, 'content-type', 'application/json');
                utl_http.set_header(req, 'Content-Length', length(actJSON));
                utl_http.write_text(req, actJSON);
                res := utl_http.get_response(req);
                UTL_HTTP.END_RESPONSE(res);

                EXIT WHEN indx = l_Acteurs.LAST;
                indx := l_Acteurs.NEXT(indx);

            END LOOP;
        EXCEPTION        
            WHEN OTHERS THEN
                Rollback_Mongo(indx);
                RAISE;
        END;
        
    EXCEPTION
        WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN
            UTL_HTTP.END_RESPONSE(res);
    END VerifActeur;
    
END Package_VerifActeur;
/