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

-- select species, name, checkup_time, heart_rate, species_avg, all with heart rate above species avg
with checkup as (select species
	, name
	, checkup_time
	, heart_rate
	, cast(avg(heart_rate) over (partition by species) as decimal(5, 2)) as species_avg
	, min(heart_rate) over (partition by species, name) as animal_min
from routine_checkups)

select distinct species, name, heart_rate, species_avg,
 		every (heart_rate >= species_avg) over (partition by species, name) as bool_value
--  		case
--  			when animal_min >= species_avg then True
--  			else False
--  		end as bool_value
from checkup
where animal_min >= species_avg
order by species asc, name asc --, checkup_time asc;

/* CHAPTER 4 CHALLENGE - AGGREGATE WINDOW FUNCTIONS
=================================================================================
get vaccine counts per year + avg of previous 2 years per line and percentage.
*/
with vt as (
	select date_part('year', vaccination_time) as year
		, count(*) as number_of_vaccinations
	from vaccinations
	group by date_part('year', vaccination_time)
),
	vt2 as (
		select *
		, cast(
				(
					avg(number_of_vaccinations) 
						over (
							  order by year asc
							  rows between 2 preceding and 1 preceding
							 )
				) as decimal(5,2)
		) as previous_2_years_average
	from vt
)
select *
	, cast((number_of_vaccinations * 100 / previous_2_years_average) as decimal(5,2)) as percent_change
from vt2
order by year

/*
extract(year from vaccination_time)
  is same as
date_part('year', vaccination_time)
=================================================================================
*/

/* postgreSQL
Show year, month, monthly adoption total, percent of annual total
*/
with adopt_table as (
						select date_part('year', adoption_date) as year
							, date_part('month', adoption_date) as month
							, sum(adoption_fee) as monthly_revenue
						from adoptions
						group by date_part('year', adoption_date), date_part('month', adoption_date)
					)
select year
		, month
		, monthly_revenue
		, sum(monthly_revenue) over (partition by year) as yearly
		, cast(monthly_revenue * 100 / (sum(monthly_revenue) over (partition by year)) as decimal(5,2)) as pct
from adopt_table
order by year, month;

/* CHAPTER 5 LECTURE - ROW_NUMBER
Get top 3 animals per species having the most routine vaccines
*/
with animal_checkups as (select s.species, name, count(name) as number_of_checkups
						from reference.species as s
							left outer join routine_checkups as rc
								on s.species = rc.species
						group by s.species, name
						order by s.species, number_of_checkups desc
						),
counted_ck as (select *, (
						select count(*)
						from animal_checkups as ac2
						where ac2.species = animal_checkups.species
						and ac2.number_of_checkups > animal_checkups.number_of_checkups
					  ) as count_gt_checkups
			   from animal_checkups),
routine_count as (select *
	, row_number() over (partition by species
				   order by count_gt_checkups asc, name asc
				 -- order by number_of_checkups desc, name asc
				  ) as row_counted
from counted_ck)
select *
from routine_count
where row_counted <= 3

/*
CHAPTER 5 - CHALLENGE
Get top 25% of animals by species with fewest temperature exceptions 
(exception +/- 0.5% of species average) 
*/
with data_avg as (
	select species, name
		-- , count(*) over (partition by species, name) as number_of_checkups
		, temperature
		, cast(avg(temperature) over (partition by species) as decimal(5,2)) as species_avg_temp
		, checkup_time
	from routine_checkups)
select *
from data_avg
order by species asc, checkup_time desc;