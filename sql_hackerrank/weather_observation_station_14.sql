-- in MSSQL
select str(max(lat_n), 10, 4)
from station
where lat_n < 137.2345