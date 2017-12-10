create or replace PACKAGE PACKAGE_AJOUTPROG AS 
    
  TYPE DemandeRec IS RECORD (
        IdDemande NUMBER,
        complexe NUMBER(2),
        debut VARCHAR2(10 CHAR),
        fin VARCHAR2(10 CHAR),
        movie NUMBER(6),
        copy NUMBER,
        salle NUMBER,
        heure VARCHAR2(5 CHAR)
    );
    TYPE Liste_Demande IS TABLE OF DemandeRec INDEX BY BINARY_INTEGER;
    l_Demande Liste_Demande;
    l_demande_temp Liste_Demande;
    
    feedback XMLTYPE;
    
    closing_time TIMESTAMP := TO_TIMESTAMP('23:00:00', 'HH24:MI:SS');
    opening_time TIMESTAMP := TO_TIMESTAMP('10:00:00', 'HH24:MI:SS');

    PROCEDURE AjoutProg(p_directory IN VARCHAR2, p_file IN VARCHAR2);
    PROCEDURE LOAD_FILE(p_directory IN VARCHAR2, p_file IN VARCHAR2);
    PROCEDURE Verif_Prog;
    PROCEDURE Check_Complexe(p_idprogrammation IN NUMBER, p_complexe IN NUMBER);
    PROCEDURE Check_Salle(p_idprogrammation IN NUMBER, p_salle IN NUMBER , p_complexe NUMBER);
    PROCEDURE Check_Movie(p_idprogrammation IN NUMBER, p_idmovie IN NUMBER);
    PROCEDURE Check_Copy(p_idprogrammation IN NUMBER, p_idmovie IN NUMBER , p_copyid IN NUMBER);
    PROCEDURE Check_Date(p_idprogrammation IN NUMBER , p_debut IN VARCHAR2 , p_fin IN VARCHAR2); 
    PROCEDURE Check_Hours(p_idprogrammation IN NUMBER, p_idmovie IN NUMBER,p_heure IN VARCHAR2);
    PROCEDURE Check_Disponibility(p_demande IN DemandeRec);
    
    PROCEDURE Insert_Prog(p_demande IN DemandeRec);
    
    PROCEDURE Write_XML(p_file IN VARCHAR2);
    PROCEDURE ADD_FEEDBACKRAW(p_idprogrammation IN NUMBER , p_isok IN NUMBER ,p_info IN VARCHAR2);

END PACKAGE_AJOUTPROG;