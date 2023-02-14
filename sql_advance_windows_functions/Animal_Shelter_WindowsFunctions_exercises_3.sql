-- For each animal, return the number of animals admitted prior to
-- the current animal's admission date.  use subquery in 'select'
select  a1.species, a1.name,
		a1.primary_color, a1.admission_date,
		(
			select count(*)
			from animals as a2
			where   a1.species = a2.species
					and
					a2.admission_date < a1.admission_date
		) as number_of_animals
from animals as a1
order by species asc,
		admission_date asc;
		
-- For each animal, return the number of animals admitted prior to
-- the current animal's admission date.  Use lateral table join
-- having condition in table definition and compensating for returning 'null'
select a1.species, a1.name,
	a1.primary_color, a1.admission_date,
 	coalesce(a2.number_of_animals, 0) as number_of_animals
from animals as a1
	left join lateral
		(
			select species,
					count(*) as number_of_animals
			from animals as a3
 			where a3.admission_date < a1.admission_date
			group by species
		) as a2
	on a1.species = a2.species
order by species asc,
		admission_date asc;
		
		
-- For each animal, return the number of animals admitted prior to
-- the current animal's admission date.  Use window function		
select a1.species, a1.name,
	a1.primary_color, a1.admission_date,
	count(*)
	over (partition by species
		  	order by admission_date asc
  	  		range between unbounded preceding
       		and '1 day' preceding
--  		  rows between unbounded preceding
--  		  and 1 preceding		 
		 )
	as number_of_animals
from animals as a1
order by species asc,
		admission_date asc;