with split(champs, debut, fin) as 
            (
              Select actors , 1 debut, regexp_instr(actors,'‖') fin from movies_ext
              union all
              select champs, fin + 1, regexp_instr(champs, '‖', fin+1)
              from split
              where fin <> 0
            )
select   *              
from(
        select distinct
        cast(REGEXP_SUBSTR(champs,'[^․]+') as number) id,
        SUBSTR(REGEXP_SUBSTR(champs,'[^‖]+'),cast((regexp_instr(champs,'․')+1)as number))as nom,
        REGEXP_SUBSTR(actors,'[^․]+[‖$]') as role
        from split)
        where id is not null 
        and nom is not null;