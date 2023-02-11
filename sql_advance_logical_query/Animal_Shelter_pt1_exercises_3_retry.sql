select a.name,
	a.species,
	max (a.primary_color) as primary_color,
	min(a.breed) as breed,
    count(*) as count_star,
	count(vaccine) as count_vaccine
from animals as a
	left outer join
	vaccinations as v
	on a.species = v.species and a.name = v.name
where a.species <> 'Rabbit'
	and (v.vaccine <> 'Rabies' or v.vaccine is null)
group by a.name, a.species
having max(vaccination_time) < '2019-10-01' or max(vaccination_time) is null
order by a.species, a.name