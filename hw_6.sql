/* 1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно). */

CREATE TABLE users_old LIKE users;
DROP PROCEDURE IF EXISTS move_user;
DELIMITER //
CREATE PROCEDURE move_user(IN user_id INT)
BEGIN
    START TRANSACTION;
    INSERT INTO users_old
        SELECT * FROM users WHERE id = user_id;
    DELETE FROM users
        WHERE id = user_id;
    IF row_count() = 1 THEN
        COMMIT;
        SELECT 'OK';
    ELSE
        ROLLBACK;
        SELECT 'ERROR';
    END IF;
END //
DELIMITER ;

CALL move_user(10);
SELECT * FROM users_old;

/* 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello() 
	RETURNS VARCHAR(25)
BEGIN
DECLARE greeting VARCHAR(25);
SELECT CASE 
	WHEN CURRENT_TIME >= '12:00:00' AND  CURRENT_TIME < '18:00:00' THEN 'Добрый день'
	WHEN CURRENT_TIME >= '06:00:00' AND  CURRENT_TIME < '12:00:00' THEN 'Доброе утро'
	WHEN CURRENT_TIME >= '00:00:00' AND  CURRENT_TIME < '06:00:00' THEN 'Доброй ночи'
	ELSE 'Добрый вечер'
END INTO greeting;
RETURN greeting;
END//
DELIMITER ;
SELECT hello();

/*(по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, communities и 
messages в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа.*/
