create view get_last_10_records_from_auditlog as select * from auditlog where creation_time < now() and creation_time >= (now() - interval '1 day') limit 10;
