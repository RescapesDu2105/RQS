BEGIN
DECLARE
    fichierStat  utl_file.file_type;
    requeteBlock varchar2(10000);
    TYPE Liste_Col IS TABLE OF VARCHAR2(25);
    l_col Liste_Col;
    
    TYPE resultStat IS RECORD
	(
		col varchar2(50),
		function varchar2(50),
		value varchar2(50)
	);
  
    TYPE resultsStat is table OF resultStat;

	resultats resultsStat;
    	prev varchar2(50);
    
	PROCEDURE save_file(tab IN resultsStat) is 
	BEGIN
        FOR indx IN 1 .. tab.COUNT LOOP
             IF coalesce(prev, '-') != tab(indx).col THEN
                IF  UPPER(tab(indx).col) LIKE 'IDE' THEN
                    utl_file.put_line(fichierStat, ' ');
                    utl_file.put_line(fichierStat, replace(tab(indx-1).col || '-ID :', '_', ' '));
                    utl_file.put_line(fichierStat, RPAD('-', 35, '-'));
                else 
                    utl_file.put_line(fichierStat, ' ');
                    utl_file.put_line(fichierStat, replace(tab(indx).col || ' : ', '_', ' '));
                    utl_file.put_line(fichierStat, RPAD('-', 35, '-'));
                end if ;
             END IF;
              utl_file.put_line(fichierStat,
                LPAD(
              CASE tab(indx).function 
                WHEN 'MIN' THEN 'Minimum'
                WHEN 'MAX' THEN 'Maximum'
                WHEN 'AVG' THEN 'Moyenne'
                WHEN 'STDDEV' THEN 'Ecart-type'
                WHEN 'MEDIAN' THEN 'Médiane'
                WHEN 'COUNT' THEN 'Nombre d''élements'
                WHEN 'Q95' THEN '95ème 100ème quantile'
                WHEN 'Q995' THEN '995ème 1000quantile'
                WHEN 'NBNULL' THEN 'Valeurs NULL'
                WHEN 'UNIQUE' THEN 'Valeur unique(s)'
                ELSE tab(indx).function
              END
              , 23, ' ') || ' : ' ||
                RPAD(tab(indx).value, 15, ' '));
              prev := tab(indx).col;
        END LOOP;
	END save_file;

    BEGIN
        fichierStat := utl_file.fopen ('MYDIR', 'AnalyseCI.txt', 'W');
        utl_file.put_line (fichierStat, 'Statistiques colonnes');
        utl_file.put_line (fichierStat, RPAD('-', 35, '-'));
                 
        SELECT 'SELECT substr(aliases, 1, instr(aliases, ''_'') -1),substr(aliases, instr(aliases, ''_'')+1, length(aliases) - instr(aliases, ''_'')), 
        value from(SELECT ' || 
        listagg(
            CASE dt
            WHEN 'VARCHAR2' THEN
                CASE 
                    WHEN col = 'CERTIFICATION' OR col = 'STATUS' THEN 'COUNT(DISTINCT '|| col ||') '|| col ||'_unique,'
                END ||
                'MIN(LENGTH('|| col ||')) '|| col ||'_min,' || 
                'MAX(LENGTH('|| col ||')) '|| col ||'_max,' || 
                'ROUND(AVG(LENGTH('|| col ||')),2) '|| col ||'_moy,' || 
                'ROUND(STDDEV(LENGTH('|| col ||')),2) '|| col ||'_ecarttype,' ||  
                'ROUND(MEDIAN(LENGTH('|| col ||')),2) '|| col ||'_medianne,' ||  
                'COUNT(LENGTH('|| col ||')) '|| col ||'_count,' ||  
                'PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY LENGTH('|| col ||')) '|| col ||'_q95,' || 
                'PERCENTILE_CONT(0.995) WITHIN GROUP(ORDER BY LENGTH('|| col ||')) '|| col ||'_q995,' || 
                'COUNT(NVL2(LENGTH('|| col ||'), NULL, 1)) '|| col ||'_nbnull'
        
            WHEN 'NUMBER' THEN 
                'MIN('|| col ||') '|| col ||'_min,' || 
                'MAX('|| col ||') '|| col ||'_max,' || 
                'ROUND(AVG('|| col ||'), 2) '|| col ||'_moy,' || 
                'ROUND(STDDEV('|| col ||'), 2) '|| col ||'_ecarttype,' ||  
                'ROUND(MEDIAN('|| col ||'), 2) '|| col ||'_medianne,' ||  
                'COUNT('|| col ||') '|| col ||'_count,' || 
                'PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY '|| col ||') '|| col ||'_q95,' || 
                'PERCENTILE_CONT(0.995) WITHIN GROUP(ORDER BY '|| col ||') '|| col ||'_q995,' || 
                'COUNT(NVL2('|| col ||', NULL, 1)) '|| col ||'_nbnull'
          END, ', ')
        WITHIN group (order by col) || 
        ' FROM movies_ext)' ||
        ' UNPIVOT (value for aliases in('|| listagg(CASE WHEN col = 'CERTIFICATION' OR col = 'STATUS' THEN col ||'_unique, 'END || col || '_min, ' || col || '_max, ' ||col || '_moy, ' ||col || '_ecarttype, ' ||col || '_medianne, ' ||col || '_count, ' ||col || '_q95, ' ||col || '_q995, ' ||col || '_nbnull', ', ') within group(order by col) ||'))'
        query
        into requeteBlock
        from (select column_name col, data_type dt
              from user_tab_columns
              where table_name = 'MOVIES_EXT'  
              and column_name in ('ID', 'TITLE', 'STATUS','VOTE_AVERAGE','VOTE_COUNT','RUNTIME','CERTIFICATION'));
              
        Execute IMMEDIATE requeteBlock BULK COLLECT INTO resultats;
        save_file(resultats);
        Ajout_Log_Info(CURRENT_TIMESTAMP, 'Ligne 101 - ', 'Fin analyse des colonnes VARCHAR2 et NUMBER');
        
        l_col:=Liste_Col('GENRES','DIRECTORS');
        FOR indx IN 1 .. l_col.count LOOP
            requeteBlock := '
            SELECT substr(aliases, 1, instr(aliases, ''_'') -1),substr(aliases, instr(aliases, ''_'')+1, length(aliases) - instr(aliases, ''_'')), 
            value
            FROM
            (
              SELECT 
              MIN(ide) ide_'|| l_col(indx) ||'_min,
              MAX(ide) ide_'|| l_col(indx) ||'_max,
              ROUND(AVG(ide),2) ide_'|| l_col(indx) ||'_moy, 
              ROUND(STDDEV(ide),2) ide_'|| l_col(indx) ||'_ecarttype,  
              ROUND(MEDIAN(ide),2) ide_'|| l_col(indx) ||'_medianne,  
              COUNT(ide) ide_'|| l_col(indx) ||'_count,  
              PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY ide) ide_'|| l_col(indx) ||'_q95,
              PERCENTILE_CONT(0.995) WITHIN GROUP(ORDER BY ide) ide_'|| l_col(indx) ||'_q995, 
              COUNT(NVL2(ide, NULL, 1)) ide_'|| l_col(indx) ||'_nbnull,
              min(LENGTH(nom)) '|| l_col(indx) ||'_min, 
              max(LENGTH(nom)) '|| l_col(indx) ||'_max, 
              ROUND(avg(LENGTH(nom)),2) '|| l_col(indx) ||'_moy, 
              ROUND(stddev(LENGTH(nom)),2) '|| l_col(indx) ||'_ecarttype, 
              ROUND(median(LENGTH(nom)),2) '|| l_col(indx) ||'_medianne, 
              count(LENGTH(nom)) '|| l_col(indx) ||'_count, 
              PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY LENGTH(nom)) '|| l_col(indx) ||'_q95, 
              PERCENTILE_CONT(0.995) WITHIN GROUP(ORDER BY LENGTH(nom)) '|| l_col(indx) ||'_q995, 
              COUNT(NVL2(LENGTH(nom), NULL, 1)) '|| l_col(indx) ||'_nbnull
              FROM (
                 with split(champs, debut, fin) as 
                (
                  Select '|| l_col(indx) ||' , 1 debut, regexp_instr('||l_col(indx)||',''‖'') fin from movies_ext
                  union all
                  select champs, fin + 1, regexp_instr(champs, ''‖'', fin+1)
                  from split
                  where fin <> 0
                )
                    select *
                    from(
                        select distinct
                        cast(REGEXP_SUBSTR(champs,''[^․]+'') as number) ide,
                        SUBSTR(REGEXP_SUBSTR(champs,''[^‖]+''),cast((regexp_instr(champs,''․'')+1)as number))as nom
                        from split)
                        where ide is not null 
                        and nom is not null
                        )
            )
            UNPIVOT(value for aliases IN(
            '|| l_col(indx) ||'_min, '|| l_col(indx) ||'_max, '|| l_col(indx) ||'_moy, '|| l_col(indx) ||'_ecarttype, '
            || l_col(indx) ||'_medianne, '|| l_col(indx) ||'_count, '|| l_col(indx) ||'_q95, '|| l_col(indx) ||'_q995, '
            || l_col(indx) ||'_nbnull, '|| 
            'ide_'||l_col(indx) ||'_min, '|| 'ide_'||l_col(indx) ||'_max, '|| 
            'ide_'||l_col(indx) ||'_moy, '|| 'ide_'||l_col(indx) ||'_ecarttype, '|| 'ide_'||l_col(indx) ||'_medianne, '|| 
            'ide_'||l_col(indx) ||'_count, '|| 'ide_'||l_col(indx) ||'_q95, '|| 'ide_'||l_col(indx) ||'_q995, '|| 
            'ide_'||l_col(indx) ||'_nbnull))';
            EXECUTE IMMEDIATE requeteBlock BULK COLLECT INTO resultats;
            save_file(resultats);
            END LOOP;
            Ajout_Log_Info(CURRENT_TIMESTAMP, 'Ligne 160 - ', 'Fin analyse des genres et directors');
            
            SELECT substr(aliases, 1, instr(aliases, '_') -1),substr(aliases, instr(aliases, '_')+1, length(aliases) - instr(aliases, '_')), 
            value
            BULK COLLECT INTO resultats
            FROM
            (
              SELECT 
              min(LENGTH(actors)) actors_min, 
              max(LENGTH(actors)) actors_max, 
              ROUND(avg(LENGTH(actors)),2) actors_moy, 
              ROUND(stddev(LENGTH(actors)),2) actors_ecarttype, 
              ROUND(median(LENGTH(actors)),2) actors_medianne, 
              count(LENGTH(actors)) actors_count, 
              PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY LENGTH(actors)) actors_q95, 
              PERCENTILE_CONT(0.995) WITHIN GROUP(ORDER BY LENGTH(actors)) actors_q995,
              MIN(ide) ide_actors_min,
              MAX(ide) ide_actors_max,
              ROUND(AVG(ide),2) ide_actors_moy, 
              ROUND(STDDEV(ide),2) ide_actors_ecarttype,  
              ROUND(MEDIAN(ide),2) ide_actors_medianne,  
              COUNT(ide) ide_actors_count,  
              PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY ide) ide_actors_q95,
              PERCENTILE_CONT(0.995) WITHIN GROUP(ORDER BY ide) ide_actors_q995, 
              min(LENGTH(roles)) roles_min, 
              max(LENGTH(roles)) roles_max, 
              ROUND(avg(LENGTH(roles)),2) roles_moy, 
              ROUND(stddev(LENGTH(roles)),2) roles_ecarttype, 
              ROUND(median(LENGTH(roles)),2) roles_medianne, 
              count(LENGTH(roles)) roles_count, 
              PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY LENGTH(roles)) roles_q95, 
              PERCENTILE_CONT(0.995) WITHIN GROUP(ORDER BY LENGTH(roles)) roles_q995,
              COUNT(NVL2(roles, NULL, 1)) roles_actors_nbnull		  
              FROM (
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
                    cast(substr(tuple, 1, instr(tuple, '․') -1) as number) ide,
                    SUBSTR(tuple, instr(tuple, '․')+1, instr(tuple, '․', 1, 2) - instr(tuple, '․')-1) actors,
                    substr(tuple, instr(tuple, '․', 1, 2)+1, LENGTH(tuple) - instr(tuple, '․', 1, 2)) roles
                    from(
                        SELECT SUBSTR(champs, debut, coalesce(fin, length(champs)+1) - debut) tuple
                        FROM split -- 1.593.318
                        WHERE champs IS NOT NULL --1.456.115
                        )
                    )
            )
        UNPIVOT (value for aliases IN (actors_min,actors_max,actors_ecarttype,actors_medianne,actors_count,actors_q95,actors_q995,
                                        ide_actors_min,ide_actors_max,ide_actors_moy,ide_actors_ecarttype,ide_actors_medianne,
                                        ide_actors_count,ide_actors_q95,ide_actors_q995,roles_min,roles_max,roles_moy,
                                        roles_ecarttype,roles_medianne,roles_count,roles_q95,roles_q995,roles_actors_nbnull));
        save_file(resultats);
        Ajout_Log_Info(CURRENT_TIMESTAMP, 'Ligne 219 - ', 'Fin analyse des acteurs');
        
        SELECT substr(aliases, 1, instr(aliases, '_') -1),substr(aliases, instr(aliases, '_')+1, length(aliases) - instr(aliases, '_')), 
        value
        BULK COLLECT INTO resultats 
        from (
          select 
          to_char(MIN(release_date), 'DD/MM/YYYY') releaseDate_min,
          to_char(MIN(LENGTH(release_date))) releaseDate_length_min,
          to_char(MAX(release_date), 'DD/MM/YYYY') releaseDate_max,
          to_char(MAX(LENGTH(release_date))) releaseDate_length_MAX,
          to_char(ROUND(AVG(EXTRACT(month from release_date)))) releaseDate_moyenne_mois,
          to_char(ROUND(AVG(EXTRACT(year from release_date)))) releaseDate_moyenne_annees,
          to_char(ROUND(MEDIAN(EXTRACT(month from release_date)))) releaseDate_mediane_mois,
          to_char(ROUND(MEDIAN(EXTRACT(year from release_date)))) releaseDate_mediane_annees,
          to_char(ROUND(AVG(LENGTH(release_date)))) releaseDate_length_moyenne,
          to_char(COUNT(release_date)) releaseDate_count,  
          to_char(COUNT(NVL2(release_date, NULL, 1))) releaseDate_nbNULL
          from movies_ext)
        UNPIVOT (value for aliases in (releaseDate_min,releaseDate_length_min, releaseDate_max,releaseDate_length_MAX, 
        releaseDate_moyenne_annees, releaseDate_moyenne_mois,releaseDate_mediane_annees ,releaseDate_length_moyenne
        ,releaseDate_mediane_mois, releaseDate_count, releaseDate_nbNULL));
        save_file(resultats);
        Ajout_Log_Info(CURRENT_TIMESTAMP, 'Ligne 242 - ', 'Fin analyse des dates');
        
        utl_file.fclose(fichierStat);
        
    EXCEPTION
    WHEN OTHERS THEN utl_file.fclose(fichierStat);
    Ajout_Log_Error(CURRENT_TIMESTAMP, 'ANALYSE CI', SQLCODE, SQLERRM);    
    RAISE ;    
    END ;
END ;