with fun1 as (select species, name, checkup_time, weight,
				(
					weight -
						 first_value(weight) over (partition by species, name
												   order by cast(checkup_time as date) asc
												   range between unbounded preceding
														and current row
												  )
				) as weight_gain
			from routine_checkups)
select *
from fun1
order by abs(weight_gain) desc;