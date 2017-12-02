create or replace PACKAGE PACKAGE_AJOUTPROG AS 
    
  TYPE DemandeRec IS RECORD (
        IdDemande VARCHAR2(10),
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
    
  closing_time TIMESTAMP := TO_TIMESTAMP('23:00:00', 'HH24:MI:SS');
  opening_time TIMESTAMP := TO_TIMESTAMP('10:00:00', 'HH24:MI:SS');

  PROCEDURE LOAD_FILE(p_directory IN VARCHAR2, p_file IN VARCHAR2); 

END PACKAGE_AJOUTPROG;
