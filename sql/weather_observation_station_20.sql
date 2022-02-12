select
    round(
        (
            (select max(lat_n)
            from
                (select top 50 percent lat_n
                from station
                order by lat_n asc) as bottom50) 
            +
            (select min(lat_n)
            from
                (select top 50 percent lat_n
                from station
                order by lat_n desc) as top50)
            ) / 2, 4, 1) as median;

-- select round(s.lat_n,4)
-- from station s
-- where   (select round(count(s.id)/2) - 1 
--           from station) = 
--         (select count(s1.id) 
--           from station s1 
--           where s1.lat_n > s.lat_n);