-- Netflix Project
Create Table NetflixTitles
(
	Show_ID VARCHAR (6),
	Type VARCHAR (10),
	Title VARCHAR (150),
	Director VARCHAR (208),
	Casts VARCHAR (1000),
	Country VARCHAR (150),
	Date_Added VARCHAR (50),
	Release_Year INT,
	Rating VARCHAR (10),
	Duration VARCHAR (15),
	Listed_In VARCHAR (100),
	Description VARCHAR (250)
)

-- 15 Business Problems and Solutions
-- 1. Count the number of Movies VS TV Shows

SELECT DISTINCT Type
FROM PortfolioProject.dbo.NetflixTitles

SELECT Count(Type) As MovieToTV, type
FROM PortfolioProject.dbo.NetflixTitles
GROUP BY (Type)

-- 2. Find the most common rating for Movies and TV shows

SELECT Type, Rating
FROM
(
SELECT Type, Rating, Count(*) As TotalRatings, Rank() Over (Partition By Type ORDER BY Count(*) DESC) As Ranking
FROM PortfolioProject.dbo.NetflixTitles
GROUP BY Type, Rating
) AS Table1
WHERE Ranking = 1

-- 3. List all movies released in a specific year (e.g.,2021)

SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE Release_year = 2021 AND type = 'Movie'

-- 4. Find the top 5 countries with the most content on Netflix

WITH SplitCountries AS (
    SELECT TRIM(value) AS Country
    FROM PortfolioProject.dbo.NetflixTitles
    CROSS APPLY STRING_SPLIT(Country, ',')
)
SELECT TOP 5 Country, COUNT(*) AS Total_Content
FROM SplitCountries
GROUP BY Country
ORDER BY Total_Content DESC;

-- 5. Identify the longest movie

SELECT TOP 1
	Title,
	Type,
	CAST(REPLACE(duration,'min','') AS INT) AS DurationMins
	FROM PortfolioProject.dbo.NetflixTitles
	WHERE type = 'Movie' 
	ORDER BY DurationMins DESC

-- 6. Find content added in the last five years 

SELECT * FROM PortfolioProject.dbo.NetflixTitles

ALTER TABLE PortfolioProject.dbo.NetflixTitles
ADD Date_Added_Converted Date;

UPDATE PortfolioProject.dbo.NetflixTitles
SET Date_Added_Converted = CONVERT(Date,date_added)

SELECT Title, Type, Date_added_Converted
FROM PortfolioProject.dbo.NetflixTitles
WHERE date_added_Converted >= DATEADD(YEAR, -5, GETDATE());

-- 7. Find all the movies/TV Shows with the director 'Rajiv Chilaka'

SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE Director LIKE '%Rajiv Chilaka%'

-- 8. List all TV shows with more than 5 Seasons\

SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE
	CAST(LEFT(duration, CHARINDEX(' ',duration) -1) AS INT) > 5
	AND duration LIKE '%Seasons%'

-- 9. Count the number of Content items in each genre

WITH SplitGenres AS (
    SELECT TRIM(value) AS listed_in
    FROM PortfolioProject.dbo.NetflixTitles
    CROSS APPLY STRING_SPLIT(listed_in, ',')
)
SELECT listed_in, COUNT(*) AS Total_Content
FROM SplitGenres
GROUP BY listed_in
ORDER BY Total_Content DESC;

--10. Find the average release year for content produced in a specific country (United States)

SELECT AVG(release_year) AS Average_Release_Year
FROM PortfolioProject.dbo.NetflixTitles
WHERE Country LIKE '%United States%'


--11. List all movies that are documentaries 

SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE listed_in LIKE '%Documentaries%'

--12. Find all content without a director

SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE Director IS NULL

--13. How many movies/TV Shows has actor 'Ryan Reynolds' appeared in the last 10 years 

SELECT * 
FROM PortfolioProject.dbo.NetflixTitles
WHERE cast LIKE '%RYAN REYNOLDS%'

--14. Find the top 10 actors who have appeared in the highest number of movies produced in United States.

WITH SplitActors AS (
    SELECT TRIM(value) AS cast
    FROM PortfolioProject.dbo.NetflixTitles
    CROSS APPLY STRING_SPLIT(cast, ',')
	WHERE country LIKE '%United States%'
)
SELECT TOP 10 cast, COUNT(*) AS Total_Content
FROM SplitActors
GROUP BY cast
ORDER BY Total_Content DESC;

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label
-- content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

SELECT Show_ID, Type, Title, Rating, Description, Duration,
CASE
	WHEN Description LIKE '%Kill%' OR Description LIKE '%Violence%' Then 'Bad'
	ELSE 'Good'
END AS GoodVSBad
FROM PortfolioProject.dbo.NetflixTitles
