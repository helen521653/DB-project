CREATE OR REPLACE FUNCTION log_last_user_info_changes()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE' ) THEN 
		INSERT INTO cd.user_version (user_id,user_nm, phone_number_no, hashed_password_series, change_dttm) 
		 VALUES (NEW.user_id,NEW.user_nm,NEW.phone_number_no, NEW.hashed_password_series, NOW());
	END IF;
	RETURN NULL;
END;
$$;

CREATE TRIGGER last_user_info_changes
  AFTER INSERT OR UPDATE
  ON cd.user
  FOR EACH ROW
  EXECUTE PROCEDURE log_last_user_info_changes();
  
select * from cd.user_version;
select * from cd.user;
INSERT INTO cd.user(user_nm, phone_number_no, hashed_password_series) VALUES
('Little John Smith', '123-456-7890', 'hjgfdklsfjg');
UPDATE cd.user SET user_nm = 'Super PUPER'
WHERE user_id = 10;

------------------------------------------------------------
CREATE OR REPLACE FUNCTION event_status_update()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF (NEW.status <> OLD.status ) THEN
		 INSERT INTO cd.event_status (event_id,new_status, change_dttm) 
		 VALUES (OLD.event_id,OLD.new_status,NOW());
	END IF;
	RETURN NEW;
END;
$$;

CREATE TRIGGER event_status_changes
  BEFORE UPDATE
  ON cd.event
  FOR EACH ROW
  EXECUTE PROCEDURE event_status_update();
  
select* from cd.event
select* from cd.event_status

--------------------------------------------------------------
CREATE OR REPLACE FUNCTION group_user_admin()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		 INSERT INTO cd.group_user(group_id,user_id) VALUES
			(NEW.group_id, NEW.admin);
	END IF;
	RETURN NEW;
END;
$$;

CREATE TRIGGER event_status_changes
  AFTER INSERT
  ON cd.group
  FOR EACH ROW
  EXECUTE PROCEDURE group_user_admin();

select * from cd.group; 
select* from cd.group_user;
INSERT INTO cd.group(group_nm,admin) VALUES
('WINKS', 21);