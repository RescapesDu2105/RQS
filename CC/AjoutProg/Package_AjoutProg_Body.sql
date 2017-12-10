create or replace PACKAGE BODY PACKAGE_AJOUTPROG AS

PROCEDURE AjoutProg(p_directory IN VARCHAR2, p_file IN VARCHAR2) as
BEGIN
    LOAD_FILE(p_directory,p_file);
    Verif_Prog;
    Write_XML(p_file);
    COMMIT;
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
    
    EXC_ID_NULL EXCEPTION;
    
BEGIN
    feedback := XMLTYPE('<feedback></feedback>');
    
    
    FOR indx IN l_Demande.first..l_Demande.last
    LOOP
        BEGIn
        
            Check_Hours(l_Demande(indx).idDemande,l_Demande(indx).movie,l_Demande(indx).heure);
            IF l_Demande(indx).idDemande IS NULL THEN RAISE EXC_ID_NULL; END IF;
            Check_Complexe(l_Demande(indx).idDemande,l_Demande(indx).complexe);
            Check_Salle(l_Demande(indx).idDemande,l_Demande(indx).salle,l_Demande(indx).complexe);
            Check_Movie(l_Demande(indx).idDemande,l_Demande(indx).movie);
            Check_Copy(l_Demande(indx).idDemande,l_Demande(indx).movie,l_Demande(indx).copy);
            Check_Date(l_Demande(indx).idDemande,l_Demande(indx).debut,l_Demande(indx).fin);
            Check_Hours(l_Demande(indx).idDemande,l_Demande(indx).movie,l_Demande(indx).heure);
            Check_Disponibility(l_Demande(indx));
            
            Insert_Prog(l_Demande(indx));
            
             ADD_FEEDBACKRAW(l_Demande(indx).idDemande,1,'Programmation valide');
        EXCEPTION
            WHEN EXC_ID_NULL THEN ADD_FEEDBACKRAW(-1,0,'Le champ id esdt vide');
            WHEN OTHERS THEN Ajout_Log_Error(CURRENT_TIMESTAMP, 'AjoutProg', SQLCODE, SQLERRM);
        END;
    END LOOP;
END Verif_Prog;

PROCEDURE Check_Complexe(p_idprogrammation IN NUMBER, p_complexe IN NUMBER) as
    EXC_COMPLEXE_NULL EXCEPTION;
    
    ComplexeTemp NUMBER;
BEGIN
    IF p_complexe IS NULL THEN RAISE EXC_COMPLEXE_NULL; END IF;
    
    SELECT idComplexe INTO ComplexeTemp
    FROM complexes
    WHERE idComplexe=p_complexe;

EXCEPTION
    WHEN EXC_COMPLEXE_NULL THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le champ complexe est vide'); RAISE;
    WHEN NO_DATA_FOUND  THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Aucune complexe correspond a la programmation'); RAISE;
    WHEN OTHERS THEN ADD_FEEDBACKRAW(p_idprogrammation,0,SQLERRM);
    RAISE;
END Check_Complexe;


PROCEDURE Check_Salle(p_idprogrammation IN NUMBER, p_salle IN NUMBER , p_complexe NUMBER) AS
    EXC_COMPLEXE_NULL EXCEPTION;
    
    TYPE SalleRec IS RECORD(
        idSalle NUMBER,
        idComplexe NUMBER);
    salle_rec SalleRec;
BEGIN  
    IF p_salle IS NULL THEN RAISE EXC_COMPLEXE_NULL; END IF;
    
    SELECT idSalle , idComplexe INTO salle_rec 
    FROM Salles
    WHERE idSalle=p_salle
    AND idComplexe=p_complexe;

EXCEPTION
    WHEN EXC_COMPLEXE_NULL THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le champ salle est vide'); RAISE;
    WHEN NO_DATA_FOUND  THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Aucune salle correspond a la programmation'); RAISE;
    WHEN OTHERS THEN ADD_FEEDBACKRAW(p_idprogrammation,0,SQLERRM);
    RAISE;    
END Check_Salle;

PROCEDURE Check_Movie(p_idprogrammation IN NUMBER, p_idmovie IN NUMBER) as
   EXC_FILM_NULL EXCEPTION;
   
   MovieTemp NUMBER;
BEGIN
    IF p_idmovie IS NULL THEN RAISE EXC_FILM_NULL; END IF;
    
    SELECT IDFilm into MovieTemp
    FROM films
    WHERE idFilm=p_idmovie;
