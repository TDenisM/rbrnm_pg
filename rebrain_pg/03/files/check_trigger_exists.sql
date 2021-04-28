select trigger_name
from information_schema.triggers
where trigger_name ~~ 'insert_into_users_trigger';
