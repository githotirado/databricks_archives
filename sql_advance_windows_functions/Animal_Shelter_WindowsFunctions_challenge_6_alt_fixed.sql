WITH adoption_quarters
AS
(
SELECT 	Species, 
		MAKE_DATE (	CAST( EXTRACT ('year' FROM adoption_date) AS INT),
					CASE 
						WHEN EXTRACT ('month' FROM adoption_date) < 4
							THEN 1
						WHEN EXTRACT ('month' FROM adoption_date) BETWEEN 4 AND 6
							THEN 4
						WHEN EXTRACT ('month' FROM adoption_date) BETWEEN 7 AND 9
							THEN 7
						WHEN EXTRACT ('month' FROM adoption_date) > 9
							THEN 10
					END,
					1
				 ) AS quarter_start
FROM 	adoptions
)
-- SELECT * FROM adoption_quarters ORDER BY species, quarter_start;
,quarterly_adoptions
AS
(
SELECT 	species,
		quarter_start,
		COUNT (*) AS quarterly_adoptions,
		COUNT (*) - COALESCE (
					-- NULL could mean no adoptions in previous quarter, or first quarter of shelter
							 FIRST_VALUE ( COUNT (*))
							 OVER (	PARTITION BY species
							 		ORDER BY quarter_start ASC
								   	RANGE BETWEEN 	INTERVAL '3 months' PRECEDING 
													AND 
													INTERVAL '3 months' PRECEDING
						 		  )
							, 0)
		AS adoption_difference_from_previous_quarter,
		CASE 	
			WHEN	LAG (quarter_start) 
					-- Buggy version does not 'partition by species', hence was only
					-- getting first quarter start for dog/cat/rabbit combined instead
	 				-- of first quarter start by each species
					OVER (partition by species ORDER BY quarter_start ASC)
					IS NULL
			THEN 	TRUE
			ELSE 	FALSE
		END 	AS is_first_quarter
FROM 	adoption_quarters
GROUP BY	species,
			quarter_start
UNION ALL 
SELECT 	'All species' AS species,
		quarter_start,
		COUNT (*) AS quarterly_adoptions,
		COUNT (*) - COALESCE (
					-- NULL could mean no adoptions in previous quarter, or first quarter of shelter
							 FIRST_VALUE ( COUNT (*))
							 OVER (	ORDER BY quarter_start ASC
								   	RANGE BETWEEN 	INTERVAL '3 months' PRECEDING 
													AND 
													INTERVAL '3 months' PRECEDING
						 		  )
							, 0)
		AS adoption_difference_from_previous_quarter,
		CASE 	
			WHEN	LAG (quarter_start) 
					OVER (ORDER BY quarter_start ASC)
					IS NULL
			THEN 	TRUE
			ELSE 	FALSE
		END 	AS is_first_quarter
FROM 	adoption_quarters
GROUP BY	quarter_start
)
  -- SELECT * FROM quarterly_adoptions ORDER BY species, quarter_start;
,quarterly_adoptions_with_row_number
AS
(
SELECT 	*,
		ROW_NUMBER ()
		-- ROW_NUMBER and RANK will return the same result since quarter_start per species is unique
		OVER (	PARTITION BY species
				ORDER BY 	CASE  
			  				-- Bug #2: by setting the first adoption quarter to 0, you are not
			  				--   		eliminating the row when the time comes to assign row
			  				-- 			numbers (rankings).  Do not forget that
			  				--          adoption_difference_from_previous_quarter could be negative
			  				--			sometimes, and that should NOT rank the negative row after
			  				--  		the first quarter row.  In fact, the first quarter row should
			  				--			never be ranked.  Thus, the right solution is to eliminate
			  				--			the first quarter row before assigning ranks.
							WHEN is_first_quarter THEN 0
							-- First quarters should be considered as a 0
							ELSE adoption_difference_from_previous_quarter
			  				END DESC nulls last,
							quarter_start DESC)
		AS quarter_row_number
FROM 	quarterly_adoptions
-- BUG FIX #2: add this 'where' clause to prevent the first quarter from even being ranked
WHERE   is_first_quarter is false
)
 -- SELECT * FROM quarterly_adoptions_with_row_number ORDER BY species, /*quarter_row_number,*/ quarter_start;
SELECT 	species,
		CAST (DATE_PART ('year', quarter_start) AS INT) AS year,
		CAST (DATE_PART ('quarter', quarter_start) AS INT) AS quarter,
		adoption_difference_from_previous_quarter,
		quarterly_adoptions
FROM 	quarterly_adoptions_with_row_number
WHERE 	quarter_row_number <= 5
ORDER BY 	species ASC,
			adoption_difference_from_previous_quarter DESC,
			quarter_start ASC;