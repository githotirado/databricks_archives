select species, breed
from animals as an1
except
select an2.species, an2.breed
from animals as an2
	inner join
	adoptions as ad
	on an2.species = ad.species and an2.name = ad.name
	
