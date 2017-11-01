DECLARE 
    Liste packageAlimCB.Liste_Movie_Id;
BEGIN
    SELECT MOVIES_EXT.ID BULK COLLECT INTO Liste
    FROM MOVIES_EXT
    WHERE ROWNUM<4;
    packageAlimCB.alimCB(Liste);
    
    /*FOR indx IN Liste.FIRST..Liste.LAST LOOP
        dbms_output.put_line(Liste(indx));
    END LOOP;*/
END ;

DELETE FROM films;
DELETE FROM status;
DELETE FROM certifications;
DELETE FROM posters;
commit;