create or replace PACKAGE package_RechPlaces
IS
    req UTL_HTTP.REQ;
    res UTL_HTTP.RESP; 

    PROCEDURE Traiter_Requete(param IN VARCHAR2);      
END package_RechPlaces;
/