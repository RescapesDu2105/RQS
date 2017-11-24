DROP TABLE Informational_Logs;
DROP TABLE Errors_Logs;
DROP SEQUENCE Sequence_Informational_Logs;
DROP SEQUENCE Sequence_Errors_Logs;

-- Création des séquences pour les ids des tables de logs
CREATE SEQUENCE Sequence_Informational_Logs;
CREATE SEQUENCE Sequence_Errors_Logs;

-- Création des tables de logs
CREATE TABLE Informational_Logs
(
    ID NUMBER DEFAULT Sequence_Informational_Logs.NEXTVAL CONSTRAINT Informational_Logs_PK PRIMARY KEY,
    DateHeure TIMESTAMP,
    Endroit VARCHAR2(255),
    Message VARCHAR2(255)
);
/
CREATE TABLE Errors_Logs
(
    ID NUMBER DEFAULT Sequence_Errors_Logs.NEXTVAL CONSTRAINT Errors_Logs_PK PRIMARY KEY,
    DateHeure TIMESTAMP,
    Endroit VARCHAR2(255),
    ErrorCode VARCHAR2(255),
    Message VARCHAR2(512)
);
/
-- Création de la fonction qui va vérifier l'existance des séquences
CREATE OR REPLACE FUNCTION SequenceExistance (NomSequence IN VARCHAR2)
    RETURN NUMBER
    IS
        OK NUMBER(1);
    BEGIN 
        SELECT CASE WHEN EXISTS (
            SELECT * 
            FROM User_Objects 
            WHERE UPPER(object_name) = UPPER(NomSequence)) THEN 1 ELSE 0 END
        INTO OK
        FROM DUAL;
    RETURN OK;
END SequenceExistance;
/

CREATE OR REPLACE PROCEDURE Ajout_Log_Info(pDateHeure IN TIMESTAMP, pEndroit IN VARCHAR2, pMessage IN VARCHAR2)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    OK NUMBER(1);

    ExcSequenceInformationalMissing EXCEPTION;    
BEGIN
    OK := 0;
    OK := SequenceExistance('Sequence_Informational_Logs');
    IF (OK IS NULL) THEN
        RAISE ExcSequenceInformationalMissing;
    END IF;
        
    INSERT INTO Informational_Logs(DateHeure, Endroit, Message) VALUES (pDateHeure, pEndroit, pMessage);
    COMMIT;
EXCEPTION
    WHEN ExcSequenceInformationalMissing THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Procédure_Logs : la séquence "Sequence_Informational_Logs" n''existe pas !');
        Ajout_Log_Error(CURRENT_TIMESTAMP, 'Ajout_Log_Info on INSERT INTO Informational_Logs', SQLCODE, SQLERRM);
        ROLLBACK;
    WHEN OTHERS THEN 
        RAISE;
        Ajout_Log_Error(CURRENT_TIMESTAMP, 'Ajout_Log_Info on INSERT INTO Informational_Logs', SQLCODE, SQLERRM);
        ROLLBACK;
END Ajout_Log_Info;
/

CREATE OR REPLACE PROCEDURE Ajout_Log_Error(pDateHeure IN TIMESTAMP, pEndroit IN VARCHAR2, pErrorCode IN NUMBER, pMessage IN VARCHAR2)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    OK NUMBER(1);

    ExcSequenceErrorsMissing EXCEPTION;
BEGIN
    OK := 0;
    OK := SequenceExistance('Sequence_Errors_Logs');
    IF (OK IS NULL) THEN
        RAISE ExcSequenceErrorsMissing;
    END IF;

    INSERT INTO Errors_Logs(DateHeure, Endroit, ErrorCode, Message) VALUES (pDateHeure, pEndroit, pErrorCode, pMessage);
    COMMIT;
EXCEPTION
    WHEN ExcSequenceErrorsMissing THEN 
        RAISE_APPLICATION_ERROR(-20002, 'Procédure_Logs : la séquence "Sequence_Errors_Logs" n''existe pas !');
        Ajout_Log_Error(CURRENT_TIMESTAMP, 'Ajout_Log_Error on INSERT INTO Errors_Logs', SQLCODE, SQLERRM);
        ROLLBACK;
    WHEN OTHERS THEN 
        RAISE;        
        Ajout_Log_Error(CURRENT_TIMESTAMP, 'Ajout_Log_Error on INSERT INTO Errors_Logs', SQLCODE, SQLERRM);        
        ROLLBACK;
END Ajout_Log_Error;
/