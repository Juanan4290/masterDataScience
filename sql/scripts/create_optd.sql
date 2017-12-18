DROP DATABASE optd;
CREATE DATABASE optd;

\c optd

CREATE TABLE optd_airlines (
	pk VARCHAR(36) NOT NULL, 
	env_id INTEGER, 
	validity_from DATE, 
	validity_to VARCHAR(10), 
	"3char_code" VARCHAR(4), 
	"2char_code" VARCHAR(4), 
	num_code INTEGER, 
	name VARCHAR(37), 
	name2 VARCHAR(53), 
	alliance_code VARCHAR(13), 
	alliance_status VARCHAR(9), 
	type VARCHAR(4), 
	wiki_link VARCHAR(82), 
	flt_freq INTEGER
);

CREATE TABLE optd_aircraft (
	iata_code VARCHAR(3) NOT NULL, 
	manufacturer VARCHAR(30), 
	model VARCHAR(45) NOT NULL, 
	iata_group VARCHAR(4), 
	iata_category VARCHAR(10), 
	icao_code VARCHAR(4), 
	nb_engines INTEGER, 
	aircraft_type VARCHAR(4)
);

\copy optd_aircraft from '~/Documents/masterDataScience/sql/data/optd_aircraft.csv' delimiter '^' header csv;

\copy optd_airlines from '~/Documents/masterDataScience/sql/data/optd_airlines.csv' delimiter '^' header csv;
