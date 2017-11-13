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
BEGIN
    SELECT ID , Name, TO_CHAR(BIRTHDAY, 'YYYY-MM-DD'), TO_CHAR(DEATHDAY, 'YYYY-MM-DD'),PLACE_OF_BIRTH,PROFILE_PATH INTO f_Acteur
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
    END IF ;
EXCEPTION
  WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN
    UTL_HTTP.END_RESPONSE(res);
END VerifActeur;