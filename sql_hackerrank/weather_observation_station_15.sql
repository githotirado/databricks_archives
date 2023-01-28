-- in MSSQL with offset
select format(long_w, "F4")
from station
where lat_n < 137.2345
order by lat_n desc
offset 0 rows fetch next 1 row only;

-- in MSSQL with subquery
select format(long_w, "F4")
from station
where lat_n = (select max(lat_n) from station where lat_n < 137.2345);