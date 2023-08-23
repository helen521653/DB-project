
--группы и количество пользователей в них 
SELECT
    DISTINCT cd.group.group_nm,
    count(cd.group_user.user_id) 
	OVER (PARTITION BY cd.group.group_nm) AS user_in_group
FROM cd.group_user
	LEFT JOIN cd.group ON cd.group.group_id = cd.group_user.group_id;

--пользователи и их события, ранжированные по дате 
SELECT 
	cd.user.user_nm, 
	ROW_NUMBER() OVER (PARTITION BY cd.user.user_nm ORDER BY cd.event.event_dttm ),
	cd.event.event_nm
FROM cd.user_event
LEFT JOIN cd.user ON cd.user.user_id = cd.user_event.user_id
LEFT JOIN cd.event ON cd.event.event_id = cd.user_event.event_id;

--пользователь и его профиль сейчас и при регистрации 
SELECT 
	cd.user.user_nm as name, 
	cd.user.phone_number_no as phone_number, 
	cd.user.hashed_password_series as hashed_password, 
	first_value(cd.user_version.user_nm) OVER w AS first_name, 
	first_value(cd.user_version.phone_number_no) OVER w  as first_phone_number, 
	first_value(cd.user_version.hashed_password_series) OVER w  as first_hashed_password
FROM cd.user_version
LEFT JOIN cd.user ON cd.user.user_id = cd.user_version.user_id
WINDOW 
    w AS (PARTITION BY cd.user_version.user_id ORDER BY change_dttm );



--пользователи у которых есть ненаступившие события и количество этих событий
SELECT
    DISTINCT cd.user.user_nm,
	COUNT(cd.event.event_dttm)
	OVER (PARTITION BY cd.user.user_id) AS future_events
FROM cd.user_event
LEFT JOIN cd.user ON cd.user.user_id = cd.user_event.user_id
LEFT JOIN cd.event ON cd.event.event_id = cd.user_event.event_id
WHERE event.event_dttm > NOW()


--количество периодичных событий у пользователя 
SELECT 
	cd.user.user_nm as name,
	count(cd.event.event_id) as period_events	
FROM cd.user_event
LEFT JOIN cd.user ON cd.user.user_id = cd.user_event.user_id
LEFT JOIN cd.event ON cd.event.event_id = cd.user_event.event_id
WHERE cd.event.period is not null 
GROUP BY cd.user.user_id
HAVING count(cd.event.event_id)>0

--количество пользователей, задействованных в событии
SELECT 
	cd.event.event_nm,
	cd.event.event_dttm,
	COUNT(cd.user.user_id)
FROM cd.user_event
LEFT JOIN cd.user ON cd.user.user_id = cd.user_event.user_id
LEFT JOIN cd.event ON cd.event.event_id = cd.user_event.event_id
GROUP BY cd.event.event_id
	
