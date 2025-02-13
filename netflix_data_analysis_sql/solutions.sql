-- 15 Business Problems for Data Analysis --

-- Q1:Determining the number of Movies vs TV Shows
SELECT type, count(*)
FROM netflix
GROUP BY type;

-- Q2: Determining the most common rating for movies and TV Shows
SELECT n.type, n.rating, r.rating_cnt
FROM netflix n
JOIN (
    SELECT type, rating, COUNT(*) AS rating_cnt
    FROM netflix
    GROUP BY type, rating
) r ON n.type = r.type AND n.rating = r.rating
WHERE r.rating_cnt = (
    SELECT MAX(rating_cnt)
    FROM (
        SELECT type, rating, COUNT(*) AS rating_cnt
        FROM netflix
        GROUP BY type, rating
    ) s
    WHERE s.type = n.type
)
GROUP BY n.type, n.rating, r.rating_cnt;


-- Q3: List all movies released in a specific year (eg 2020)
SELECT *
FROM netflix
WHERE release_year = 2020;

-- Q4: Finding the top 5 countries with the most content on Netflix
SELECT *
FROM (
	SELECT 
		TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) as country,
		COUNT(*) 
	FROM netflix
	GROUP BY COUNTRY
) AS sub
ORDER BY count DESC
LIMIT 5 ;

-- Q5: Identify the top 5 longest movie
SELECT title, minutes
FROM (
	SELECT title, SPLIT_PART(duration, ' ', 1)::INT minutes
	FROM netflix
	WHERE type = 'Movie' AND duration IS NOT NULL
) AS sub
ORDER BY minutes DESC
LIMIT 5;

-- Q6: Find content added in the last 5 years
SELECT *
FROM netflix
WHERE date_added > CURRENT_DATE - INTERVAL '5 years';

-- Q7: Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT title, type, director
FROM netflix 
WHERE director LIKE '%Rajiv Chilaka%';

-- Q8: List all TV shows with more than 5 seasons
SELECT *
FROM netflix 
WHERE type = 'TV Show' 
AND split_part(duration, ' ', 1):: INTEGER > 5;

-- Q9: Count the number of content items in each genre
SELECT 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(*) as total_count
FROM netflix
GROUP BY genre;

-- Q10: Find the total amount of content released in India for each year
SELECT 
	release_year as year,
	count(*) as total_count
FROM netflix
WHERE country LIKE '%India%'
GROUP BY year;

-- Q11: List all movies that are documentaries
SELECT *
FROM netflix 
WHERE listed_in LIKE '%Documentaries%';

-- Q12: Find all content without a director
SELECT *
FROM netflix 
WHERE director is NULL OR director = '';

-- Q13: Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT *
FROM netflix 
WHERE casts LIKE '%Salman Khan%'
AND date_added > CURRENT_DATE - INTERVAL '10 years';

-- Q14: Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
	TRIM(UNNEST(string_to_array(casts, ','))) as actors,
	COUNT(*) as movies_count
FROM netflix
WHERE country LIKE '%India%' AND casts IS NOT NULL
GROUP BY actors
ORDER BY movies_count DESC
LIMIT 10;

-- Q15: Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
SELECT 
	category, 
	type,
	COUNT(*)
FROM 
	(SELECT
		*,
		CASE
		WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
		ELSE 'Good'
		END AS category
		FROM netflix) AS categorised
GROUP BY category, type 
ORDER BY type;
	
	


