select * from vehiclecount2020
limit 30;

select v.make, v.zip_code, vehicles,
	sum(vehicles) over (partition by make, zip_code) as newsum
from vehiclecount2020 v
where zip_code = '91505';