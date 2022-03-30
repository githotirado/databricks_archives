-- This will run on PostgreSQL since Postgres has generate_series function and
-- some query languages don't yet have it.
-- The CTE gives us timestamp repeated as well as the number of rows to generate)
--  while the random() function will give us random temp and humidity for each of
--   those rows.
with sensors_datetime as (select *
			from 
			(select * from generate_series(1, 100)) as t1,
			(select * from generate_series('2022-01-02 00:00'::timestamp,
										  '2022-03-01 00:00'::timestamp,
										  '10 days')) as t2
			)
select
	sd.*
	, floor(random()*80) as temperature
	, floor(random()*90) as humidity
from 
	sensors_datetime sd;