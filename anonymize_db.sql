#anonymize_db.sql
update eperson set email = 'test+' || eperson_id || '@jhu.edu';
update eperson set netid = eperson_id;
update eperson set jhu_hopkinsid = eperson_id;
update eperson set jhu_jhedid = eperson_id;
update eperson set phone = '410-555-1212';
truncate registrationdata
