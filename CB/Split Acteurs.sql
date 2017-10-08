-- ․ ‖

with split(champs, debut, fin) as 
(
    Select actors , 1 debut, instr(actors,'‖') fin 
    from movies_ext
    union all
    select champs, fin + 1, instr(champs, '‖', fin+1)
    from split
    where fin <> 0
)
select distinct
cast(substr(tuple, 1, instr(tuple, '․') -1) as number) id,
SUBSTR(tuple, instr(tuple, '․')+1, instr(tuple, '․', 1, 2) - instr(tuple, '․')-1) actors,
substr(tuple, instr(tuple, '․', 1, 2)+1, LENGTH(tuple) - instr(tuple, '․', 1, 2)) roles
from(
    SELECT SUBSTR(champs, debut, coalesce(fin, length(champs)+1) - debut) tuple
    FROM split -- 1.593.318
    WHERE champs IS NOT NULL --1.456.115
);