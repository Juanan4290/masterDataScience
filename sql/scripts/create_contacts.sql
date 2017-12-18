DROP DATABASE contacts;
CREATE DATABASE contacts;

\c contacts

CREATE TABLE facebook (
	name VARCHAR(10) NOT NULL, 
	age INTEGER NOT NULL, 
	residence VARCHAR(10) NOT NULL, 
	email VARCHAR(24) NOT NULL
);

CREATE TABLE linkedin (
	contact VARCHAR(17) NOT NULL, 
	company VARCHAR(12) NOT NULL, 
	email VARCHAR(23) NOT NULL
);

\copy facebook from '~/Documents/masterDataScience/sql/data/my_fb_friends.csv' delimiter '^' header csv;

\copy linkedin from '~/Documents/masterDataScience/sql/data/my_ldin_contacts.csv' delimiter '^' header csv;
