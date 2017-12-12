BEGIN
    DBMS_SCHEDULER.create_job (
        job_name => 'job_AlimCC',
        job_type => 'STORED_PROCEDURE',
        job_action => 'package_AlimCC.AlimCC',
        start_date => SYSTIMESTAMP,
        repeat_interval => 'FREQ=WEEKLY',
        enabled => TRUE,
        comments => 'pas obligatoire mais un bon com…');
END;