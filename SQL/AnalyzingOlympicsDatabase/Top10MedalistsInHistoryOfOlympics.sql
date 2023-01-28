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


