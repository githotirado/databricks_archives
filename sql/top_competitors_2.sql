select su.hacker_id
        , ha.name
        -- , su.score as hacker_score
        -- , di.score as max_score
        -- , count(*) as number_challenges
from submissions su
    inner join challenges ch
        on su.challenge_id = ch.challenge_id
    inner join difficulty di
        on ch.difficulty_level = di.difficulty_level
    inner join hackers ha
        on su.hacker_id = ha.hacker_id
where su.score = di.score
group by su.hacker_id, ha.name
    -- , su.score, di.score
having count(*) > 1
order by count(*) desc, su.hacker_id asc;