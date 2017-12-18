\c contacts;

SELECT fb.email
FROM facebook AS fb
INNER JOIN linkedin AS ln ON fb.email=ln.email;

SELECT fb.email AS email, fb.name AS fb, ln.contact AS ln, tw.account AS tw
FROM facebook AS fb
INNER JOIN linkedin AS ln ON fb.email=ln.email
INNER JOIN twitter AS tw ON tw.email=fb.email;

