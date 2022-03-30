/*
ADVANCED JOINS

Add 2 duplicate animals into the table both adopted of different species
-- insert into Animals (name, species, primary_color, Implant_Chip_ID, Breed, Gender, Birth_Date, Pattern, Admission_Date)
-- values ('Duplicate', 'Dog', 'Black', 7757462342423434343, NULL, 'M', '20171001', 'Solid', '20171101'),
--        ('Duplicate', 'Rabbit', 'Black', 7757462342423434344, NULL, 'M', '20171001', 'Solid', '20171101');
insert into adoptions (Name, Species, Adopter_Email, Adoption_Date, Adoption_Fee)
values ('Duplicate', 'Dog', 'alan.cook@hotmail.com', '20181201', 40),
		('Duplicate', 'Rabbit', 'alan.cook@hotmail.com', '20181201', 40);
*/

-- Adopter_emails who adopted two animals on the same day
select a1.adopter_email, a1.adoption_date,
		a1.name, a1.species,
		a2.name, a2.species
from adoptions as a1
	inner join adoptions as a2
		on a1.adopter_email = a2.adopter_email
		and a1.adoption_date = a2.adoption_date
		and (
				(a1.species < a2.species and a1.name = a2.name)
			or
--   				(a1.name < a2.name and a1.species = a2.species)
-- 			or
-- 				(a1.name < a2.name and a1.species <> a2.species)
			     a1.name < a2.name
			)
order by adoption_date;

-- All animals with their most recent vaccination (with select subquery / returns only one value)
select an.name, an.species, an.breed,
		(
			select v.vaccine
			from vaccinations v
			where v.name = an.name
				and v.species = an.species
			order by v.vaccination_time desc
			offset 0 rows fetch next 1 row only
		) as vaccine_time
from animals an;

-- All animals with most recent vaccinations (using 'from' clause with lateral joins)
-- this one excludes animals not vaccinated
select an.name, an.species, an.breed, vacc.*
from
			animals as an
	cross join lateral
			(
				select v.vaccine, v.vaccination_time
				from vaccinations v
				where v.name = an.name
					and v.species = an.species
				order by v.vaccination_time desc
				offset 0 rows fetch next 3 rows only
			   ) as vacc;


--includes animals not vaccinated
select an.name, an.species, an.breed, vacc.*
from
			animals as an
	left outer join lateral
			(
				select v.vaccine, v.vaccination_time
				from vaccinations v
				where v.name = an.name
					and v.species = an.species
				order by v.vaccination_time desc
				offset 0 rows fetch next 3 rows only
			   ) as vacc
		   on True;
		   
-- figure out which animals are breeding candidates
--    both same breed
--    one M and one F
--    columns:  species, breed, male name, female name
select * from animals limit 1;

select a1.species, a1.breed, a1.name as Male, a2.name as Female
from animals a1
	inner join animals a2
		on a1.breed = a2.breed
		and a1.species = a2.species
		and a1.gender = 'M' and a2.gender = 'F'
order by species, breed;
