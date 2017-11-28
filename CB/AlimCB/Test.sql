DECLARE 
    Liste packageAlimCB.Liste_Movie_Id;
BEGIN
    SELECT MOVIES_EXT.ID BULK COLLECT INTO Liste
    FROM MOVIES_EXT
    WHERE ROWNUM<4;
    packageAlimCB.alimCB(Liste);
END ;
/

SELECT * from jouer order by 2;

select * from posters;
select * from certifications;
select * from films ;
select * from genres;
select * from Film_Genre;
select * from realiser;
select * from ARTISTS;
select * from jouer;
select * from FILMS_COPIES;
select * FROM ERRORS_LOGS;

delete from FILMS_COPIES;
DELETE FROM JOUER;
DELETE FROM realiser;
DELETE FROM ARTISTS;
DELETE FROM Film_Genre;
DELETE FROM GENRES;
DELETE FROM films;
DELETE FROM certifications;
DELETE FROM posters;
commit;

select * FROM ERRORS_LOGS;
delete from ERRORS_LOGS;
commit;

DECLARE 
    Liste packageAlimCB.Liste_Movie_Id;
BEGIN
    SELECT MOVIES_EXT.ID BULK COLLECT INTO Liste
    FROM MOVIES_EXT
    WHERE ROWNUM<6;
    packageAlimCB.alimCB(Liste);

    FOR indx IN Liste.FIRST..Liste.LAST LOOP
        dbms_output.put_line(Liste(indx));
    END LOOP;
END ;