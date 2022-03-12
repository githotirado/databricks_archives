-- Solution first time (MySQL) [has different datediff implementation]
select start_date, min(end_date)
    -- , datediff(min(end_date), start_date)
from
    (select start_date 
    from projects
    where start_date not in (select end_date from projects)) a,  
    (select end_date
    from projects
    where end_date not in (select start_date from projects)) b
where start_date < end_date
group by start_date
order by datediff(min(end_date), start_date) asc, start_date asc;

-- Solution second time (MSSQL) [has alternate datediff implementation]
select sd.start_date
        , min(ed.end_date)
       -- , datediff(day, sd.start_date, min(ed.end_date))
from
    (select start_date
    from projects
    where start_date not in (select end_date from projects)) as sd,
    (select end_date
    from projects
    where end_date not in (select start_date from projects)) as ed
where sd.start_date < ed.end_date
group by sd.start_date
order by datediff(day, sd.start_date, min(ed.end_date)) asc, sd.start_date asc;