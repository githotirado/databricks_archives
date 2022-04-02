/*
in MSSQL - HT
Look for the minimum among the different 
combinations of power and age.
Look for the cheapest wand for a given combination
of age and power.
*/
select id, age, coins_needed, power
from
    (
        select id
            , age
            , coins_needed
            , min(coins_needed) over (partition by age, power) as min_coins
            , power
        from wands as wa
            inner join wands_property as wp
                on wa.code = wp.code
        where is_evil = 0
    ) as wawp
where coins_needed = min_coins
order by power desc, age desc;

/* Solution 2 with correlated subquery located in 'where' clause (NOT in 'select')
*/
select w.id, p.age, w.coins_needed, w.power 
from Wands as w 
    inner join Wands_Property as p 
        on (w.code = p.code) 
where p.is_evil = 0 
    and w.coins_needed = (
                            select min(coins_needed) 
                            from Wands as w1 
                                inner join Wands_Property as p1 
                                    on w1.code = p1.code
                                    and w1.power = w.power
                                    and p1.age = p.age
                            -- where w1.power = w.power and p1.age = p.age
                        ) 
order by w.power desc, p.age desc