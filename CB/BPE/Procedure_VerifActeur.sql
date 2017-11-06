create or replace PROCEDURE VerifActeur(IdAct IN Artists.idArt%type)
IS
    x   UTL_HTTP.HTML_PIECES;
	req UTL_HTTP.REQ;
	res UTL_HTTP.RESP;
BEGIN
    --                            ICI TU METS L'ADRESSE DE LA SERVLET
    x := UTL_HTTP.REQUEST_PIECES('http://10.37.129.2:8084/VerifActeur_v1/people/people/get/' || IdAct );
END ;