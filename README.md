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
