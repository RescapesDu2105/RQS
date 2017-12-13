create or replace PACKAGE BODY package_RechPlaces
AS
    PROCEDURE Traiter_Requete (param IN VARCHAR2)
    IS
    BEGIN
        owa_util.mime_header ('text/html', bclose_header => true, ccharset => 'UTF-8');
        htp.print ('<html><body><p>' || param || '</p></body></html>');
    END Traiter_Requete;

END package_RechPlaces;
/