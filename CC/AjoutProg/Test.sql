DECLARE
    DIR Varchar2(25):='DIRTESTPROG';
    File Varchar2(25):='prog.xml';
BEGIN

    PACKAGE_AJOUTPROG.LOAD_FILE(DIR,File);
END;
/

select * from ERRORS_LOGS;
delete from ERRORS_LOGS;
commit;