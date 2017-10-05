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
    dbms_output.put_line(tab(indx).col);
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
        WHEN 'Q9995' THEN '9995ème 10000quantile'
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
             
    SELECT 'SELECT substr(aliases, 1, instr(aliases, ''_'') -1),substr(aliases, instr(aliases, ''_'')+1, length(aliases) - instr(aliases, ''_'')), value from(SELECT ' || 
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
            'PERCENTILE_CONT(0.9995) WITHIN GROUP(ORDER BY LENGTH('|| col ||')) '|| col ||'_q9995,' || 
            'COUNT(NVL2(LENGTH('|| col ||'), NULL, 1)) '|| col ||'_nbnull'
    
        WHEN 'NUMBER' THEN 
            'MIN('|| col ||') '|| col ||'_min,' || 
            'MAX('|| col ||') '|| col ||'_max,' || 
            'ROUND(AVG('|| col ||'), 2) '|| col ||'_moy,' || 
            'ROUND(STDDEV('|| col ||'), 2) '|| col ||'_ecarttype,' ||  
            'ROUND(MEDIAN('|| col ||'), 2) '|| col ||'_medianne,' ||  
            'COUNT('|| col ||') '|| col ||'_count,' || 
            'PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY '|| col ||') '|| col ||'_q95,' || 
            'PERCENTILE_CONT(0.9995) WITHIN GROUP(ORDER BY '|| col ||') '|| col ||'_q9995,' || 
            'COUNT(NVL2('|| col ||', NULL, 1)) '|| col ||'_nbnull'
      END, ', ')
    WITHIN group (order by col) || 
    ' FROM movies_ext)' ||
    ' UNPIVOT (value for aliases in('|| listagg(CASE WHEN col = 'CERTIFICATION' OR col = 'STATUS' THEN col ||'_unique, 'END || col || '_min, ' || col || '_max, ' ||col || '_moy, ' ||col || '_ecarttype, ' ||col || '_medianne, ' ||col || '_count, ' ||col || '_q95, ' ||col || '_q9995, ' ||col || '_nbnull', ', ') within group(order by col) ||'))'
    query
    into requeteBlock
    from (select column_name col, data_type dt
          from user_tab_columns
          where table_name = 'MOVIES_EXT'  
          and column_name in ('ID', 'TITLE', 'STATUS','VOTE_AVERAGE','VOTE_COUNT','RUNTIME','CERTIFICATION'));
          
    Execute IMMEDIATE requeteBlock BULK COLLECT INTO resultats;
    save_file(resultats);
    
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
          PERCENTILE_CONT(0.9995) WITHIN GROUP(ORDER BY ide) ide_'|| l_col(indx) ||'_q9995, 
          COUNT(NVL2(ide, NULL, 1)) ide_'|| l_col(indx) ||'_nbnull,
          min(LENGTH(nom)) '|| l_col(indx) ||'_min, 
          max(LENGTH(nom)) '|| l_col(indx) ||'_max, 
          ROUND(avg(LENGTH(nom)),2) '|| l_col(indx) ||'_moy, 
          ROUND(stddev(LENGTH(nom)),2) '|| l_col(indx) ||'_ecarttype, 
          ROUND(median(LENGTH(nom)),2) '|| l_col(indx) ||'_medianne, 
          count(LENGTH(nom)) '|| l_col(indx) ||'_count, 
          PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY LENGTH(nom)) '|| l_col(indx) ||'_q95, 
          PERCENTILE_CONT(0.9995) WITHIN GROUP(ORDER BY LENGTH(nom)) '|| l_col(indx) ||'_q9995, 
          COUNT(NVL2(LENGTH(nom), NULL, 1)) '|| l_col(indx) ||'_nbnull
          FROM (
             with split(champs, debut, fin) as 
            (
              Select '|| l_col(indx) ||' , 1 debut, instr('||l_col(indx)||',''‖'') fin from movies_ext
              union all
              select champs, fin + 1, instr(champs, ''‖'', fin+1)
              from split
              where fin <> 0
            )
                select *
                from(
                    select distinct
                    cast(REGEXP_SUBSTR(champs,''[^․]+'') as number) ide,
                    SUBSTR(REGEXP_SUBSTR(champs,''[^‖]+''),cast((instr(champs,''․'')+1)as number))as nom
                    from split)
                    where ide is not null 
                    and nom is not null
                    )
		)
		UNPIVOT(value for aliases IN(
        '|| l_col(indx) ||'_min, '|| l_col(indx) ||'_max, '|| l_col(indx) ||'_moy, '|| l_col(indx) ||'_ecarttype, '|| l_col(indx) ||'_medianne, '|| l_col(indx) ||'_count, '|| l_col(indx) ||'_q95, '|| l_col(indx) ||'_q9995, '|| l_col(indx) ||'_nbnull, '|| 
        'ide_'||l_col(indx) ||'_min, '|| 'ide_'||l_col(indx) ||'_max, '|| 
        'ide_'||l_col(indx) ||'_moy, '|| 'ide_'||l_col(indx) ||'_ecarttype, '|| 'ide_'||l_col(indx) ||'_medianne, '|| 
        'ide_'||l_col(indx) ||'_count, '|| 'ide_'||l_col(indx) ||'_q95, '|| 'ide_'||l_col(indx) ||'_q9995, '|| 
        'ide_'||l_col(indx) ||'_nbnull))';
	    EXECUTE IMMEDIATE requeteBlock BULK COLLECT INTO resultats;
	    save_file(resultats);
        /*FOR i IN 1 .. resultats.count
        LOOP
            dbms_output.put_line(resultats(i).col || ' ' || resultats(i).function || ' ' || resultats(i).value);
        end loop;*/
	END LOOP;
    utl_file.fclose(fichierStat);
    END ;
END ;