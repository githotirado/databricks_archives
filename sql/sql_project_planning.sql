-- select p1.task_id, 
--     p1.start_date p1s, 
--     p1.end_date p1e,
--     p2.task_id,
--     p2.start_date p2s,
--     case
--     when p1.end_date = p2.start_date then "same"
--     else "new"
--     end as sequence
-- from projects p1
-- join projects p2 on p1.end_date=p2.start_date

select start_date, min(end_date)
from
    (select start_date 
    from projects
    where start_date not in (select end_date from projects)) a,

    (select end_date
    from projects
    where end_date not in (select start_date from projects)) b
where start_date < end_date
group by start_date
order by (datediff(start_date, min(end_date))) desc, start_date asc;