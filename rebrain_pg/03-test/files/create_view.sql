create view get_last_10_records_from_auditlog as select * from users where record_date > now() and record_date <= (now() - interval '1 day') limit 10;
