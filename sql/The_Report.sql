select
       case
       when g.grade < 8 then 'NULL'
       else s.name
       end as name1,
       g.grade,
       s.marks
from students s
left outer join grades g on s.marks >= g.min_mark and s.marks <= g.max_mark
order by g.grade desc, name1 asc;