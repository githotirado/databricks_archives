-- means to getting max adoption fee
select max(adoption_fee)
from adoptions;

-- percentage discount per adoption
select *
	, (select max(adoption_fee) from adoptions)
	, ((select max(adoption_fee) from adoptions) - adoption_fee) * 100 / (select max(adoption_fee) from adoptions) as adopt_percent
from adoptions;

-- max fee per species
select  *
	, (select max(adoption_fee)
	   from adoptions a2
	  where a2.species = a1.species) as max_fee
from adoptions a1;

-- people adopting at least one animal (table joins)
select distinct p.*
from persons p
	inner join adoptions ad
		on p.email = ad.adopter_email;
		
-- people adopting at least one animal ('in' filter)	
select p.*
from persons p
where p.email in (select adopter_email
				  from adoptions);

-- people adopting at least one animal ('exists' filter)
select *
from persons as p
where exists (select adopter_email
			 from adoptions as a
			 where a.adopter_email = p.email);
-- ---------- animals never adopted ---------------------			 
-- animals that were never adopted (exist filter)
select an.name
	, an.species
from animals as an
where not exists (select ad.name
				from adoptions ad
				where ad.name = an.name
					and ad.species = an.species);
					
-- animals never adopted (left outer join)
select distinct an.name, an.species
from animals as an
	left outer join adoptions as ad 
		on an.name = ad.name 
			and an.species = ad.species
where ad.name is null; 
 
-- animals never adopted (set operators)
select an.name, an.species
from animals as an
except (select ad.name, ad.species
	   from adoptions as ad);
	   
-- ----------------------------------------------------------------------------------------	   
-- --------  breeds never adopted  ----
-- breeds never adopted (outer join)

-- select distinct an.breed, an.species  -- DOES NOT WORK UNLESS adopted.breed is null.
-- from animals as an
-- 	left outer join adoptions as ad
-- 		on an.name = ad.name and an.species = ad.species
-- 	left outer join (select distinct breed
-- 						from animals as an2
-- 							inner join adoptions as ad2
-- 								on an2.name = ad2.name and an2.species = ad2.species) as adopted
-- 			on an.breed = adopted.breed
-- where ad.name is null and adopted.breed is null;

-- Does not work even when an1.breed is not null...
-- select distinct an1.breed, an1.species
-- from animals as an1
-- 	left outer join (select distinct breed, an2.species
-- 						from animals as an2
-- 							inner join adoptions as ad2
-- 								on an2.name = ad2.name and an2.species = ad2.species) as adopted
-- 			on an1.breed = adopted.breed
-- where adopted.breed is null 
-- and an1.breed is not null;
		
-- breeds never adopted (not exists) -- NOT WORKING!!!

-- select distinct breed
-- from animals as an
-- where not exists (select null
-- 				from adoptions as ad
-- 				where ad.name = an.name and ad.species = an.species);
--
-- select distinct breed, an.species
-- from animals as an
-- where not exists (select null
-- 				from adoptions as ad
-- 				where ad.name = an.name and ad.species = an.species);
				
				
-- breeds never adopted (not in) PARTIALLY WORKS WHEN EXCLUDING NULL FROM SUBQUERY!!!
select distinct breed, an1.species
from animals as an1
where (breed, an1.species) not in (select  breed, an2.species
				   from animals as an2
				   	inner join adoptions as ad
					on an2.name = ad.name and an2.species = ad.species
				  	where breed is not null);
					
-- breeds never adopted (set operators) -- WORKING!!  Provided 2 examples
select an1.breed, an1.species		-- this is list of breeds that weren't adopted
from animals as an1
	left outer join adoptions as ad
		on an1.name = ad.name and an1.species = ad.species
where ad.name is null
except
select an2.breed, an2.species		-- this is list of breeds that were adopted
from animals as an2
	inner join adoptions as ad
		on an2.name = ad.name and an2.species = ad.species;
		
select breed, species		-- this is full list of breeds (WORKS!!!)
from animals as an1
except
select an2.breed, an2.species		-- this is list of breeds that were adopted
from animals as an2
	inner join adoptions as ad
		on an2.name = ad.name and an2.species = ad.species;

