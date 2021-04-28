CREATE TRIGGER insert_into_users_trigger

  AFTER INSERT ON users

  FOR EACH ROW

  EXECUTE PROCEDURE fnc_auditlog_users_insert();
