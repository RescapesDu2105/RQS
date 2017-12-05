create or replace PACKAGE BODY PACKAGE_AJOUTPROG AS

PROCEDURE AjoutProg(p_directory IN VARCHAR2, p_file IN VARCHAR2) as
BEGIN
    LOAD_FILE(p_directory,p_file);
    Verif_Prog;
    Write_XML(p_file);
END AjoutProg;

    PROCEDURE LOAD_FILE(p_directory IN VARCHAR2 , p_file IN VARCHAR2) as
        EXC_FILE_EMPTY EXCEPTION;
        progbfile   BFILE;
        
    BEGIN
        progbfile := BFILENAME(p_directory, p_file);
        
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
                heure varchar2(10) PATH 'heure');
    EXCEPTION
        WHEN EXC_FILE_EMPTY THEN 
            RAISE_APPLICATION_ERROR('-20001', 'Erreur lors de la lecture du fichier'); 
           Ajout_Log_Error(CURRENT_TIMESTAMP, 'AjoutProg', '-20001', 'Erreur lors de la lecture du fichier'); 
        When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
    END LOAD_FILE;
    
PROCEDURE Verif_Prog as
    movie_valid boolean;
    date_valid boolean;
    valid boolean;
    
    EXC_ID_NULL EXCEPTION;
    EXC_COMPLEXE_NULL EXCEPTION;
    EXC_debut_NULL EXCEPTION;
    EXC_fin_NULL EXCEPTION;
    EXC_copy_NULL EXCEPTION;
    EXC_salle_NULL EXCEPTION;
    EXC_heure_NULL EXCEPTION;
    
BEGIN
    feedback := XMLTYPE('<feedback></feedback>');
    
    
    FOR indx IN l_Demande.first..l_Demande.last
    LOOP
        BEGIN
            
            movie_valid:=TRUE;
            date_valid:=TRUE;
            valid:=TRUE;
            
            IF l_Demande(indx).idDemande IS NULL THEN RAISE EXC_ID_NULL; END IF;
            IF l_Demande(indx).complexe IS NULL THEN RAISE EXC_COMPLEXE_NULL; END IF;
            IF l_Demande(indx).debut IS NULL THEN RAISE EXC_debut_NULL ; END IF;
            IF l_Demande(indx).fin IS NULL THEN RAISE EXC_fin_NULL ; END IF;
            Check_Movie(l_Demande(indx).idDemande,l_Demande(indx).movie);
            ADD_FEEDBACKRAW(l_Demande(indx).idDemande,1,'Programmation valide');
            
        EXCEPTION
            WHEN EXC_ID_NULL THEN ADD_FEEDBACKRAW(-1,0,'Le champ id esdt vide ');
            WHEN EXC_COMPLEXE_NULL THEN ADD_FEEDBACKRAW(l_Demande(indx).idDemande,0,'Le champ complexe esdt vide ');
            WHEN EXC_debut_NULL THEN ADD_FEEDBACKRAW(l_Demande(indx).idDemande,0,'Le champ debut esdt vide ');
            WHEN EXC_fin_NULL THEN ADD_FEEDBACKRAW(l_Demande(indx).idDemande,0,'Le champ fin esdt vide ');
            WHEN OTHERS THEN Ajout_Log_Error(CURRENT_TIMESTAMP, 'AjoutProg', SQLCODE, SQLERRM);
        END;
    END LOOP;
END Verif_Prog;

PROCEDURE Check_Movie(p_idprogrammation IN NUMBER, p_idmovie IN NUMBER) as
   EXC_FILM_NULL EXCEPTION;
   
   MovieTemp NUMBER;
BEGIN
    IF p_idmovie IS NULL THEN RAISE EXC_FILM_NULL; END IF;
    
    SELECT IDFilm into MovieTemp
    FROM films
    WHERE idFilm=p_idmovie;
EXCEPTION
    WHEN EXC_FILM_NULL THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le champ film est vide '); RAISE;
    WHEN NO_DATA_FOUND  THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Aucun film trouvé pour le film : '|| p_idmovie); RAISE;
    WHEN OTHERS THEN RAISE;
END Check_Movie;

PROCEDURE Check_Copy(p_idprogrammation IN NUMBER, p_idmovie IN NUMBER , p_copyid IN NUMBER) as
   EXC_copy_NULL EXCEPTION;
   
   CopyTemp NUMBER;
BEGIN
    IF p_copyid IS NULL THEN RAISE EXC_copy_NULL;END IF;
    
    SELECT id INTO CopyTemp
    FROM Films_copies
    WHERE movie=p_idmovie
    AND id=p_copyid;
EXCEPTION
    WHEN EXC_copy_NULL THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le champ copy est vide '); RAISE;
    WHEN NO_DATA_FOUND  THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Aucune copie correspond a : '|| p_copyid); RAISE;
    WHEN OTHERS THEN RAISE;
END Check_Copy;

PROCEDURE Create_FEEDBACKRAW(p_idprogrammation IN NUMBER) as
BEGIN
    SELECT INSERTCHILDXML(feedback, '/feedback', 'programmation', XMLTYPE('<programmation><id>' || p_idprogrammation || '</id><infos></infos></programmation>')) 
    INTO feedback FROM DUAL;
END Create_FEEDBACKRAW;

PROCEDURE ADD_FEEDBACKRAW(p_idprogrammation IN NUMBER , p_isok IN NUMBER , p_info IN VARCHAR2) as
BEGIN
    SELECT INSERTCHILDXML(feedback,'/feedback','programmation',XMLType('<programmation id="'|| p_idprogrammation ||'"></programmation>')) 
    INTO feedback FROM DUAL;
    SELECT INSERTCHILDXML(feedback,'/feedback/programmation[@id='|| p_idprogrammation ||']','isok',XMLType('<isok>'||p_isok||'</isok>')) 
    INTO feedback FROM DUAL;
    SELECT INSERTCHILDXML(feedback,'/feedback/programmation[@id='|| p_idprogrammation ||']','error',XMLType('<error>'||p_info||'</error>')) 
    INTO feedback FROM DUAL;
END ADD_FEEDBACKRAW;

PROCEDURE Write_XML(p_file IN VARCHAR2) AS
    filename_feedback VARCHAR2(255);
    file utl_file.file_type;
BEGIN
    filename_feedback:=CONCAT(SUBSTR(p_file, 1, LENGTH(p_file) - 4), '_feedback.xml');
    file := utl_file.fopen('DIRTESTPROG', filename_feedback,'w');
    utl_file.fclose(file);
    DBMS_XSLPROCESSOR.CLOB2FILE(feedback.getClobVal(), 'DIRTESTPROG', filename_feedback, nls_charset_id('AL32UTF8'));
END;

--When Others Then Dbms_Output.Put_Line('INTERCEPTE : CODE ERREUR : '|| Sqlcode || ' MESSAGE : ' || Sqlerrm) ;
-- Dbms_Output.Put_Line
END PACKAGE_AJOUTPROG;