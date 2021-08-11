-- ***Практическое задание по теме “Транзакции, переменные, представления”


-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;

INSERT INTO sample.users(id, name) SELECT id, name FROM shop.users WHERE users.id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT;


-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы
-- products и соответствующее название каталога name из таблицы catalogs.

CREATE VIEW cat AS
SELECT products.id AS id, products.name AS name, catalogs.name AS category 
	FROM products
	JOIN catalogs
	  ON products.catalog_id = catalogs.id;
	 
SELECT * FROM cat;	 

-- 3. (по желанию) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
-- если дата присутствует в исходном таблице и 0, если она отсутствует.



-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at.
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.





-- ***Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)




/*Практическое задание по теме “Хранимые процедуры и функции, триггеры"*/

-- 1 Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от
-- текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с
-- 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый
-- вечер", с 00:00 до 6:00 — "Доброй ночи".

-- Решение через процедуру
CREATE PROCEDURE hello_two()
BEGIN
	IF (CURTIME() BETWEEN '06:00:00' AND '11:59:59') THEN 
		SELECT 'Доброе утро' AS 'Время суток', CURTIME() AS 'Текущее время';
	ELSEIF (CURTIME() BETWEEN '12:00:00' AND '17:59:59') THEN
		SELECT 'Добрый день' AS 'Время суток', CURTIME() AS 'Текущее время';
	ELSEIF (CURTIME() BETWEEN '18:00:00' AND '23:59:59') THEN
		SELECT 'Добрый вечер' AS 'Время суток', CURTIME() AS 'Текущее время';
	ELSEIF (CURTIME() BETWEEN '00:00:00' AND '05:59:59') THEN
		SELECT 'Доброй ночи' AS 'Время суток', CURTIME() AS 'Текущее время';
	END IF;
END
//

-- Проверка работы процедуры
CALL hello_two()


-- Решение через функцию
CREATE FUNCTION hello_four()
RETURNS CHAR(50) DETERMINISTIC
BEGIN
	IF (CURTIME() BETWEEN '06:00:00' AND '11:59:59') THEN 
		RETURN 'Доброе утро';
	ELSEIF (CURTIME() BETWEEN '12:00:00' AND '17:59:59') THEN
		RETURN 'Добрый день';
	ELSEIF (CURTIME() BETWEEN '18:00:00' AND '23:59:59') THEN
		RETURN 'Добрый вечер';
	ELSEIF (CURTIME() BETWEEN '00:00:00' AND '05:59:59') THEN
		RETURN 'Доброй ночи';
	END IF;
END
//

-- Проверка работы функции
SELECT hello_four() AS 'Время суток', CURTIME() AS 'Текущее время';


-- 2 В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное 
-- значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.


CREATE TRIGGER restrict_product BEFORE INSERT ON products
FOR EACH ROW
BEGIN 
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка в заполнении данных';
	ELSEIF NEW.name = '' AND NEW.description = '' THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка в заполнении данных';
	END IF;
END
//

-- 3 (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 55.


CREATE FUNCTION fibo (num INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE result_fibo INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
	DECLARE x INT DEFAULT 0;
	DECLARE y INT DEFAULT 1;
	WHILE i < num - 1 DO
	SET result_fibo = y + x;
	SET x = y;
	SET y = result_fibo;
	SET i = i + 1;
	END WHILE;
	RETURN result_fibo;
END
//


