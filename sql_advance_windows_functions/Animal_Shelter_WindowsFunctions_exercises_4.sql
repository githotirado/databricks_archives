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

-- Exercise: for every year/month, calculate the monthly adoption fee
--   total as well as that month's percent of total for the year
--  MY SOLUTION 1 (without CTE), makes it practically unreadable but works
select DATE_PART ('year', adoption_date) as year,
	   DATE_PART ('month', adoption_date) as month,
	   sum(adoption_fee) as month_total,
		cast(sum(adoption_fee) * 100 
			 / 
			 sum(sum(adoption_fee)) over
		 		(partition by DATE_PART ('year', adoption_date))
			 as decimal(5,2))
			 as percent_of_year
from adoptions
group by DATE_PART ('year', adoption_date),
		 DATE_PART ('month', adoption_date)
order by year asc, month asc;

--  MY SOLUTION 2 (with CTE), makes same query a little longer but readable
with table_month_total as
	(
		select DATE_PART ('year', adoption_date) as year,
	   		   DATE_PART ('month', adoption_date) as month,
	   		   sum(adoption_fee) as month_total
		from adoptions
		group by DATE_PART ('year', adoption_date),
				 DATE_PART ('month', adoption_date)		
	)
select year, month,
	   month_total,
	   cast(month_total * 100 / 
			 sum(month_total) over (partition by year) as decimal(5,2))
			 as percent_of_year
from table_month_total
order by year asc, month asc;