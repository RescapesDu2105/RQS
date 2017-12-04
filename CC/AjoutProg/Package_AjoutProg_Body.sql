create or replace PACKAGE BODY PACKAGE_AJOUTPROG AS

    PROCEDURE LOAD_FILE(p_directory IN VARCHAR2 , p_file IN VARCHAR2) as
        EXC_FILE_EMPTY EXCEPTION;
        
        progbfile   BFILE;
    BEGIN
        progbfile := BFILENAME(p_directory, p_file);
            
        dbms_lob.close(progbfile);
        
        select * bulk collect into l_Demande
        from      
        XMLTABLE('/programmation/demande' 
            PASSING xmltype(progbfile, nls_charset_id('AL32UTF8'))
            COLUMNS 
                idDemande NUMBER PATH '@idDemande',
                complexe NUMBER(2) PATH 'complexe',
                debut varchar2(10) PATH 'debut',
                fin varchar2(10) PATH 'fin',
                movie NUMBER(10) PATH 'movie',
                copy NUMBER(10) PATH 'copy',
                salle NUMBER(10) PATH 'salle',
                heure varchar2(10) PATH 'heure') ;
                
    EXCEPTION
        WHEN EXC_FILE_EMPTY THEN 
            RAISE_APPLICATION_ERROR('-20001', 'Erreur lors de la lecture du fichier'); 
           Ajout_Log_Error(CURRENT_TIMESTAMP, 'AjoutProg', '-20001', 'Erreur lors de la lecture du fichier'); 
        When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
    END LOAD_FILE;

--When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
-- Dbms_Output.Put_Line
END PACKAGE_AJOUTPROG;