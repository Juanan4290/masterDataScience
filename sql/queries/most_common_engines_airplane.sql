SELECT nb_engines, COUNT(*) 
FROM optd_aircraft 
WHERE nb_engines IS NOT NULL 
GROUP BY nb_engines 
ORDER BY COUNT(*) DESC 
LIMIT 1;
