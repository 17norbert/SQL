
--- CREATE TABLE
DROP TABLE IF EXISTS olympics_history;
CREATE TABLE IF NOT EXISTS olympics_history
(
	id INT,
	name VARCHAR,
	sex VARCHAR,
	age VARCHAR,
	height VARCHAR,
	weight VARCHAR,
	team VARCHAR,
	noc VARCHAR,
	games VARCHAR,
	year INT,
	season VARCHAR,
	city VARCHAR,
	sport VARCHAR,
	event VARCHAR,
	medal VARCHAR
);
DROP TABLE IF EXISTS olympics_history_noc_regions;
CREATE TABLE IF NOT EXISTS olympics_history_noc_regions
(
	noc VARCHAR,
	region VARCHAR,
	notes VARCHAR
);

---IMPORT DATA
---
---TOP 10 Countries with most medals in history

WITH sub1 AS
(SELECT name,COUNT(medal) as gold  FROM olympics_history
WHERE medal NOT LIKE 'NA' AND medal LIKE 'Gold'
GROUP BY name,medal),

sub2 AS
(SELECT name,COUNT(medal) AS silver  FROM olympics_history
WHERE medal NOT LIKE 'NA' AND medal LIKE 'Silver'
GROUP BY name,medal),

sub3 AS
(SELECT name,COUNT(medal) bronze  FROM olympics_history
WHERE medal NOT LIKE 'NA' AND medal LIKE 'Bronze'
GROUP BY name,medal)

SELECT sub1.name,sub1.gold,sub2.silver,sub3.bronze FROM sub1
JOIN sub2 ON sub2.name = sub1.name
JOIN sub3 ON sub2.name = sub3.name
ORDER BY sub1.gold DESC,sub2.silver DESC,sub3.bronze DESC
LIMIT 10

https://github.com/17norbert/SQL-Olympics/blob/a3198d6160f2c8e84a4a088b5379b4c6027c48e5/SQL/AnalyzingOlympicsDatabase/data-1674922177204.csv

