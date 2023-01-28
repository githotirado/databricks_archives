-- in MSSQL
select format(min(lat_n), "F4")
from station
where lat_n > 38.778;