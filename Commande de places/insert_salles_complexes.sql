--en tant que cb :
INSERT INTO complexes VALUES (1,'Liege');
INSERT INTO complexes VALUES (2,'Neupre');
INSERT INTO complexes VALUES (3,'Seraing');
INSERT INTO complexes VALUES (4,'Herstal');
INSERT INTO complexes VALUES (5,'Ougree');
INSERT INTO complexes VALUES (6,'Flemalle');
commit;

BEGIN
    FOR i IN 1..6 LOOP
        FOR j IN 1..6 LOOP
            INSERT INTO salles(numsalle,nbplaces,idcomplexe)
                VALUES(j,120,i);
        END LOOP;
    END LOOP;
    commit;
END ;
/

select * from complexes;
select * from salles;