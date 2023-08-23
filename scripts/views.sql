--выбор всех событий (и групповых и личных для конкретного пользователя)
CREATE OR REPLACE VIEW user_events AS
SELECT 
    f.user_id,
    cd.event.event_nm,
	cd.event.event_dttm
FROM (cd.group_user
	LEFT JOIN cd.group_event ON cd.group_event.group_id = cd.group_user.group_id) f
	LEFT JOIN cd.event ON cd.event.event_id = f.event_id
WHERE f.user_id = 1
UNION ALL
SELECT 
	cd.user.user_id,
    cd.event.event_nm,
	cd.event.event_dttm
FROM cd.user_event
LEFT JOIN cd.user ON cd.user.user_id = cd.user_event.user_id
LEFT JOIN cd.event ON cd.event.event_id = cd.user_event.event_id
WHERE cd.user.user_id = 1

select * from user_events

--все пользователи в алфавитном порядке (без технической) о пользователях со спрятанным номером телефона(_**-***-*__)
CREATE OR REPLACE VIEW users AS
SELECT 
	cd.user.user_nm,
	SUBSTR(cd.user.phone_number_no, 1, 1) || '**-***-*' || SUBSTR(cd.user.phone_number_no, 10, 3) AS phone_number
FROM cd.user
	ORDER BY cd.user.user_nm
	
select * from users

--все группы определённого пользователя (c user_id = 1) с их админами, и номерами телефонов 
CREATE OR REPLACE VIEW user_groups AS
SELECT 
	f.group_nm as your_groups,
	cd.user.user_nm as admin_of_group,
	SUBSTR(cd.user.phone_number_no, 1, 1) || '**-***-*' || SUBSTR(cd.user.phone_number_no, 10, 3) AS admin_phone_number
FROM (cd.group_user
	LEFT JOIN cd.group ON cd.group.group_id = cd.group_user.group_id) f
	LEFT JOIN cd.user ON cd.user.user_id = f.admin
WHERE f.user_id = 1
select * from user_groups
