-- УРОК 7

-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

-- Вложенный запрос
SELECT 
 	user_id,
 	(SELECT name FROM users WHERE id = orders.user_id) as name
 FROM
 	orders;

-- JOIN 
SELECT
	o.user_id, u.name
FROM 
	orders AS o
JOIN 
	users AS u
ON
 o.user_id = u.id;


-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

-- Вложенный запрос
SELECT 
	id, name, price,
	(SELECT name FROM catalogs WHERE id = catalog_id) AS tmp
FROM 
	products;

-- JOIN
SELECT
	p.id, p.name, p.price, c.name 
FROM 
	products AS p
JOIN 
	catalogs AS c
ON
 c.id = p.catalog_id;


-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

CREATE DATABASE flight_db;
USE flight_db;

CREATE TABLE flights (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	flights_from VARCHAR (100) NOT NULL,
	flights_to VARCHAR (100) NOT NULL
);

CREATE TABLE cities (
	label VARCHAR (100) NOT NULL,
	name VARCHAR (100) NOT NULL
);


INSERT INTO flights (flights_from, flights_to) VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

	
INSERT INTO cities (label, name) VALUES
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

-- Вложенный запрос 
SELECT 
	flights.id,
	(SELECT name FROM cities WHERE label = flights.flights_from) AS 'Откуда',
	(SELECT name FROM cities WHERE label = flights.flights_to) AS 'Куда'
FROM 
	flights;	

-- JOIN
SELECT
	id, f_from.name AS 'Откуда', f_to.name AS 'Куда'
FROM 
	flights AS f
JOIN 
	cities AS f_from
JOIN 
	cities AS f_to
ON
	f.flights_from = f_from.label 
AND 
	f.flights_to = f_to.label
ORDER BY id;