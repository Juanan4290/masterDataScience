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
