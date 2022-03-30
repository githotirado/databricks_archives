-- in MSSQL
select format(sum(lat_n), "F4")
from station
where lat_n > 38.788 and lat_n < 137.2345