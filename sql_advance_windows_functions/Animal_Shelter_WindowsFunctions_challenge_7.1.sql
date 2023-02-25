/* 
---------------------------------------------------------------------------------------
-- Triple bonus points challenge - Annual average animal species vaccinations report --
---------------------------------------------------------------------------------------
-- !!! DISCLAIMER !!! This one is far from trivial, so be patient and careful. --------
---------------------------------------------------------------------------------------
Write a query that returns all years in which animals were vaccinated, and the total number of vaccinations given that year, per species.
In addition, the following three columns should be included in the results:
1. The average number of vaccinations per shelter animal of that species in that year.
2. The average number of vaccinations per shelter animal of that species in the previous 2 years.
3. The percent difference between columns 1 and 2 above.
*/
with species_data as
(
	select  an.species,
			an.admission_yr as calendar_year,
			an.admitted,
			coalesce(ad.adopted, 0) as adopted,
			coalesce(v.vaccinated, 0) as vaccinated
	from
		(
			select  species, 
			make_date(cast(date_part('year', admission_date) as int), 1, 1) as admission_yr,
			count(admission_date) as admitted
			from animals
			group by species, date_part('year', admission_date)
		) as an
		left outer join
		(
			select  species, 
			make_date(cast(date_part('year', adoption_date) as int), 1, 1) as adoption_yr,
			count(adoption_date) as adopted
			from adoptions
			group by species, date_part('year', adoption_date)
		) as ad
		on an.species = ad.species and
		   an.admission_yr = ad.adoption_yr
		left outer join
		(
			select species, make_date(cast(date_part('year', vaccination_time) as int), 1, 1) as vaccine_yr,
			count(vaccination_time) as vaccinated
			from vaccinations
			group by species, date_part('year', vaccination_time)
		) as v
		on an.species = v.species and
		   an.admission_yr = v.vaccine_yr
)  -- select * from species_data order by species asc, calendar_year asc
, species_yr_avg as
(
-- 	 select *
 	select species, calendar_year, vaccinated as number_of_vaccinations
  	, sum(admitted - adopted) over (partition by species
 								     order by calendar_year asc
-- 				  					 rows between unbounded preceding and current row
 								 	) as animals_in_shelter
		, cast (vaccinated /(sum(admitted - adopted) 
			over (partition by species
				  order by calendar_year asc
-- 				  	rows between unbounded preceding and current row
				 )) as decimal(5,2)) as avg_vacc_animal
	from species_data
)  -- select * from species_yr_avg order by species asc, calendar_year asc
select *
	, cast(avg(avg_vacc_animal)
		over (partition by species
			  order by calendar_year asc
			  range between '2 year' preceding and '1 year' preceding) as decimal(5,2)) as avg_2_prev_yrs
from species_yr_avg
order by species asc, calendar_year asc