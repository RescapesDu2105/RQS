create or replace PROCEDURE VerifActeur(IdAct IN Artists.idArt%type)
IS
    TYPE Fiche_Acteur IS RECORD(
        id NUMBER(7,0),
        Nom VARCHAR2(2000 CHAR),
        DateAnnif VARCHAR2(10 CHAR),
        DateDeces VARCHAR2(10 CHAR),
        LieuNaiss VARCHAR2(2000 CHAR),
        Image VARCHAR2(100 CHAR));
    f_Acteur Fiche_Acteur;

    TYPE Biography_Rec IS RECORD(
        id NUMBER(7,0),
        Titre VARCHAR2(60 CHAR),
        Annee_Sortie NUMBER(4));
    Biography Biography_Rec;

   -- x   UTL_HTTP.HTML_PIECES;
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

    vIdFilm         Films.IdFilm%TYPE;
    vTitreFilm      Films.Titre%TYPE;
    vAnneeSortie    NUMBER(4);
    vRole           Jouer.Role%TYPE;
BEGIN

   /* 
    APEX_JSON.initialize_clob_output;
   
   OPEN l_cursor FOR
    select  
            J.ARTIST as Id,
            Peop.Name as Nom, 
            TO_CHAR(Peop.BIRTHDAY, 'YYYY-MM-DD') as DateNaiss, 
            TO_CHAR(Peop.DEATHDAY, 'YYYY-MM-DD') as DateDeces,
            Peop.PLACE_OF_BIRTH as LieuNaiss,
            Peop.PROFILE_PATH as Profil,
            cursor(
                SELECT 
                    F2.IdFilm AS Id, 
                    F2.Titre as Titre,
                    TO_CHAR(F2.DATE_REAL, 'YYYY') as AnneeSortie,
                    J2.role as Role 
                    FROM FILMS F2, Jouer J2 , PEOPLE_EXT Peop2
                    WHERE J2.Film = F2.idFilm
                    AND Peop2.id=J2.ARTIST
                    AND Peop2.id=IdAct) AS Films            
    from PEOPLE_EXT Peop JOIN Jouer J
    ON J.ARTIST = Peop.Id
    WHERE id=IdAct;
    
    
    APEX_JSON.open_object;
    APEX_JSON.write(l_cursor);
    APEX_JSON.close_object;
    */
    

    APEX_JSON.initialize_clob_output;
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
    WHERE id=IdAct;

    APEX_JSON.write('_id', vIdAct);
    APEX_JSON.write_raw('name', '"' || vNomAct || '"');
    APEX_JSON.write('birthday', vDateNaiss);
    APEX_JSON.write_raw('place_of_birth', '"' || vLieuNaiss  || '"'); 
    
    SELECT 
        F2.IdFilm AS Id, 
        F2.Titre as Titre,
        EXTRACT(YEAR FROM F2.DATE_REAL) as AnneeSortie,
        J2.role as Role 
    INTO vIdFilm, vTitreFilm, vAnneeSortie, vRole
    FROM FILMS F2, Jouer J2 , PEOPLE_EXT Peop2
    WHERE J2.Film = F2.idFilm
    AND Peop2.id=J2.ARTIST
    AND Peop2.id=IdAct;

    APEX_JSON.open_array('films');    
    APEX_JSON.open_object;
    APEX_JSON.write('_id', vIdFilm);
    APEX_JSON.write_raw('titre', '"' || vTitreFilm || '"');
    APEX_JSON.write('release_date', vAnneeSortie);
    APEX_JSON.write_raw('character', '"' || vRole || '"'); 
    APEX_JSON.close_object;
    APEX_JSON.close_array;
    
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
    
    /*SELECT ID , Name, TO_CHAR(BIRTHDAY, 'YYYY-MM-DD'), TO_CHAR(DEATHDAY, 'YYYY-MM-DD'),PLACE_OF_BIRTH,PROFILE_PATH INTO f_Acteur
    FROM PEOPLE_EXT
    WHERE id=IdAct;

    actJSON:='VERIFICATION#'||f_Acteur.id;
    req := utl_http.begin_request('http://10.0.2.2:8084/VerifActeur_v1/VerifActeur_v1', 'POST',' HTTP/1.1');
    utl_http.set_header(req, 'content-type', 'application/json');
    utl_http.set_header(req, 'Content-Length', length(actJSON));
    utl_http.write_text(req, actJSON);
    res := utl_http.get_response(req);
    UTL_HTTP.READ_TEXT(res, reponse);
    UTL_HTTP.END_RESPONSE(res);
    Dbms_Output.Put_Line(reponse); 
    if reponse LIKE '%ko%'
    THEN
        SELECT IdFilm , Titre , EXTRACT(YEAR FROM Date_Real) INTO Biography
        FROM films
        Where IdFilm IN(
            SELECT film
            FROM jouer
            WHERE artist=IdAct)
        AND ROWNUM=1;
        actJSON :='INSERTION#'||
                '{'||
                ' "_idAct": ' || f_Acteur.id ||','||
                ' "nom": "'|| f_Acteur.nom ||'",'||
                ' "DateAnnif": "'|| f_Acteur.DateAnnif ||'",'||
                ' "DateDeces": "'|| f_Acteur.DateDeces ||'",'||
                ' "LieuNaiss": "'|| f_Acteur.LieuNaiss ||'",'||
                ' "Image": "' || f_Acteur.Image ||'",'||
                ' "_IdFilm": ' || Biography.id ||','||
                ' "Titre": "' || Biography.Titre ||'",'||
                ' "Annee_Sortie": ' || Biography.Annee_Sortie ||
                ' }';
        req := utl_http.begin_request('http://10.0.2.2:8084/VerifActeur_v1/VerifActeur_v1', 'POST',' HTTP/1.1');
        utl_http.set_header(req, 'content-type', 'application/json');
        utl_http.set_header(req, 'Content-Length', length(actJSON));
        utl_http.write_text(req, actJSON);
        res := utl_http.get_response(req);
        UTL_HTTP.READ_TEXT(res, reponse);
        UTL_HTTP.END_RESPONSE(res);
    END IF ;*/
EXCEPTION
  WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN
    UTL_HTTP.END_RESPONSE(res);
END VerifActeur;