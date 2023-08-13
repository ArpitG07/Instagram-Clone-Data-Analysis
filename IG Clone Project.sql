
-- 1. Create an ER diagram or create a schema for the given database.

-- File Attached Separately


-- 2. We want to reward the user who has been around the longest, Find the 5 oldest users.

SELECT *
FROM users
ORDER BY created_at
LIMIT 5;


-- 3. To understand when to run the ad campaign, figure out the day of the week most users register on.

SELECT dayname(created_at) AS Day, count(*) AS Total_Registrations
FROM users u
GROUP BY Day
ORDER BY Total_Registrations DESC
LIMIT 2;

-- ANSWER: Thursday and Sunday


-- 4. To target inactive users in an email ad campaign, find the users who have never posted a photo.

SELECT u.id, u.username
FROM users u
LEFT JOIN photos p
ON u.id = p.user_id
WHERE p.image_url IS NULL
ORDER BY u.id;


-- 5. Suppose you are running a contest to find out who got the most likes on a photo. Find out who won.

SELECT p.id, p.image_url, count(*) AS Likes_Quantity, u.username AS Winner
FROM photos p
INNER JOIN likes l
ON p.id = l.photo_id
INNER JOIN users u
ON p.user_id = u.id
GROUP BY p.id
ORDER BY Likes_Quantity DESC
LIMIT 1;


-- 6. The investors want to know how many times does the average user post.

SELECT 
(SELECT COUNT(*) FROM photos)/(SELECT COUNT(*) FROM users) AS Average;


-- 7. A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.

SELECT t.tag_name, count(*)
FROM photo_tags pt
INNER JOIN tags t
ON pt.tag_id = t.id
GROUP BY t.id
ORDER BY count(*) DESC
LIMIT 5;


-- 8. To find out if there are bots, find users who have liked every single photo on the site.

SELECT u.username, count(*) AS Likes_Quantity
FROM users u
INNER JOIN likes l
ON u.id = l.user_id
GROUP BY l.user_id
HAVING Likes_Quantity = (SELECT count(*) FROM photos);

-- 9. To know who the celebrities are, find users who have never commented on a photo.

SELECT u.username, c.comment_text
FROM users u
LEFT JOIN comments c
ON u.id = c.user_id
WHERE c.comment_text IS NULL;


-- 10. Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.

SELECT u.username, c.comment_text
FROM users u
LEFT JOIN comments c
ON u.id = c.user_id
WHERE c.comment_text IS NULL
UNION
SELECT u.username, count(*) AS Comments_Quantity
FROM users u
INNER JOIN comments c
ON u.id = c.user_id
GROUP BY c.user_id
HAVING Comments_Quantity = (SELECT count(*) FROM photos);


-- 11. Get number of images posted, comments commented and followers of each user along with user ID.

SELECT u.id, u.username, count(p.image_url), count(c.comment_text), count(f.follower_id)
FROM users u
INNER JOIN photos p
ON u.id = p.user_id
INNER JOIN comments c
ON u.id = c.user_id
INNER JOIN follows f
ON u.id = f.follower_id
GROUP BY u.id;


-- 12. For all users, get total likes, comments and order them total value of likes and comments

SELECT count(l.photo_id), count(c.photo_id) + count(c.id) AS Total_Count
FROM users u
INNER JOIN likes l
ON u.id = l.user_id
INNER JOIN comments c
ON u.id = c.user_id
ORDER BY Total_Count;