EXCEPTION
    WHEN EXC_FILM_NULL THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le champ film est vide'); RAISE;
    WHEN NO_DATA_FOUND  THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Aucune copie correspond au film'); RAISE;
    WHEN OTHERS THEN ADD_FEEDBACKRAW(p_idprogrammation,0,SQLERRM);
    RAISE;
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
    WHEN EXC_copy_NULL THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le champ copy est vide'); RAISE;
    WHEN NO_DATA_FOUND  THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Aucune copie correspond a la programmation'); RAISE;
    WHEN OTHERS THEN ADD_FEEDBACKRAW(p_idprogrammation,0,SQLERRM);
    RAISE;
END Check_Copy;

PROCEDURE Check_Hours(p_idprogrammation IN NUMBER, p_idmovie IN NUMBER, p_heure IN VARCHAR2) as
    EXC_heure_NULL EXCEPTION;
    EXC_Heure_FIN EXCEPTION;
    EXC_heure_DEBUT EXCEPTION;
    
    DureeTemp INTERVAL DAY TO SECOND;
    HeureCal TIMESTAMP;
BEGIN
    IF p_heure IS NULL THEN RAISE EXC_heure_NULL; END IF;
    
    SELECT NUMTODSINTERVAL(duree,'MINUTE') INTO DureeTemp 
    FROM FILMS
    WHERE idFilm=p_idmovie;
    
    HeureCal:=TO_TIMESTAMP(p_heure, 'HH24:MI:SS')+DureeTemp;
    IF(HeureCal>closing_time)THEN RAISE EXC_Heure_FIN; END IF;
    IF HeureCal<opening_time THEN RAISE EXC_heure_DEBUT; END IF;
    
EXCEPTION
    WHEN EXC_heure_NULL THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le champ heure est vide'); RAISE;
    WHEN EXC_Heure_FIN THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le film se terminera apres la fermeture'); RAISE;
    WHEN EXC_heure_DEBUT THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le film est programmé avant l''ouverture'); RAISE;
    WHEN OTHERS THEN ADD_FEEDBACKRAW(p_idprogrammation,0,SQLERRM);
    RAISE;
END Check_Hours;

PROCEDURE Check_Date(p_idprogrammation IN NUMBER , p_debut IN VARCHAR2 , p_fin IN VARCHAR2)AS
    EXC_debut_NULL EXCEPTION;
    EXC_fin_NULL EXCEPTION;
    EXC_debut_APRES EXCEPTION;
BEGIN
    
    IF p_debut IS NULL THEN RAISE EXC_debut_NULL ; END IF ;
    IF p_fin IS NULL THEN RAISE EXC_fin_NULL; END IF;
    IF (TO_DATE(p_debut,'dd/mm/yyyy')>TO_DATE(p_fin,'dd/mm/yyyy')) THEN RAISE EXC_debut_APRES ; END IF;
    
EXCEPTION
    WHEN EXC_debut_NULL THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le champ debut est vide'); RAISE;
    WHEN EXC_fin_NULL THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le champ fin est vide'); RAISE;
    WHEN EXC_debut_APRES THEN ADD_FEEDBACKRAW(p_idprogrammation,0,'Le debut de la programmation est apres la fermeture du complexe'); RAISE;
    WHEN OTHERS THEN ADD_FEEDBACKRAW(p_idprogrammation,0,SQLERRM);
    RAISE;
END Check_Date;

PROCEDURE Check_Disponibility (p_demande IN DemandeRec)AS
    l_demande_temp Liste_Demande;
    DureeTemp INTERVAL DAY TO SECOND;
    HeureCal TIMESTAMP;
    TYPE Liste_copy IS TABLE OF FILMS_COPIES.id%TYPE INDEX BY BINARY_INTEGER;
    l_copy Liste_copy;
    
    EXC_Programmation_Prise EXCEPTION;
    EXC_Programmation_HeureSup EXCEPTION;
    EXC_Programmation_HeureInf EXCEPTION;
    EXC_Programmation_AutrePart EXCEPTION;
    EXC_PASDEDONNEE EXCEPTION;
