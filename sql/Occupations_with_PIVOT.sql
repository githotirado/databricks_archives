-- My update to solution.  Assumes like get_dummies() function in Machine Learning:
--   Spread values across each possible value type column with '1' and '0'
--   Then on next pass get the 'min' of each resulting column and group/order by the
--   row number!
with pvt as (
            select row_number() over (partition by Occupation order by Name) as rownumber
                , case Occupation when 'Doctor' then name else null end as doctor
                , case Occupation when 'Professor' then name else null end as professor
                , case Occupation when 'Singer' then name else null end as singer
                , case Occupation when 'Actor' then name else null end as actor
            from Occupations
            )
select min(doctor), min(professor), min(singer), min(actor)
from pvt
group by pvt.rownumber
order by pvt.rownumber;

-- From discussion:
with cte as ( select RANK() OVER (PARTITION BY Occupation ORDER BY Name) as Rank
                    , case when Occupation='Doctor' then Name else null end as doctor
                    , case when Occupation='Professor' then Name else null end as prof
                    , case when Occupation='Singer' then Name else null end as singer
                    , case when Occupation='Actor' then Name else null end as actor 
                from Occupations
            )
select min(doctor), min(prof), min(singer), min(actor)
from cte 
group by Rank
