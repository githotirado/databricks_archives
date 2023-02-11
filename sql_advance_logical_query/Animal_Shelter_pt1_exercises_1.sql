-- 1. Constructing Query Source Data Sets Challenge
select a.name
	, a.species
	, breed
	, primary_color
	, vaccination_time
	, vaccine
	, first_name
	, last_name
	, role
from animals as a
	left outer join
	(
		vaccinations as v
		inner join 
		persons as p
		on v.email = p.email
		inner join 
		staff_assignments as sa
		on p.email = sa.email
	)  
	on a.name = v.name and a.species = v.species