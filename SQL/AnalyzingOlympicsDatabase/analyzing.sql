---top 10 sports with most representants in history
SELECT sport,COUNT(DISTINCT(name)) AS total_number_of_players 
FROM olympics_history
GROUP BY sport
ORDER BY total_number_of_players DESC
LIMIT 10;
--------------------------------------

-----country with most medalists for each sport in history
WITH sub1 AS
(
SELECT sport,region,COUNT(*) AS total FROM olympics_history
JOIN olympics_history_noc_regions AS ohn ON ohn.noc = olympics_history.noc
WHERE medal NOT LIKE 'NA' 
GROUP BY sport,region
ORDER BY sport,total DESC
)
SELECT DISTINCT ON(sport) sport,region,total FROM sub1;

--------------------------------------------------
-------distribution of age in the history of olympics
SELECT age,total_age,ROUND(percentage,4) FROM 
(SELECT age,subq.total_age,SUM(subq.total_age)*100.0/SUM(SUM(subq.total_age)) OVER() AS Percentage FROM 
(SELECT age,COUNT(age) AS total_age FROM olympics_history
GROUP BY age) AS subq
GROUP BY age,subq.total_age
ORDER BY Percentage DESC) AS subq2;
---------------------------------------------------
--------Which team won the most medals in each olympics

SELECT DISTINCT ON(games) games,noc,gold,silver,bronze, SUM(gold+silver+bronze) FROM
(SELECT games,noc,
COUNT(CASE WHEN medal = 'Gold' THEN 1 END) AS gold,
COUNT(CASE WHEN medal = 'Silver' THEN 1 END) AS silver,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) AS bronze
FROM olympics_history
WHERE medal NOT LIKE 'NA'
GROUP BY games,noc
ORDER BY games,gold DESC) AS sub
GROUP BY games,noc,gold,silver,bronze
ORDER BY games DESC,gold DESC ,silver DESC ,bronze DESC;
LIMIT 10

---------------------



