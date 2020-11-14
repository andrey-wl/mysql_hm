-- Внешние ключи

DESC profiles;
DESC profile_statuses;
DESC cities;

ALTER TABLE profiles MODIFY COLUMN status_id INT UNSIGNED;

ALTER TABLE profiles
	ADD CONSTRAINT profilesuser_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT profiles_photo_id_fk
		FOREIGN KEY (photo_id) REFERENCES media(id)
			ON DELETE SET NULL,
	ADD CONSTRAINT profiles_status_id_fk
		FOREIGN KEY (status_id) REFERENCES profile_statuses(id)
			ON DELETE SET NULL,
	ADD CONSTRAINT profiles_city_id_fk
		FOREIGN KEY (city_id) REFERENCES cities(id)
			ON DELETE SET NULL;
		ALTER TABLE profiles

-- Внешние ключи таблица media

ALTER TABLE media 
	ADD CONSTRAINT media_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE;

ALTER TABLE media MODIFY COLUMN media_type_id INT UNSIGNED;		
		
ALTER TABLE media 
	ADD CONSTRAINT media_type_id_fk
		FOREIGN KEY (media_type_id) REFERENCES media_types(id)
			ON DELETE SET NULL;

-- Внешние ключи таблица cities 		
		
DESC cities;	

ALTER TABLE cities 
	ADD CONSTRAINT country_id_fk
		FOREIGN KEY (country_id) REFERENCES countries(id)
			ON DELETE SET NULL;

ALTER TABLE cities ADD CONSTRAINT name UNIQUE KEY (name);


-- Внешние ключи таблица friendships 		
DESC friendships;

ALTER TABLE friendships
	ADD CONSTRAINT friendships_statuses_id_fk
		FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
			ON DELETE SET NULL;

ALTER TABLE friendships MODIFY COLUMN status_id INT UNSIGNED;	

ALTER TABLE friendships
	ADD CONSTRAINT friendships_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE;
ALTER TABLE friendships
	ADD CONSTRAINT friendships_friend_id_fk
		FOREIGN KEY (friend_id) REFERENCES users(id)
			ON DELETE CASCADE;
		
-- Внешние ключи таблица communities_users
DESC communities_users;

ALTER TABLE communities_users
	ADD CONSTRAINT communities_users_id_fk
		FOREIGN KEY (community_id) REFERENCES communities(id)
			ON DELETE CASCADE;
ALTER TABLE communities_users
	ADD CONSTRAINT communities_users_users_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE;
		
-- Внешние ключи таблица posts
DESC posts;

ALTER TABLE posts	
	ADD CONSTRAINT posts_media_id_fk
		FOREIGN KEY (media_id) REFERENCES media(id)
			ON DELETE SET NULL;
ALTER TABLE posts
	ADD CONSTRAINT posts_community_id_fk
		FOREIGN KEY (community_id) REFERENCES communities(id)
			ON DELETE SET NULL;
ALTER TABLE posts
	ADD CONSTRAINT posts_users_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE;		
		
-- Внешние ключи таблица likes
DESC likes;

ALTER TABLE likes MODIFY COLUMN target_type_id INT UNSIGNED;

ALTER TABLE likes	
	ADD CONSTRAINT likes_target_type_id_fk
		FOREIGN KEY (target_type_id) REFERENCES target_types(id)
			ON DELETE SET NULL;
ALTER TABLE likes
	ADD CONSTRAINT likes_users_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE;
				
-- Внешние ключи таблица messages
DESC messages;

ALTER TABLE messages
	ADD CONSTRAINT messages_from_users_id_fk
		FOREIGN KEY (from_user_id) REFERENCES users(id)
			ON DELETE CASCADE,
	ADD CONSTRAINT messages_to_users_id_fk
		FOREIGN KEY (to_user_id) REFERENCES users(id)
			ON DELETE CASCADE;
			
		
		
-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT 
	MAX(gender) AS 'Кто больше лайкнул М или F?' 
	FROM 
	(SELECT gender
	FROM 
	(SELECT	user_id, gender FROM profiles WHERE user_id IN 
 	(SELECT user_id FROM likes)) AS tmp2) AS tmp;


-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям 
-- (сколько лайков получили 10 самых молодых пользователей).

SELECT
  COUNT(user_id) AS 'Количество лайков'
FROM 
  likes
WHERE
  user_id IN (SELECT user_id AS young_user
  FROM (SELECT user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
  FROM profiles ORDER BY age LIMIT 4, 10) AS new_users);
  
 
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- (критерии активности необходимо опредеолить самостоятельно) 

SELECT 
	first_name AS name, last_name AS surname,
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) AS activity 
	  FROM users
	  ORDER BY activity 
	  LIMIT 10; 
 