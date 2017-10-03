DROP TABLE Informational_Logs;
DROP TABLE Errors_Logs;
DROP SEQUENCE Sequence_Informational_Logs;
DROP SEQUENCE Sequence_Errors_Logs;

CREATE SEQUENCE Sequence_Informational_Logs;
CREATE SEQUENCE Sequence_Errors_Logs;

CREATE TABLE Informational_Logs
(
    ID NUMBER DEFAULT Sequence_Informational_Logs.NEXTVAL CONSTRAINT Informational_Logs_PK PRIMARY KEY,
    DateHeure TIMESTAMP,
    Endroit VARCHAR2(255),
    ErrorCode VARCHAR2(255),
    Message VARCHAR2(255)
);

CREATE TABLE Errors_Logs
(
    ID NUMBER DEFAULT Sequence_Errors_Logs.NEXTVAL CONSTRAINT Errors_Logs_PK PRIMARY KEY,
    DateHeure TIMESTAMP,
    Endroit VARCHAR2(255),
    ErrorCode VARCHAR2(255),
    Message VARCHAR2(255)
);

CREATE OR REPLACE PROCEDURE Procedure_Logs(pDateHeure DATE, pEndroit VARCHAR2, pMessage VARCHAR2, pNiveau_Filtrage NUMBER)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    OK NUMBER(1);

    ExcNivFiltrageInvalid EXCEPTION;
    ExcSequenceErrorsMissing EXCEPTION;
    ExcSequenceInformationalMissing EXCEPTION;

    FUNCTION SequenceExistance (NomSequence IN VARCHAR2)
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
BEGIN
    OK := 0;
    OK := SequenceExistance('Sequence_Errors_Logs');
    IF (OK IS NULL) THEN
        RAISE ExcSequenceErrorsMissing;
    END IF;

    OK := 0;
    OK := SequenceExistance('Sequence_Informational_Logs');
    IF (OK IS NULL) THEN
        RAISE ExcSequenceInformationalMissing;
    END IF;

    IF (pNiveau_Filtrage = 1) THEN
        INSERT INTO Informational_Logs(DateHeure, Endroit, Message) VALUES (pDateHeure, pEndroit, pMessage);
    ELSIF (pNiveau_Filtrage = 2) THEN
        INSERT INTO Errors_Logs(DateHeure, Endroit, Message) VALUES (pDateHeure, pEndroit, pMessage);
    ELSE
        RAISE ExcNivFiltrageInvalid;
    END IF;

    COMMIT;
EXCEPTION
    WHEN ExcNivFiltrageInvalid THEN RAISE_APPLICATION_ERROR(-20001, 'Procédure_Logs : le niveau de filtrage est incorrect !');
    WHEN ExcSequenceErrorsMissing THEN RAISE_APPLICATION_ERROR(-20002, 'Procédure_Logs : la séquence "Sequence_Errors_Logs" n''existe pas !');
    WHEN ExcSequenceInformationalMissing THEN RAISE_APPLICATION_ERROR(-20003, 'Procédure_Logs : la séquence "Sequence_Informational_Logs" n''existe pas !');
    WHEN OTHERS THEN RAISE;
END Procedure_Logs;
/