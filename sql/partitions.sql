select * from vehiclecount2020
limit 30;

select v.make, v.zip_code, vehicles,
 	sum(vehicles) over (partition by make, zip_code) as newsum,
    count(vehicles) over (partition by make, zip_code) as newrank,
	avg(vehicles) over (partition by make, zip_code) as newavg
from vehiclecount2020 v;