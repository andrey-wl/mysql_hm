-- Урок 10. Вебинар. Транзакции, переменные, представления. Администрирование. 
-- Хранимые процедуры и функции, триггеры

-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы 
-- приложения и добавить необходимые индексы.

-- Создадим индекс для таблицы profiles(birthday) 
CREATE INDEX profiles_birthday_idx ON profiles(birthday);

-- Создадим индекс для таблицы communities(name)
CREATE INDEX communities_name_idx ON communities(name);

-- Создадим индекс для таблицы media(filename)
CREATE INDEX media_filename_idx ON media(filename);


-- 2. Задание на оконные функции
-- 
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100


SELECT DISTINCT 
	communities.name,
	ROUND(COUNT(communities_users.user_id) OVER() / 
	(SELECT COUNT(*) FROM communities), 0) AS 'average',
	MAX(profiles.birthday) OVER w AS 'yang',
	MIN(profiles.birthday) OVER w AS 'old',
	COUNT(communities_users.user_id) OVER w AS 'in group',
	(SELECT COUNT(user_id) FROM profiles) AS 'in system',
	COUNT(communities_users.user_id) OVER w /
	(SELECT COUNT(user_id) FROM profiles) * 100 AS 'attitude %'
FROM 
	communities  
JOIN 
	communities_users 
ON
	community_id = communities.id 
JOIN
	profiles
ON
	profiles.user_id = communities_users.user_id
WINDOW w AS (PARTITION BY community_id);
