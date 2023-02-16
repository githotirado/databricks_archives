-- Ch 4 challenge: year, number of vaccinations, avg of previous 2 years,
--   percent difference between current year and avg of previous 2 years.
with yearly_totals as (
	select DATE_PART ('year', vaccination_time) as year,
		   count(vaccine) as number_of_vaccinations,
		   cast (avg(count(vaccine)) 
				over (
					order by DATE_PART ('year', vaccination_time) asc
					range between 2 preceding and 1 preceding
				) as decimal(5,2)) as previous_2_years_average
	from vaccinations
	group by DATE_PART ('year', vaccination_time)
)
select *,
	cast(
		number_of_vaccinations 
		* 100 
		/ previous_2_years_average as decimal(5,2)
	) as percent_change
from yearly_totals
order by year asc;