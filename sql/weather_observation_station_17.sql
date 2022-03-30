-- in mssql
select format(long_w, "F4")
from station
where lat_n = (select min(lat_n) from station where lat_n > 38.778);