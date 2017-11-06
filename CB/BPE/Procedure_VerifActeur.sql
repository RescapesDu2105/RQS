create or replace PROCEDURE VerifActeur(IdAct IN Artists.idArt%type)
IS
    TYPE Fiche_Acteur IS RECORD(
        id NUMBER(7,0),
        Nom VARCHAR2(2000 CHAR),
        DataAnnif VARCHAR2(10 CHAR),
		DaceDeces VARCHAR2(10 CHAR),
		LieuNaiss VARCHAR2(2000 CHAR),
		Image VARCHAR2(100 CHAR));
    f_Acteur Fiche_Acteur;
        
    TYPE Biography_Rec IS RECORD(
        id NUMBER(7,0),
        Titre VARCHAR2(60 CHAR),
        Année_Sortie NUMBER(4));
    Biography Biography_Rec;
    
   -- x   UTL_HTTP.HTML_PIECES;
	req UTL_HTTP.REQ;
	res UTL_HTTP.RESP;
    reponse VARCHAR(100 CHAR);
    
    actJSON CLOB ;
BEGIN
    SELECT ID , Name, BIRTHDAY, DEATHDAY,PLACE_OF_BIRTH,PROFILE_PATH INTO f_Acteur
    FROM PEOPLE_EXT
    WHERE id=IdAct;
    
    SELECT IdFilm , Titre , EXTRACT(YEAR FROM Date_Real) INTO Biography
    FROM films
    Where IdFilm IN(
        SELECT film
        FROM jouer
        WHERE artist=IdAct)
    AND ROWNUM=1;
    
    
    actJSON := '{'||
            ' "_idAct": ' || f_Acteur.id ||','||
            ' "nom": '|| f_Acteur.nom ||','||
            ' "DataAnnif": '|| f_Acteur.DataAnnif ||','||
            ' "DaceDeces": '|| f_Acteur.DaceDeces ||','||
            ' "LieuNaiss": "'|| f_Acteur.LieuNaiss ||','||
            ' "Image": "",' || f_Acteur.Image ||'",'||
            ' "_IdFilm": "",' || Biography.id ||'",'||
            ' "Titre": "",' || Biography.Titre ||'",'||
            ' "Année_Sortie": "",' || Biography.Année_Sortie ||'",'||
            ' }';
    --                            ICI TU METS L'ADRESSE DE LA SERVLET EN TERMINANT PAR /INSERT
    req := utl_http.begin_request('http://10.37.129.2:8084/VerifActeur_v1/people/people/insert', 'POST',' HTTP/1.1');
    --utl_http.set_header(req, 'user-agent', 'mozilla/4.0');
    utl_http.set_header(req, 'content-type', 'application/json');
    utl_http.set_header(req, 'Content-Length', length(actJSON));
    utl_http.write_text(req, actJSON);
    res := utl_http.get_response(req);
    UTL_HTTP.READ_TEXT(res, reponse);
    UTL_HTTP.END_RESPONSE(res);
    
    --Traiter la reponse du serveur

END ;