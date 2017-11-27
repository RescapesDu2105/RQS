CREATE OR REPLACE PROCEDURE Rollback_Mongo(Id_Film IN Jouer.Film%type, p_indx IN NUMBER)
IS
    req UTL_HTTP.REQ;
    res UTL_HTTP.RESP;
    reponse VARCHAR(4000);

    actJSON CLOB ;
    
    l_cursor SYS_REFCURSOR;

    vIdAct          Jouer.Artist%TYPE;
    vNomAct         PEOPLE_EXT.Name%TYPE;
    vDateNaiss      VARCHAR2(10);
    vDateDeces      VARCHAR2(10);
    vLieuNaiss      PEOPLE_EXT.PLACE_OF_BIRTH%TYPE;
    vProfil         PEOPLE_EXT.PROFILE_PATH%TYPE;

    TYPE FilmRec IS RECORD (
        vIdFilm         Films.IdFilm%TYPE,
        vTitreFilm      Films.Titre%TYPE,
        vAnneeSortie    NUMBER(4),
        vRole           Jouer.Role%TYPE);
    vFilm FilmRec;
    
    TYPE Liste_Acteurs_Id IS TABLE OF Jouer.Artist%TYPE INDEX BY BINARY_INTEGER;
    l_Act_Id Liste_Acteurs_Id;
BEGIN
    FOR indx IN l_Act_Id.FIRST..p_indx LOOP
        APEX_JSON.initialize_clob_output;
        APEX_JSON.open_object;
        APEX_JSON.write('requete', 'rollback');
        
        APEX_JSON.open_object;
    
        SELECT  
            J.ARTIST as Id,
            Peop.Name as Nom, 
            TO_CHAR(Peop.BIRTHDAY, 'YYYY-MM-DD') as DateNaiss, 
            TO_CHAR(Peop.DEATHDAY, 'YYYY-MM-DD') as DateDeces,
            Peop.PLACE_OF_BIRTH as LieuNaiss,
            Peop.PROFILE_PATH as Profil
            INTO vIdAct, vNomAct, vDateNaiss, vDateDeces, vLieuNaiss, vProfil
        from PEOPLE_EXT Peop JOIN Jouer J
        ON J.ARTIST = Peop.Id
        WHERE id=l_Act_Id(indx)
        AND film=Id_Film;
    
        APEX_JSON.write('_id', vIdAct);
        APEX_JSON.write_raw('name', '"' || vNomAct || '"');
        APEX_JSON.write('birthday', vDateNaiss);
        APEX_JSON.write_raw('place_of_birth', '"' || vLieuNaiss  || '"'); 
        
        SELECT     
            tb.IdFilm AS Id, 
            tb.Titre as Titre,
            EXTRACT(YEAR FROM tb.DATE_REAL) as AnneeSortie,
            tb.role as Role
            INTO vFilm
        FROM(
            SELECT *
            FROM Jouer JOIN FILMS
            ON Jouer.film=films.idfilm
            WHERE Jouer.ARTIST=l_Act_Id(indx)) tb
        WHERE tb.film=Id_Film;
        
        APEX_JSON.open_array('films');    
        APEX_JSON.open_object;
        APEX_JSON.write('_id', vFilm.vIdFilm);
        APEX_JSON.write_raw('titre', '"' || vFilm.vTitreFilm || '"');
        APEX_JSON.write('release_date', vFilm.vAnneeSortie);
        APEX_JSON.write_raw('character', '"' || vFilm.vRole || '"'); 
        APEX_JSON.close_object;
        APEX_JSON.close_array;
        
        APEX_JSON.close_object;   
        APEX_JSON.close_object;   
        
        DBMS_OUTPUT.put_line(APEX_JSON.get_clob_output);
        
        actJSON := APEX_JSON.get_clob_output;
        APEX_JSON.free_output;
          
        req := utl_http.begin_request('http://10.0.2.2:8084/VerifActeur_v1', 'POST',' HTTP/1.1');
        utl_http.set_header(req, 'content-type', 'application/json');
        utl_http.set_header(req, 'Content-Length', length(actJSON));
        utl_http.write_text(req, actJSON);
        res := utl_http.get_response(req);
        UTL_HTTP.END_RESPONSE(res);
        
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN RAISE;
END;
/