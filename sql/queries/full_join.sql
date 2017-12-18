\c contacts;

SELECT ln.*, fb.*
FROM facebook as fb
FULL JOIN linkedin AS ln ON fb.email=ln.email;
