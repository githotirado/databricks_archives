select grouping(extract(year from vaccination_time)) as year
	, an.species as species
-- 	, pe.email
-- 	, first_name
-- 	, last_name
	, '# vaccinations' as Number_of_Vaccinations
	, 'latest_vaccination_year' as Latest_Vaccination_Year
from animals as an
	inner join vaccinations as va
		on an.name = va.name and an.species = va.species
	inner join persons as pe
		on va.email = pe.email
group by grouping sets (
							extract(year from vaccination_time)
							, an.species
							, (extract(year from vaccination_time), an.species)
					)
order by year, species --, first_name, last_name
;
-- select extract(year from adoption_date) as year
-- 	, extract(month from adoption_date) as month
-- 	, count(*) as monthly_count
-- from adoptions
-- group by grouping sets ( (extract(year from adoption_date), extract(month from adoption_date)),
-- 						 extract(year from adoption_date),
-- 						()
-- 	)
-- order by year, month

select name, species, primary_color, admission_date
	, count(*) over (partition by species
					 order by admission_date
					 range between unbounded preceding
					 	and current row
					) as total_count
from animals as an
where admission_date > '2017-08-01' and species = 'Dog';

/* 
Window functions / partitioning and framing
*/
with checkup as (select species
	, name
	, checkup_time
	, heart_rate
	, cast(avg(heart_rate) over (partition by species) as decimal(5, 2)) as species_avg
	, min(heart_rate) over (partition by species, name) as animal_min
from routine_checkups)
-- select species, name, checkup_time, heart_rate, species_avg,
select distinct species, name, heart_rate, species_avg,
 		every (heart_rate >= species_avg) over (partition by species, name) as bool_value
--  		case
--  			when animal_min >= species_avg then True
--  			else False
--  		end as bool_value
from checkup
where animal_min >= species_avg
order by species asc, name asc --, checkup_time asc;

/* 
get vaccine counts per year + avg of previous 2 years per line and percentage.
*/
with vacc_data as (select date_part('year', vaccination_time) as year
					, count(*) as number_of_vaccinations
				   from vaccinations
				   group by date_part('year', vaccination_time)),
vacc_data_2 as (select *
					, cast(avg(number_of_vaccinations) over (
									 order by year asc
									 rows between 2 preceding and 1 preceding) as decimal(5,2)) as previous_2_yr_avg
				from vacc_data)
select *
	, cast((number_of_vaccinations * 100 / previous_2_yr_avg) as decimal(5,2)) as percent_change
from vacc_data_2;