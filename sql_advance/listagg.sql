select distinct make, 
		model_year, 
		sum(sum),
		lead (model_year, 1, 'none') 
			over (partition by make order by make, model_year) as lead_model_year_1,
		lag (model_year, 2, 'blank') 
			over (partition by make order by make, model_year) as lag_model_year_2
from alternatebyfuel
where make like 'A%'
group by make, model_year
order by make, model_year
-- where make = 'TOYOTA'
-- limit 80;