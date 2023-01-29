
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
--- 1.TOP 10 Countries with most medals in history

WITH SUB1 AS
	(SELECT NOC,
			COUNT(MEDAL) AS GOLD
		FROM OLYMPICS_HISTORY
		WHERE MEDAL NOT LIKE 'NA'
			AND MEDAL LIKE 'Gold'
		GROUP BY NOC),
	SUB2 AS
	(SELECT NOC,
			COUNT(MEDAL) AS SILVER
		FROM OLYMPICS_HISTORY
		WHERE MEDAL NOT LIKE 'NA'
			AND MEDAL LIKE 'Silver'
		GROUP BY NOC),
	SUB3 AS
	(SELECT NOC,
			COUNT(MEDAL) AS BRONZE
		FROM OLYMPICS_HISTORY
		WHERE MEDAL NOT LIKE 'NA'
			AND MEDAL LIKE 'Bronze'
		GROUP BY NOC),
	SUB4 AS
	(SELECT SUB1.NOC,
			SUB1.GOLD,
			SUB2.SILVER,
			SUB3.BRONZE
		FROM SUB1
		JOIN SUB2 ON SUB1.NOC = SUB2.NOC
		JOIN SUB3 ON SUB2.NOC = SUB3.NOC)
SELECT OLYMPICS_HISTORY_NOC_REGIONS.REGION AS COUNTRY,
	SUB4.GOLD,
	SUB4.SILVER,
	SUB4.BRONZE
FROM SUB4
JOIN OLYMPICS_HISTORY_NOC_REGIONS ON OLYMPICS_HISTORY_NOC_REGIONS.NOC = SUB4.NOC
ORDER BY GOLD DESC,
	SILVER DESC,
	BRONZE DESC
LIMIT 10


---
--- 2.TOP 10 medalists in history of Olympics

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
LIMIT 10;

---
--- 3.Top 10 sports with most representants in history
SELECT sport,COUNT(DISTINCT(name)) AS total_number_of_players 
FROM olympics_history
GROUP BY sport
ORDER BY total_number_of_players DESC
LIMIT 10;
---
--- 4.Country with most medalists for each sport in history
WITH sub1 AS
(
SELECT sport,region,COUNT(*) AS total FROM olympics_history
JOIN olympics_history_noc_regions AS ohn ON ohn.noc = olympics_history.noc
WHERE medal NOT LIKE 'NA' 
GROUP BY sport,region
ORDER BY sport,total DESC
)
SELECT DISTINCT ON(sport) sport,region,total FROM sub1
---
--- 5.Which team won the most medals in each olympics

SELECT DISTINCT ON(games) games,olympics_history_noc_regions.region,
gold,silver,bronze, 
SUM(gold+silver+bronze) as total
FROM
(SELECT games,olympics_history.noc,
COUNT(CASE WHEN medal = 'Gold' THEN 1 END) AS gold,
COUNT(CASE WHEN medal = 'Silver' THEN 1 END) AS silver,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) AS bronze
FROM olympics_history
WHERE medal NOT LIKE 'NA'
GROUP BY games,olympics_history.noc
ORDER BY games,gold DESC) AS sub
JOIN olympics_history_noc_regions ON sub.noc = olympics_history_noc_regions.noc
GROUP BY games,region,gold,silver,bronze
ORDER BY games DESC,gold DESC ,silver DESC ,bronze DESC;

---
--- 6.Distribution of age in the history of olympics
SELECT age,total,CONCAT(ROUND(percentage,4),'%') FROM 
(SELECT age,subq.total,SUM(subq.total)*100.0/SUM(SUM(subq.total)) OVER() AS Percentage FROM 
(SELECT age,COUNT(age) AS total FROM olympics_history
GROUP BY age) AS subq
GROUP BY age,subq.total
ORDER BY Percentage DESC) AS subq2;
---
---
