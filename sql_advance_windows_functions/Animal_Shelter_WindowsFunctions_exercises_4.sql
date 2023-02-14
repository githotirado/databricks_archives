-- My Method for boolean column having 'true' only for animals who have all heart rates greater
--  than or equal to the species average heart rate
select species, name,
	checkup_time, heart_rate,
-- 	min(heart_rate) over (partition by species, name) as my_min_rate,
-- 	cast(avg(heart_rate) over (partition by species) as decimal(5,2)) as species_avg_rate,
	min(heart_rate) over (partition by species, name) >= avg(heart_rate) over (partition by species) as is_greater
from routine_checkups

-- Second method for boolean column having 'true' only for animals who have all heart rates greater
--  than or equal to the species average heart rate.  Uses 'every' and CTE
with species_rates as (
	select species, name,
		checkup_time, heart_rate,
		cast(
			avg(heart_rate)
			over (partition by species)
			as decimal(5,2)
		) as species_avg_rate
	from routine_checkups
)
select species, name,
	checkup_time, heart_rate,
	every ( heart_rate >= species_avg_rate )
	over (partition by species, name)
from species_rates