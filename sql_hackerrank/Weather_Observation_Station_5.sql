select city, length(city) city_len
from station
order by city_len asc, city asc
limit 1;
select city, length(city) city_len
from station
order by city_len desc, city asc
limit 1;
