-- in MSSQL
select cast(ceiling(avg(cast(salary as float)) - avg(cast(replace(str(salary), '0', '') as float))) as int)
from employees em;