select a.name
	, a.species
	, max(a.primary_color) as primary_color  -- dummy aggregation
	, min(a.breed) as breed -- dummy aggregation
 	, count(v.vaccine) as count_v
-- 	, count(*) as count_star
from animals as a
	left outer join
	vaccinations as v
	on a.name = v.name and a.species = v.species
where 
-- 	a.species <> 'Rabbit' and (v.vaccine <> 'Rabies' or v.vaccine is null)
	a.species <> 'Rabbit' and v.vaccine is distinct from 'Rabies'
group by a.name, a.species
having max(vaccination_time) < '2019-10-01' or max(vaccination_time) is null
order by a.species, a.name