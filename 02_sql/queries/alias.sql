\c contacts;

SELECT *,(age*2) AS doub_age 
FROM facebook 
WHERE (age*2)>70;

SELECT * 
FROM facebook AS f 
WHERE f.residence = 'Madrid';
