DROP DATABASE IF EXISTS contacts;
CREATE DATABASE contacts;

\c contacts

DROP TABLE IF EXISTS facebook;
CREATE TABLE facebook (
	name VARCHAR(10) NOT NULL, 
	age INTEGER NOT NULL, 
	residence VARCHAR(10) NOT NULL, 
	email VARCHAR(24) NOT NULL
);

DROP TABLE IF EXISTS linkedin;
CREATE TABLE linkedin (
	contact VARCHAR(17) NOT NULL, 
	company VARCHAR(12) NOT NULL, 
	email VARCHAR(23) NOT NULL
);

\copy facebook from '~/Documents/masterDataScience/data/my_fb_friends.csv' delimiter '^' header csv;

\copy linkedin from '~/Documents/masterDataScience/data/my_ldin_contacts.csv' delimiter '^' header csv;
