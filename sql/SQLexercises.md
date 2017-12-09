# SLQ Exercises

1.  Import optd_aircraft.csv and optd_airlines.csv in postgres ( /Data/opentraveldata/):
```

_Execute in @psql:_
>> CREATE DATABASE optd;

_Execute in @shell:_
>> csvsql -i postgresql -d '^' ~/Data/opentraveldata/optd_aircraft.csv > ~/Data/opentraveldata/optd_aircraft_create_table.txt
>> csvsql -i postgresql -d '^' ~/Data/opentraveldata/optd_airlines.csv > ~/Data/opentraveldata/optd_airlines_create_table.txt
>> psql -d optd -f ~/Data/opentraveldata/optd_aircraft_create_table.txt
>> psql -d optd -f ~/Data/opentraveldata/optd_airlines_create_table.txt

_Execute in @psql:_
>> \c optd
>>  \copy optd_aircraft from '~/Data/opentraveldata/optd_aircraft.csv' delimiter '^' csv header;
>> \copy optd_airlines from '~/Data/opentraveldata/optd_airlines.csv' delimiter '^' csv header;

```

2.  Which airplane has the highest number of engines?
(optd_aircraft):
```
>> 
```
3.  What number of engines is most common on airplanes?
(optd_aircraft):
```
>> 
```
