
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


----
----TOP 10 medalists in history of Olympics

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




