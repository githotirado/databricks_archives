-- in MSSQL
select format(
    ((select max(lat_n)
    from
        (select top 50 percent lat_n
        from station
        order by lat_n asc) as bottom_values)
    +  
    (select min(lat_n)
    from
        (select top 50 percent lat_n
        from station
        order by lat_n desc) as top_values))
    / 2, "F4");

-- alternate solution in MSSQL (as long as even number of rows)
select format(S.LAT_N, "F4") as median 
from station S 
where   (
        select count(Lat_N) 
        from station 
        where Lat_N < S.LAT_N
        ) 
    = 
        (
        select count(Lat_N) 
        from station 
        where Lat_N > S.LAT_N
        );