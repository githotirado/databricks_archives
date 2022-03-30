-- in MSSQL
select format(round(sum(lat_n), 2), "F2")
    , format(round(sum(long_w), 2), "#.00")
from station;