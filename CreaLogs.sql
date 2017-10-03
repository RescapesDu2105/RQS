DROP TABLE Informational_Logs;
DROP TABLE Errors_Logs;
DROP SEQUENCE Sequence_Informational_Logs;
DROP SEQUENCE Sequence_Errors_Logs;

CREATE SEQUENCE Sequence_Informational_Logs ;
CREATE SEQUENCE Sequence_Errors_Logs;

CREATE TABLE Informational_Logs
(
    ID NUMBER(29) DEFAULT Sequence_Informational_Logs.NEXTVAL CONSTRAINT Informational_Logs_PK PRIMARY KEY,
    DateHeure TIMESTAMP,
    Endroit VARCHAR2(100),
    Message VARCHAR2(100)
);

CREATE TABLE Errors_Logs
(
    ID NUMBER(29) DEFAULT Sequence_Errors_Logs.NEXTVAL CONSTRAINT Errors_Logs_PK PRIMARY KEY,
    DateHeure TIMESTAMP,
    Endroit VARCHAR2(100),
    Message VARCHAR2(100)
);

CREATE OR REPLACE PROCEDURE Procedure_Logs(pDateHeure DATE, pEndroit VARCHAR2, pMessage VARCHAR2, pNiveau_Filtrage NUMBER)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    IF (pNiveau_Filtrage = 1) THEN
        INSERT INTO Informational_Logs(DateHeure, Endroit, Message) VALUES (pDateHeure, pEndroit, pMessage);
    ELSIF (pNiveau_Filtrage = 2) THEN
        INSERT INTO Errors_Logs(DateHeure, Endroit, Message) VALUES (pDateHeure, pEndroit, pMessage);
    END IF;

    COMMIT;

END Procedure_Logs;
/

--Test
