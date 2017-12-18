\c contacts;

SELECT residence, COUNT(*), AVG(age)
FROM facebook
GROUP BY residence
HAVING AVG(age)>35;
