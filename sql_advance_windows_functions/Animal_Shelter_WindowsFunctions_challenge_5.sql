/*
------------------------------------------
-- Animals temperature exception report --
------------------------------------------

Write a query that returns the top 25% of animals per species that had the fewest “temperature exceptions”.
Ignore animals that had no routine checkups.
A “temperature exception” is a checkup temperature measurement that is either equal to or exceeds +/- 0.5% from the specie's average.
If two or more animals of the same species have the same number of temperature exceptions, those with the more recent exceptions should be returned.
There is no need to return additional tied animals over the 25% mark.
If the number of animals for a species does not divide by 4 without remainder, you may return 1 more animal, but not less.
*/
with animal_temp_comp as
(   -- get main data columns, calculate two temperature thresholds
	select species, name,
		temperature,
 		checkup_time,
		cast((avg(temperature) over (partition by species)) * 1.005 as decimal(5,2)) as species_avg_plus_5,
		cast((avg(temperature) over (partition by species)) * 0.995 as decimal(5,2)) as species_avg_minus_5
	from routine_checkups
)
,animal_num_exceptions as
( 	-- determine exception rows based on calculated temperature thresholds
	select *,
		case
			when (temperature >= species_avg_plus_5 
				  or temperature <= species_avg_minus_5)
		    then 1
		    else 0
		end as exception1
	from animal_temp_comp
)
, animals_grouped as 
(	-- Calculate most recent exceptions date (or null), exceptions count per animal
	select species, name,
	(
		select coalesce(max(checkup_time), null)
		from animal_num_exceptions as ane2
		where ane2.species = ane1.species
		      and ane2.name = ane1.name
			  and ane2.exception1 = 1
	) as latest_exception,
	sum(exception1) as number_of_exceptions
	from animal_num_exceptions as ane1
	group by species, name
)
, animal_list as
(	-- Segment list into quarters by species.  Identify top 4th
	select species, name, number_of_exceptions, latest_exception,
		 ntile(4) over (
							partition by species
							order by number_of_exceptions asc,
									latest_exception desc
						) as top_fourth
	from animals_grouped
)
select species, name, number_of_exceptions, latest_exception
from animal_list
where top_fourth = 1
order by species asc, number_of_exceptions desc, latest_exception desc;