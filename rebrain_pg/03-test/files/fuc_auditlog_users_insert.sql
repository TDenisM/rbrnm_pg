CREATE FUNCTION fnc_auditlog_users_insert() RETURNS trigger

LANGUAGE plpgsql AS

$$

BEGIN

INSERT INTO auditlog(user_id, creation_time, creator) VALUES (NEW.user_id, now(), (SELECT current_user));

  RETURN NEW;

END;

$$;
