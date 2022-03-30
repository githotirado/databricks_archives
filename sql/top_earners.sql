-- in MSSQL with 'where' and hidden aggregate function, 2 aggregates in select
select max(salary * months), count(*)
from employee em
where salary * months = 
        (select max(salary * months) from employee);

-- in MSSQL 1 aggregate in select, compensate by putting in 'group by'
select salary * months, count(*)
from employee em
where salary * months = (select max(salary * months) from employee)
group by salary, months;

-- in MSSQL with group/having/order/offset, no 'where' w aggregate
select max(salary * months), count(*)
from employee em
group by salary, months
having salary * months = max(salary * months)
order by (salary * months) desc
offset 0 rows fetch next 1 row only;