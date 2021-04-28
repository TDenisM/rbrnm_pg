SELECT routine_name
FROM information_schema.routines
WHERE routine_type='FUNCTION'
  AND specific_schema='public'
  AND routine_name ~~ 'fnc_auditlog%'
;
