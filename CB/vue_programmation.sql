CREATE OR REPLACE VIEW Programmations_view AS
select x.*
from PROGRAMMATIONS p,  
XMLTABLE('/programmation' 
    PASSING p.OBJECT_VALUE
    COLUMNS
        idDemande NUMBER PATH 'idDemande',
        complexe NUMBER(2) PATH 'complexe',
        debut varchar2(10) PATH 'debut',
        fin varchar2(10) PATH 'fin',
        movie NUMBER(10) PATH 'movie',
        copy NUMBER(10) PATH 'copy',
        salle NUMBER(10) PATH 'salle',
        heure varchar2(10) PATH 'heure') x;