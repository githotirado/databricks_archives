-- Correct query 1 with no subquery
select  su.hacker_id
        , ha.name
        -- ,count(su.hacker_id)
from submissions su
inner join challenges ch on su.challenge_id = ch.challenge_id
inner join difficulty di on ch.difficulty_level = di.difficulty_level
inner join hackers ha on su.hacker_id = ha.hacker_id
where su.score = di.score
group by su.hacker_id, ha.name
having count(su.hacker_id) > 1
order by count(su.hacker_id) desc, su.hacker_id asc;

-- Correct query 2 with subquery (must alias all columns in subquery)
select ha.hacker_id
    , ha.name
from hackers ha,
    (select  su.hacker_id as HackerID
            ,count(su.hacker_id) as countHackerID
    from submissions su
    inner join challenges ch on su.challenge_id = ch.challenge_id
    inner join difficulty di on ch.difficulty_level = di.difficulty_level
    where su.score = di.score
    group by su.hacker_id
    having count(su.hacker_id) > 1 ) as hs
where ha.hacker_id = hs.HackerID
order by hs.countHackerID desc, ha.hacker_id asc;

-- correct query 3 with inner join to subquery (alias all subquery cols)
select ha.hacker_id
    , ha.name
from hackers ha
inner join 
    (select  su.hacker_id as HackerID
            ,count(su.hacker_id) as countHackerID
    from submissions su
    inner join challenges ch on su.challenge_id = ch.challenge_id
    inner join difficulty di on ch.difficulty_level = di.difficulty_level
    where su.score = di.score
    group by su.hacker_id
    having count(su.hacker_id) > 1 ) as hs
   on ha.hacker_id = hs.HackerID
order by hs.countHackerID desc, ha.hacker_id asc;