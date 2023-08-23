

CREATE SCHEMA cd;

CREATE TABLE cd.user(
   user_id                  SERIAL                  NOT NULL,
   user_nm                  CHARACTER VARYING(200)  NOT NULL,
   phone_number_no          CHARACTER VARYING(20)   NOT NULL,
   hashed_password_series   TEXT                    NOT NULL,

   CONSTRAINT user_pk PRIMARY KEY (user_id)

);

CREATE TABLE cd.user_version(
   user_id                  INTEGER                    NOT NULL, 
   user_nm                  CHARACTER VARYING(200)    NOT NULL, 
   phone_number_no          CHARACTER VARYING(20)     NOT NULL,
   hashed_password_series   TEXT                      NOT NULL,
   change_dttm              TIMESTAMP                 NOT NULL,
   
   CONSTRAINT fk_version_user FOREIGN KEY (user_id) REFERENCES cd.user(user_id)
	ON DELETE CASCADE
   );
   
CREATE TABLE cd.event(
   event_id         SERIAL                     NOT NULL, 
   event_nm         CHARACTER VARYING(1000)     NOT NULL, 
   event_dttm       TIMESTAMP                   NOT NULL, 
   event_call_dttm  TIMESTAMP                   NOT NULL, 
   period           INTERVAL   , 
   status           INTEGER                 CHECK ( status IN(-1,0,1)), 
   
   CONSTRAINT event_pk PRIMARY KEY (event_id)
);

CREATE TABLE cd.event_status(
   event_id             INTEGER      NOT NULL, 
   new_status           INTEGER  CHECK ( new_status IN(-1,0,1)),
   change_dttm          TIMESTAMP   NOT NULL,
   
    CONSTRAINT fk_event_status FOREIGN KEY (event_id) REFERENCES cd.event(event_id) 
	ON DELETE CASCADE
);

CREATE TABLE cd.group(
   group_id     SERIAL                  NOT NULL, 
   group_nm     CHARACTER VARYING(200)  NOT NULL,
   admin        INTEGER                  NOT NULL,
   
   CONSTRAINT group_pk PRIMARY KEY (group_id),
   CONSTRAINT fk_admin FOREIGN KEY (admin) REFERENCES cd.user(user_id) 
	ON DELETE CASCADE
);

CREATE TABLE cd.group_user(
   group_user_id    SERIAL   NOT NULL, 
   user_id          INTEGER   NOT NULL,
   group_id         INTEGER   NOT NULL,
   
   CONSTRAINT group_user_pk PRIMARY KEY (group_user_id),
   CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES cd.user(user_id)
	ON DELETE CASCADE, 
   CONSTRAINT fk_group_id FOREIGN KEY (group_id) REFERENCES cd.group(group_id) 
	ON DELETE CASCADE
);

CREATE TABLE cd.group_event(
   group_event_id       SERIAL     NOT NULL, 
   event_id             INTEGER     NOT NULL,
   group_id             INTEGER     NOT NULL,
   
   CONSTRAINT group_event_pk PRIMARY KEY (group_event_id),
   CONSTRAINT fk_event_id FOREIGN KEY (event_id) REFERENCES cd.event(event_id)
	ON DELETE CASCADE, 
   CONSTRAINT fk_group_id FOREIGN KEY (group_id) REFERENCES cd.group(group_id)
	ON DELETE CASCADE
);

CREATE TABLE cd.user_event(
   user_event_id    SERIAL     NOT NULL, 
   user_id          INTEGER     NOT NULL,
   event_id         INTEGER     NOT NULL,
   
   CONSTRAINT user_event_pk PRIMARY KEY (user_event_id),
   CONSTRAINT fk_event_id FOREIGN KEY (event_id) REFERENCES cd.event(event_id)
	ON DELETE CASCADE, 
   CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES cd.user(user_id)
	ON DELETE CASCADE
);