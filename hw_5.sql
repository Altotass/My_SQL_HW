-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.
CREATE OR REPLACE VIEW users_under_20 AS
    SELECT 
	  users.firstname, 
	  users.lastname, 
	  profiles.gender, 
	  profiles.hometown 
	FROM 
	  profiles 
	JOIN users ON users.id = profiles.user_id 
	WHERE TIMESTAMPDIFF(YEAR, profiles.birthday, CURDATE()) < 20;
SELECT * FROM users_under_20;

/* 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите
ранжированный список пользователей, указав имя и фамилию пользователя, количество
отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным
количеством сообщений) . (используйте DENSE_RANK) */
SELECT 	
	CONCAT(firstname, ' ', lastname) AS users_name, 
    COUNT(*) AS total_messages, 
    DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS rating
FROM messages
JOIN users ON messages.from_user_id = users.id
GROUP BY from_user_id;

/* 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления
(created_at) и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG) */

SELECT 	
	body,
    created_at,
    TIMEDIFF(created_at, LAG(created_at) OVER()) AS next_message
FROM messages
ORDER BY created_at;There was an error committing your changes: File could not be edited
