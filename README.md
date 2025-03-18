# Netflix Movies and TV shows Data Analysis using SQL

![Netflix Logo](https://github.com/NoahPiercy/Netflix_SQL_Project/blob/main/logo.png)
## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.
## Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.
## Dataset
The data for this project is sourced from the Kaggle dataset:
- Dataset Link: [Netflix Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
## Schema
``` SQL
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
```
## Business Problems and Solutions
### 1. Count the Number of Movies vs TV Shows
``` SQL
SELECT DISTINCT Type
FROM PortfolioProject.dbo.NetflixTitles

SELECT Count(Type) As MovieToTV, type
FROM PortfolioProject.dbo.NetflixTitles
GROUP BY (Type)
```
Objective: Determine the distribution of content types on Netflix.
### 2. Find the Most Common Rating for Movies and TV Shows
``` SQL
SELECT Type, Rating
FROM
(
SELECT Type, Rating, Count(*) As TotalRatings, Rank() Over (Partition By Type ORDER BY Count(*) DESC) As Ranking
FROM PortfolioProject.dbo.NetflixTitles
GROUP BY Type, Rating
) AS Table1
WHERE Ranking = 1
```
Objective: Identify the most frequently occurring rating for each type of content.
### 3. List All Movies Released in a Specific Year (e.g., 2021)
``` SQL
SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE Release_year = 2021 AND type = 'Movie'
```
Objective: Retrieve all movies released in a specific year.
### 4. Find the Top 5 Countries with the Most Content on Netflix
``` SQL
WITH SplitCountries AS (
    SELECT TRIM(value) AS Country
    FROM PortfolioProject.dbo.NetflixTitles
    CROSS APPLY STRING_SPLIT(Country, ',')
)
SELECT TOP 5 Country, COUNT(*) AS Total_Content
FROM SplitCountries
GROUP BY Country
ORDER BY Total_Content DESC;
```
Objective: Identify the top 5 countries with the most content items.
### 5. Identify the Longest Movie
``` SQL
SELECT TOP 1
	Title,
	Type,
	CAST(REPLACE(duration,'min','') AS INT) AS DurationMins
	FROM PortfolioProject.dbo.NetflixTitles
	WHERE type = 'Movie' 
	ORDER BY DurationMins DESC
```
Objective: Find the movie with the longest duration.
### 6. Find Content Added in the Last 5 Years
``` SQL
SELECT * FROM PortfolioProject.dbo.NetflixTitles

ALTER TABLE PortfolioProject.dbo.NetflixTitles
ADD Date_Added_Converted Date;

UPDATE PortfolioProject.dbo.NetflixTitles
SET Date_Added_Converted = CONVERT(Date,date_added)

SELECT Title, Type, Date_added_Converted
FROM PortfolioProject.dbo.NetflixTitles
WHERE date_added_Converted >= DATEADD(YEAR, -5, GETDATE());
```
Objective: Retrieve content added to Netflix in the last 5 years.
### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
``` SQL
SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE Director LIKE '%Rajiv Chilaka%'
```
Objective: List all content directed by 'Rajiv Chilaka'.
### 8. List All TV Shows with More than 5 Seasons
``` SQL
SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE
	CAST(LEFT(duration, CHARINDEX(' ',duration) -1) AS INT) > 5
	AND duration LIKE '%Seasons%'
```
Objective: Identify TV shows with more than 5 seasons.
### 9. Count the Number of COntent Items in Each Genre
``` SQL
WITH SplitGenres AS (
    SELECT TRIM(value) AS listed_in
    FROM PortfolioProject.dbo.NetflixTitles
    CROSS APPLY STRING_SPLIT(listed_in, ',')
)
SELECT listed_in, COUNT(*) AS Total_Content
FROM SplitGenres
GROUP BY listed_in
ORDER BY Total_Content DESC;
```
Objective: Count the number of content items in each genre.
### 10. Find the Average Release Year for Content Produced in a Specific Country (United States)
``` SQL
SELECT AVG(release_year) AS Average_Release_Year
FROM PortfolioProject.dbo.NetflixTitles
WHERE Country LIKE '%United States%'
```
Objective: Find the Average Release Year for Content in the United States
### 11. List All Movies that are Documentaries
``` SQL
SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE listed_in LIKE '%Documentaries%'
```
Objective: Retrieve all movies classified as documentaries.
### 12. Find All Content Without a Director
``` SQL
SELECT *
FROM PortfolioProject.dbo.NetflixTitles
WHERE Director IS NULL
```
Objective: List all content that does not have a director.
### 13. Find all Movies/TV Shows that 'Ryan Reynolds' has Appeared in
``` SQL
SELECT * 
FROM PortfolioProject.dbo.NetflixTitles
WHERE cast LIKE '%RYAN REYNOLDS%'
```
Objective: Find all content that 'Ryan Reynolds' has appeared in on Netflix.
### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in the United States
``` SQL
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
```
Objective: Identify the top 10 actors with the most appearances in United States-produced movies.
### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
``` SQL
SELECT Show_ID, Type, Title, Rating, Description, Duration,
CASE
	WHEN Description LIKE '%Kill%' OR Description LIKE '%Violence%' Then 'Bad'
	ELSE 'Good'
END AS GoodVSBad
FROM PortfolioProject.dbo.NetflixTitles
```
Objective: Categorize content as 'Bad' if it contains 'Kill' or 'Violence' in the description, and categorize content as 'Good' if it does not.

## Author - Noah Piercy
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles, If you have any questions, or feedback, or would like to discuss more, feel free to get in touch!