BEGIN

    SELECT * bulk collect into l_demande_temp
    FROM PROGRAMMATIONS_VIEW
    WHERE p_demande.movie=movie;
    IF l_demande_temp.count=0 THEN RAISE EXC_PASDEDONNEE; END IF;
    
    FOR indx IN l_demande_temp.FIRST .. l_demande_temp.LAST 
    LOOP
        IF l_demande_temp(indx).complexe=p_demande.complexe THEN
            IF l_demande_temp(indx).salle=p_demande.salle THEN
                IF l_demande_temp(indx).heure=p_demande.heure THEN
                    RAISE EXC_Programmation_Prise;
                ELSIF l_demande_temp(indx).heure>p_demande.heure THEN
                    
                    SELECT NUMTODSINTERVAL(duree,'MINUTE') INTO DureeTemp 
                    FROM FILMS
                    WHERE idFilm=l_demande_temp(indx).movie;
                    HeureCal:=TO_TIMESTAMP(l_demande_temp(indx).heure, 'HH24:MI:SS')+DureeTemp;
                    
                    IF HeureCal>p_demande.heure THEN
                        RAISE EXC_Programmation_HeureSup;
                    END IF;
                ELSIF l_demande_temp(indx).heure<p_demande.heure THEN
                
                    SELECT NUMTODSINTERVAL(duree,'MINUTE') INTO DureeTemp 
                    FROM FILMS
                    WHERE idFilm=p_demande.movie; 
                    HeureCal:=TO_TIMESTAMP(l_demande_temp(indx).heure, 'HH24:MI:SS')+DureeTemp;
                    HeureCal:=TO_TIMESTAMP(p_demande.heure, 'HH24:MI:SS')+DureeTemp;
                    
                    IF HeureCal>l_demande_temp(indx).heure THEN
                        RAISE EXC_Programmation_HeureInf;
                    END IF;
                END IF;
            END IF;
        ELSE
            
            SELECT copy BULK COLLECT INTO l_copy
            FROM PROGRAMMATIONS_VIEW
            WHERE complexe =l_demande_temp(indx).copy
            AND movie = l_demande_temp(indx).movie;
            IF l_copy.count=0 THEN RAISE EXC_PASDEDONNEE; END IF;
            
            FOR i IN l_copy.FIRST .. l_copy.LAST
            LOOP
                IF l_demande_temp(indx).copy=l_copy(i) THEN
                    RAISE EXC_Programmation_AutrePart;
                END IF ;
            l_copy.delete;    
            END LOOP;
        END IF;
    END LOOP;
        
EXCEPTION
    WHEN EXC_Programmation_Prise THEN ADD_FEEDBACKRAW(p_demande.iDDemande,0,'Il y a deja une programmation prevue à la meme heure'); RAISE;
    WHEN EXC_Programmation_HeureSup THEN ADD_FEEDBACKRAW(p_demande.iDDemande,0,'Une autre séance ne sera pas finie quand ce film commencera'); RAISE;
    WHEN EXC_Programmation_HeureInf THEN ADD_FEEDBACKRAW(p_demande.iDDemande,0,'Ce film sera fini pendant qu''une autre séance aura debuté'); RAISE;
    WHEN EXC_Programmation_AutrePart THEN ADD_FEEDBACKRAW(p_demande.iDDemande,0,'La copie physique de ce film est dans un autre complexe'); RAISE;
    WHEN EXC_PASDEDONNEE OR NO_DATA_FOUND THEN
        Insert_Prog(p_demande);
        ADD_FEEDBACKRAW(p_demande.idDemande,1,'Programmation valide');
        RAISE;
    WHEN OTHERS THEN ADD_FEEDBACKRAW(p_demande.idDemande,0,SQLERRM);
    RAISE;
END Check_Disponibility;

PROCEDURE Insert_Prog(p_demande IN DemandeRec)AS
    programmation XMLTYPE;
BEGIN
    SELECT XMLElement("programmation",
      XMLForest(
        p_demande.idDemande AS "idDemande",
        p_demande.complexe AS "complexe",
        p_demande.debut AS "debut",
        p_demande.fin AS "fin",
        p_demande.movie AS "movie",
        p_demande.copy AS "copy",
        p_demande.salle AS "salle",
        p_demande.heure AS "heure"
      )
    ) into programmation
    FROM DUAL;
    
    INSERT INTO programmations VALUES programmation;
        
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN ADD_FEEDBACKRAW(p_demande.iDDemande,0,'La programmation existe deja'); RAISE;
    WHEN OTHERS THEN RAISE ;
END;

PROCEDURE ADD_FEEDBACKRAW(p_idprogrammation IN NUMBER , p_isok IN NUMBER , p_info IN VARCHAR2) as
BEGIN
    SELECT INSERTCHILDXML(feedback,'/feedback','programmation',XMLType('<programmation id="'|| p_idprogrammation ||'"></programmation>')) 
    INTO feedback FROM DUAL;
    SELECT INSERTCHILDXML(feedback,'/feedback/programmation[@id='|| p_idprogrammation ||']','isok',XMLType('<isok>'||p_isok||'</isok>')) 
    INTO feedback FROM DUAL;
    SELECT INSERTCHILDXML(feedback,'/feedback/programmation[@id='|| p_idprogrammation ||']','error',XMLType('<error>'||p_info||'</error>')) 
    INTO feedback FROM DUAL;
EXCEPTION 
    WHEN OTHERS THEN RAISE;
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