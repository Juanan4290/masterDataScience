\c contacts;

SELECT fb.*, ln.contact, ln.company
FROM facebook as fb
LEFT OUTER JOIN linkedin AS ln ON fb.email=ln.email;
