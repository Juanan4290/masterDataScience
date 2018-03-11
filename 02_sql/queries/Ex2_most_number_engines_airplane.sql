\c optd;

SELECT * 
FROM optd_aircraft 
WHERE nb_engines IS NOT NULL 
ORDER BY nb_engines DESC 
LIMIT 1;
