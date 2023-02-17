-- To get top 3 animals per species with the most number of checkups
--   This solution uses row_number to first assign a row once checkups are ordered
--   in descending order, then picking the first 3 rows later
with row_number_checkups as
(
	select rs.species, rc.name,
			count(rc.name) as num_of_checkups,
			row_number() over (partition by rs.species
							  order by count(rc.name) desc, rc.name asc) as my_row
	from routine_checkups as rc
		right join reference.species as rs
		on rc.species = rs.species
	group by rs.species, rc.name
)
select rn.species, rn.name, rn.num_of_checkups
from row_number_checkups as rn
where my_row <= 3
order by rn.species asc, num_of_checkups desc

-- Alternate suggested by instructor
SELECT 	s.species,
		animal_checkups.name,
		COALESCE (animal_checkups.number_of_checkups, 0) AS number_of_checkups
FROM 	reference.species AS s
		LEFT OUTER JOIN LATERAL 
		(
			SELECT 	rc.species,
					rc.name,
					COUNT (*) AS number_of_checkups
			FROM 	routine_checkups AS rc
			WHERE 	s.species = rc.species
			GROUP BY 	rc.species, 
						rc.name
			ORDER BY 	rc.species ASC,
						number_of_checkups DESC,
						name ASC
			LIMIT 3 OFFSET 0
		) AS animal_checkups
		ON TRUE;