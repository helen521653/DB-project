
--юзер и его групповые евенты
SELECT DISTINCT cd.group_user.user_id, cd.group_event.event_id FROM cd.group 
INNER JOIN cd.group_user ON cd.group_user.group_id = cd.group.group_id
INNER JOIN cd.group_event ON cd.group_event.group_id = cd.group.group_id
;

--юзер  и все его евенты, получается то же самое, что и в предыдущем
SELECT cd.user.user_id, cd.event.event_id FROM cd.user_event 
INNER JOIN cd.user ON cd.user.user_id = cd.user_event.user_id
INNER JOIN cd.event ON cd.event.event_id = cd.user_event.event_id
;

UPDATE cd.event SET event_nm = 'Super Birthday'
WHERE event_nm = 'Birthday';
UPDATE cd.event SET period = null
WHERE event_nm IN('Performance', 'Test','Fair');

DELETE FROM cd.event WHERE status = -1;

--удалим всех админов, с ними должны удалиться и группы, 
--а с группами - их евенты
DELETE FROM cd.user
WHERE cd.user.user_id IN ( SELECT cd.group.admin FROM 
cd.group)				
select * from cd.group_user
select * from cd.user
select * from cd.group_event


INSERT INTO cd.user (user_nm, phone_number_no, hashed_password_series) VALUES 
 ('Gilderoy Lockhart Jr.', '867-5309', 'uiyfvuycot');
INSERT INTO cd.user (user_nm, phone_number_no, hashed_password_series) VALUES 
('Hermione Granger-Watson', '555-1234', 'kyfocuugtotyciy');
select * from cd.user;
INSERT INTO cd.group(group_nm,admin) VALUES
('ClubW', 22);
select * from cd.group;

INSERT INTO cd.event (event_nm, event_dttm, event_call_dttm, period, status) VALUES 
('Mysterious meeting','2023-07-07 00:00:00','2023-07-04 00:00:00','1 year',1);
INSERT INTO cd.group_user(group_id,user_id) VALUES
(11,21);
select * from cd.group_user;
