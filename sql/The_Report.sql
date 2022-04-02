/*
In MSSQL (better because it contains all 'order by' requirements)
Uses inner join and the additional 'order by' directive
*/
select 
    case
        when gr.grade >= 8 then st.name
        else Null
    end as student_name
    , gr.grade
    , st.marks
from grades as gr
    inner join students as st
        on st.marks >= gr.min_mark and st.marks <= gr.max_mark
order by gr.grade desc, student_name asc, st.marks asc;

/*
In MSSQL
Uses left outer join without third 'order by' directive
*/
select
    case
        when g.grade < 8 then Null
        else s.name
    end as name1,
    g.grade,
    s.marks
from students s
       left outer join grades g
              on s.marks >= g.min_mark and s.marks <= g.max_mark
order by g.grade desc, name1 asc;