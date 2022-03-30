-- in MSSQL
with ch1 as (
    select hacker_id, 
            count(challenge_id) as challenge_count
    from challenges
    group by hacker_id
)
select min(ch1.hacker_id), min(ha.name), ch1.challenge_count
from ch1
    inner join hackers as ha
        on ch1.hacker_id = ha.hacker_id
group by ch1.challenge_count
having  (
            count(ch1.challenge_count) < 2 
            and ch1.challenge_count < (select max(challenge_count) from ch1)
        ) 
        or
        (
                ch1.challenge_count = (select max(challenge_count) from ch1)
        )  
order by ch1.challenge_count desc, min(ch1.hacker_id) asc;