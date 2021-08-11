-- Урок 11. Практическое задание по теме “Оптимизация запросов”


-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах
-- users, catalogs и products в таблицу logs помещается время и дата создания записи,
--  название таблицы, идентификатор первичного ключа и содержимое поля name.

USE shop;

-- Создадим временную таблицу
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
log_id INT NOT NULL,
name_table VARCHAR(50),
descripe VARCHAR(50),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=ARCHIVE;

-- Триггер logs_users для таблицы users
CREATE TRIGGER logs_users AFTER INSERT ON users
FOR EACH ROW
BEGIN 
	INSERT INTO logs
	SET name_table = 'users',
	log_id = NEW.id,
	descripe = NEW.name;
END
//
-- Триггер logs_products для таблицы products
CREATE TRIGGER logs_products AFTER INSERT ON products
FOR EACH ROW
BEGIN 
	INSERT INTO logs
	SET name_table = 'products',
	log_id = NEW.id,
	descripe = NEW.name;
END
//

-- Триггер logs_catalogs для таблицы catalogs
CREATE TRIGGER logs_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN 
	INSERT INTO logs
	SET name_table = 'catalogs',
	log_id = NEW.id,
	descripe = NEW.name;
END
//


-- 2.(по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.


-- Урок 11. Практическое задание по теме “NoSQL”


-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

HSET ipadd 127.0.0.1 1

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот,
--  поиск электронного адреса пользователя по его имени.

SET andrey test@mail.ru
SET test@mail.ru andrey
GET andrey
GET test@mail.ru

-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.


db.shop.insert({category: 'Процессоры'})
db.shop.insert({category: 'Материнские платы'})
db.shop.insert({category: 'Видеокарты'})

db.shop.update({category: 'Процессоры'}, {$set: { products:['Intel Core i3-8100', 'Intel Core i5-7400', 'AMD FX-8320E'] }})
db.shop.update({category: 'Материнские платы'}, {$set: { products:['ASUS ROG MAXIMUS X HERO', 'Gigabyte H310M S2H', 'MSI B250M GAMING PRO'] }})
db.shop.update({category: 'Видеокарты'}, {$set: { products:['GEFORCE RTX 3070', 'GEFORCE RTX 3090', 'GEFORCE RTX 3060'] }})

