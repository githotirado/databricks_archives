select   sc1.submission_date
        ,sc1.hacker_id
        ,h.name
        ,
from hackers h
join 


    (select submission_date, hacker_id, count(hacker_id) hcount
    from submissions
    group by submission_date, hacker_id
    order by submission_date, count(hacker_id) desc) as sc1 
    
    on h.hacker_id=sc1.hacker_id
group by sc1.submission_date, sc1.hacker_id
order by sc1.submission_date asc, sc1.hacker_id asc





    (select submission_date, hacker_id
    from submissions) as sc2
    