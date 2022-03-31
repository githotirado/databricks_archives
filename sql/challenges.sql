/* in MSSQL first solution
-- using 'in' with 'where' clause
-- using 'hackers' table in main clause 
--           try making table joins out of the subqueries
*/
with ch1 as (
    select hacker_id, 
            count(challenge_id) as challenge_count
    from challenges
    group by hacker_id
)
select ch1.hacker_id, ha.name, ch1.challenge_count
from ch1
    inner join hackers as ha
        on ch1.hacker_id = ha.hacker_id
where ch1.challenge_count in
    (
        select challenge_count
        from ch1
        group by ch1.challenge_count
        having  (
                    count(ch1.challenge_count) = 1
                ) 
                or
                (
                    ch1.challenge_count = (select max(challenge_count) 
                                            from ch1)
                )
    )
order by ch1.challenge_count desc, ch1.hacker_id asc;

/* 
in MSSQL Second solution
-- hackers table now inside the 'with' clause
-- using 'exists' instead of 'in' with correlative join
*/
with ch1 as (
    select  ch.hacker_id
            ,name
            ,count(ch.challenge_id) as challenge_count
    from challenges as ch
        inner join hackers as ha
            on ch.hacker_id = ha.hacker_id
    group by ch.hacker_id, name
)
select ch1.hacker_id, ch1.name, ch1.challenge_count
from ch1
where exists
    (
        select challenge_count
        from ch1 as ch2
        where ch1.challenge_count = ch2.challenge_count
        group by ch2.challenge_count
        having  (
                    count(ch2.challenge_count) = 1
                ) 
                or
                (
                    ch2.challenge_count = (select max(challenge_count) 
                                            from ch1)
                )
    )
order by ch1.challenge_count desc, ch1.hacker_id asc;