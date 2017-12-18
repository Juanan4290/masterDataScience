\c contacts;

SELECT *, ( SELECT AVG(age)
FROM facebook
WHERE residence='Madrid' ) AS Mad_average
FROM facebook
WHERE age <(SELECT AVG(age)
FROM facebook
WHERE residence='Madrid') ;

SELECT *
FROM facebook
WHERE residence IN (SELECT residence
FROM facebook
GROUP BY residence
HAVING AVG(age)>35);
