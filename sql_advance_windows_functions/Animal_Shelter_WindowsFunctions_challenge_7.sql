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
select v.species, make_date(cast(date_part('year', v.vaccination_time) as int), 1, 1) as vaccine_yr,
		count(v.vaccination_time) as vaccinated
from vaccinations as v
group by v.species, date_part('year', v.vaccination_time)
order by v.species asc, vaccine_yr asc

select  ad.species, 
 		make_date(cast(date_part('year', ad.adoption_date) as int), 1, 1) as adoption_yr,
		count(ad.adoption_date) as adopted
from adoptions as ad
group by ad.species, date_part('year', ad.adoption_date)
order by ad.species, adoption_yr

select  an.species, 
 		make_date(cast(date_part('year', an.admission_date) as int), 1, 1) as admission_yr,
		count(an.admission_date) as admitted
from animals as an
group by an.species, date_part('year', an.admission_date)
order by an.species, admission_yr