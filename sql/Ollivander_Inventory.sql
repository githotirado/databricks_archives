-- Henry attempt with discussion help:
-- Notes: the over (partition) is a table calculation which is always done LAST
--     in a select statement.  That means the MinCoinsNeeded will not be available
--     until the end of the select, which means you would need an exterior select to
--     be able to access MinCoinsNeeded in order to add 
--     'where coins_needed = MinCoinsNeeded'
with datatable as (
    select id
        , age
        , coins_needed
        , min(coins_needed) over (partition by age, power order by coins_needed) as MinCoinsNeeded
        , power
    from wands w
    inner join wands_property wp on w.code = wp.code
    where is_evil = 0
)
select id
    , age
    , coins_needed
    , power
from datatable
where coins_needed = MinCoinsNeeded
order by power desc, age desc;


-- Solution 1
select id, age, coins_needed, power 
from ( 
    select id
            , age
            , coins_needed
            , power
            , min(coins_needed) over (partition by age, power order by coins_needed) as min_coins
    from wands w 
    inner join wands_property w_p on w.code=w_p.code 
    where is_evil=0 ) as a
where coins_needed = min_coins 
order by power desc, age desc;

-- Solution 2
with a as ( 
        select w.id
            , p.age
            , w.coins_needed
            , w.power
            , min(w.coins_needed) over ( partition by age, power order by coins_needed ) as min_coins
        from wands w 
        left join wands_property p on w.code = p.code
        where p.is_evil = 0 
        ) 
select id, age, coins_needed, power 
from a 
where coins_needed = min_coins 
order by power desc, age desc ;
