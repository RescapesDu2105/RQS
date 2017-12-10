create or replace PACKAGE BODY package_AlimCC
AS
    PROCEDURE Take_Copy AS
        nbCopys NUMBER(2,0);
        l_copy Liste_Copie;
        l_copy_temp Liste_Copie;
        i NUMBER;
        isPresent boolean;
    BEGIN
    
        select abs(((DBMS_RANDOM.NORMAL)*COUNT(*))/6+1) INTO nbCopys
        FROM films_copies;
        IF nbCopys>0 THEN
            i:=1;
            FOR l_copy_temp IN (select * from films_copies order by dbms_random.value)
            LOOP
                EXIT WHEN i > nbCopys;
                l_copy(i) := l_copy_temp;
                i:=i+1;
            END LOOP;
            
            l_copy_temp.DELETE;
            
            l_copy_temp(1).movie:=l_copy(1).movie;
            FOR indx IN l_copy.FIRST .. l_copy.LAST LOOP
                isPresent:=false;
                FOR jndx IN l_copy_temp.first .. l_copy_temp.LAST LOOP
                    IF l_copy(indx).movie=l_copy_temp(jndx).movie THEN
                        isPresent:=true;
                    END IF;
                END LOOP;
                IF isPresent=false THEN
                    l_copy_temp(l_copy_temp.LAST+1):=l_copy(indx);
                END IF;
            END LOOP;
            
        END IF;
             
    END Take_Copy;

    PROCEDURE Check_MovieDescription(l_copy IN Liste_Copie , p_complexe IN NUMBER) AS
        id_temp films.idFilm%TYPE;
        requeteBlock varchar2(2000);
    BEGIN
        
        NULL;/*SELECT disctinct *
        FROM l_copy;*/
        
        /*FOR indx IN l_copy.FIRST .. l_copy.LAST LOOP

        END LOOP;*/
    END Check_MovieDescription;
END package_AlimCC;
--dbms_output.put_line(Liste(indx));