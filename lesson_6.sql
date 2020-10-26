
-- ОПЕРАТОРЫ, ФИЛЬТРАЦИЯ, СОРТИРОВКА И ОГРАНИЧЕНИЕ.


-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

CREATE DATABASE lesson_5;
USE lesson_5;

-- Таблица users
CREATE TABLE users (
  id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) COMMENT 'Имя пользователя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создание строки",
  update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT 'Ползователи';

INSERT INTO users (name, birthday_at, created_at, update_at) VALUES
('Kate', '1992-08-08', NULL, NULL),
('Danzil', '1995-03-11', NULL, NULL),
('Brill', '1986-02-01', NULL, NULL),
('Alice', '1989-03-01', NULL, NULL),
('Nora', '1986-02-02', NULL, NULL),
('Berti', '1998-05-03', NULL, NULL);

UPDATE users SET created_at = NOW(), update_at = NOW();

-- 2. Таблица users была неудачно спроектирована. 
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

CREATE DATABASE lesson_5;
USE lesson_5;

CREATE TABLE users (
  id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) COMMENT 'Имя пользователя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(150) COMMENT "Время создание строки",
  update_at VARCHAR(150) COMMENT "Время обновления строки"
) COMMENT 'Ползователи';


INSERT INTO users (name, birthday_at, created_at, update_at) VALUES
('Kate', '1992-08-08', '10.09.2012 12:06', '10.09.2012 12:06'),
('Danzil', '1995-03-11','10.09.2012 12:06', '10.09.2012 12:06'),
('Brill', '1986-02-01', '10.09.2012 12:06', '10.09.2012 12:06'),
('Alice', '1989-03-01', '10.09.2012 12:06', '10.09.2012 12:06'),
('Nora', '1986-02-02', '10.09.2012 12:06', '10.09.2012 12:06'),
('Berti', '1998-05-03','10.09.2012 12:06', '10.09.2012 12:06');

UPDATE users SET 
  created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
  update_at = STR_TO_DATE(update_at, '%d.%m.%Y %k:%i');
 
ALTER TABLE users MODIFY COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создание строки";
ALTER TABLE users MODIFY COLUMN update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки";

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
-- 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
-- Однако нулевые запасы должны выводиться в конце, после всех записей

CREATE TABLE storehouses_products (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	storehouses_id INT UNSIGNED COMMENT 'Ссылка на склады',
	product_id INT UNSIGNED COMMENT 'Ссылка на товарные позиции',
	value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products (storehouses_id, product_id, value) VALUES
  (1, 32, 3),
  (1, 14, 0),
  (1, 2, 0),
  (1, 43, 16),
  (1, 2, 4);

SELECT * FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;

-- АГРЕГАЦИЯ ДАННЫХ

-- 1. Подсчитайте средний возраст пользователей в таблице users.

USE lesson_5;

-- Вывод возраста пользователей 1 способ
SELECT name, FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25) AS age FROM users;

-- Вывод возраста пользователей 2 способ
SELECT name, TIMESTAMPDIFF(YEAR, birthday_at, NOW()) as age FROM users;

-- Вывод среднего возраста пользователей
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) as age FROM users;



-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения. 

-- база и таблица из первого задания

SELECT DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W')
  AS days, COUNT(*) AS item FROM users GROUP BY Days ORDER BY item DESC;
