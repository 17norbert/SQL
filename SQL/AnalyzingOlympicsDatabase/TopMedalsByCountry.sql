
---
--- Top 10 countries
WITH sub1 AS

(SELECT noc,COUNT(medal) AS gold FROM olympics_history 
WHERE medal NOT LIKE 'NA' AND medal LIKE 'Gold'
 GROUP BY noc
),

sub2 AS
(SELECT noc,COUNT(medal) AS silver FROM olympics_history 
WHERE medal NOT LIKE 'NA' AND medal LIKE 'Silver'
 GROUP BY noc
),

sub3 AS
(SELECT noc,COUNT(medal) AS bronze FROM olympics_history 
WHERE medal NOT LIKE 'NA' AND medal LIKE 'Bronze'
GROUP BY noc
),
sub4 AS
(SELECT sub1.noc,sub1.gold,sub2.silver,sub3.bronze FROM sub1
JOIN sub2 ON sub1.noc = sub2.noc
JOIN sub3 ON sub2.noc = sub3.noc)

SELECT olympics_history_noc_regions.region AS country, sub4.gold,sub4.silver,sub4.bronze  FROM sub4
JOIN olympics_history_noc_regions ON olympics_history_noc_regions.noc = sub4.noc
ORDER BY gold DESC, silver DESC, bronze DESC;











