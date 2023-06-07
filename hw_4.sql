-- 1. Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
SELECT COUNT(id) FROM likes 
	-- WHERE user_id = (SELECT user_id FROM profiles WHERE YEAR(birthday) > 2011 AND user_id = likes.user_id);
	WHERE user_id IN (
	SELECT user_id 
	FROM profiles
	WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 12);

-- 2. Определить кто больше поставил лайков (всего): мужчины или женщины.
SELECT CASE (gender)
	WHEN 'm' THEN 'Мужчины'
	WHEN 'f' THEN 'Женщины'
    END AS 'Больше лайков ставят:', COUNT(*) AS 'Кол-во лайков'
FROM profiles p 
JOIN likes l 
WHERE l.user_id = p.user_id
GROUP BY gender 
LIMIT 1;

-- 3. Вывести всех пользователей, которые не отправляли сообщения.
SELECT DISTINCT CONCAT(firstname, ' ', lastname) AS 'Не отправляют сообщения' FROM users
WHERE NOT EXISTS 
	(SELECT from_user_id FROM messages
	WHERE users.id = messages.from_user_id);
