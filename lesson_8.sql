-- УРОК 8  (переделка в JOIN)

-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
   
SELECT gender, COUNT(gender) AS total 
	FROM profiles
	JOIN likes
	  ON profiles.user_id = likes.user_id
	GROUP BY gender
	ORDER BY total DESC
	LIMIT 1;
       
     
-- 4. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT SUM(total_count) AS 'Кол-во лайков'
	FROM (
	SELECT	 
	COUNT(likes.target_type_id) AS total_count
	FROM likes
	RIGHT JOIN profiles
	ON target_type_id  = 2 AND likes.target_id = profiles.user_id
	GROUP BY profiles.user_id 
	ORDER BY birthday DESC
	LIMIT 10) AS total_count;
	

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.     

SELECT 
	CONCAT(first_name, ' ', last_name) AS users,
	COUNT(DISTINCT likes.id) +  
	COUNT(DISTINCT messages.id) +
	COUNT(DISTINCT media.id) AS overall_activity
 	FROM users
    	LEFT JOIN likes
	  ON likes.user_id = users.id 
	LEFT JOIN messages
	  ON messages.from_user_id = users.id
	LEFT JOIN media
	  ON media.user_id = users.id
	GROUP BY users.id
	ORDER BY overall_activity
	LIMIT 10;
	  
     
	 
	 
	 
	 
	 
	 
	 
 
