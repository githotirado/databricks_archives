select cm.company_code
      ,cm.founder
      ,count(distinct(lm.lead_manager_code))
      ,count(distinct(sm.senior_manager_code))
      ,count(distinct(m.manager_code))
      ,count(distinct(e.employee_code))
from company cm 
inner join lead_manager lm on cm.company_code=lm.company_code
inner join senior_manager sm on lm.company_code=sm.company_code
inner join manager m on sm.company_code = m.company_code
inner join employee e on m.company_code = e.company_code
group by cm.company_code, cm.founder
order by cm.company_code