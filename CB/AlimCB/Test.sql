DECLARE 
    Liste packageAlimCB.Liste_Movie_Id;
BEGIN
    SELECT MOVIES_EXT.ID BULK COLLECT INTO Liste
    FROM MOVIES_EXT
    WHERE ROWNUM<6;
    packageAlimCB.alimCB(Liste);
    
    /*FOR indx IN Liste.FIRST..Liste.LAST LOOP
        dbms_output.put_line(Liste(indx));
    END LOOP;*/
END ;

select * from posters;
select * from certifications;
select * from status;
select * from films ;
select * from genres;
select * from Film_Genre;
select * from realiser;
select * from ARTISTS;
select * from jouer;

DELETE FROM JOUER;
DELETE FROM realiser;
DELETE FROM ARTISTS;
DELETE FROM Film_Genre;
DELETE FROM GENRES;
DELETE FROM films;
DELETE FROM status;
DELETE FROM certifications;
DELETE FROM posters;
commit;

SELECT directors
FROM MOVIES_EXT ;
