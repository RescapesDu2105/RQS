CREATE OR REPLACE VIEW archive_views AS
    select arch_simple.idarchive , arch_simple.idfilm,arch_complexe.*, arch_simple.pereniteglobale , 
        arch_simple.populariteglobale ,arch_simple.copiesglobale
    from archives a,  
        XMLTABLE('/archive' 
            PASSING a.OBJECT_VALUE
            COLUMNS
                idarchive NUMBER PATH 'idarchive',
                idfilm NUMBER(2) PATH 'idfilm',
                complexes XMLTYPE path 'complexes/complexeperinitevarraytuple',
                pereniteglobale varchar2(10) PATH 'pereniteglobale',
                populariteglobale varchar2(10) PATH 'populariteglobale',
                copiesglobale varchar2(10) PATH 'copiesglobale'
                ) arch_simple,
        XMLTABLE('complexeperinitevarraytuple' 
            PASSING arch_simple.complexes
            COLUMNS
                idcomplexes NUMBER PATH 'idcomplexes',
                complexeperenite NUMBER PATH 'complexeperenite',
                complexepopularite NUMBER PATH 'complexepopularite')arch_complexe;
    