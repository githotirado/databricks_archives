select male.species, male.breed, male.name as male, female.name as female
from animals as male
	inner join
	animals as female
	on male.species = female.species
	and male.breed = female.breed
-- 	and male.gender = 'M'
-- 	and female.gender = 'F'
	and male.gender > female.gender
-- 	and male.name <> female.name
order by male.species, male.breed;