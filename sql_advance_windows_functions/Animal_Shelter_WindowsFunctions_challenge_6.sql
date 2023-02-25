/*
------------------------------------
-- Top improved adoption quarters --
------------------------------------
Write a query that returns the top 5 most improved quarters in terms of the number of adoptions, both per species, and overall.
Improvement means the increase in number of adoptions compared to the previous calendar quarter.
The first quarter in which animals were adopted for each species and for all species, does not constitute an improvement from zero, and should be treated as no improvement.
In case there are quarters that are tied in terms of adoption improvement, return the most recent ones.

Hint: Quarters can be identified by their first day. */
with adoption_data as
(
	select species,
			date_part('year', adoption_date) as year,
			date_part('quarter', adoption_date) as quarter,
			count(*) as quarterly_adoptions
	from adoptions
	group by species,
			date_part('year', adoption_date), 
			date_part('quarter', adoption_date)
	union
	select 'All species' as species,
			date_part('year', adoption_date) as year,
			date_part('quarter', adoption_date) as quarter,
			count(*) as quarterly_adoptions
	from adoptions
	group by
			date_part('year', adoption_date), 
			date_part('quarter', adoption_date)
)  -- select * from adoption_data order by species asc, year asc, quarter asc
, adoption_w_improve as
(
	select *,
		lag(year) over species_quarter as prev_yr,
		lag(quarter) over species_quarter as prev_qtr
	from adoption_data
	window species_quarter as (partition by species order by year asc, quarter asc)
)   -- select * from adoption_w_improve
, adoption_w_diff as
(
	select species, year, quarter,
		case
			when (quarter = 1 and ((prev_yr <> year - 1)  or prev_qtr <> 4))
			  or (quarter = 2 and  (prev_yr <> year       or prev_qtr <> 1))
			  or (quarter = 3 and  (prev_yr <> year       or prev_qtr <> 2))
			  or (quarter = 4 and  (prev_yr <> year       or prev_qtr <> 3))
			  or prev_yr is null
			then quarterly_adoptions
			else (quarterly_adoptions - lag(quarterly_adoptions) 
									over (
											partition by species
											order by year asc, quarter asc
										)
				 )
			 end as difference_from_prev_quarter,
		case
			when prev_yr is null then true
			else false
		end as is_first_quarter,
		quarterly_adoptions
	from adoption_w_improve
) -- select * from adoption_w_diff
, adoption_w_ranking as
(
	select *,
		row_number() over (
			partition by species 
			order by 
				-- if first quarter, then no improvement hence override of 0 during ranking
				--   else use the assigned difference_from_prev_quarter.
				case
					when is_first_quarter then 0
					else difference_from_prev_quarter
				end
				desc, year desc, quarter desc
		) as ranking
	from adoption_w_diff
)  -- select * from adoption_w_ranking order by species  asc, difference_from_prev_quarter desc
select species, year, quarter, difference_from_prev_quarter, quarterly_adoptions
       -- , ranking
from adoption_w_ranking
where ranking <= 5
order by species asc, difference_from_prev_quarter desc, year asc, quarter asc nulls last
