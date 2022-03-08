
-- Contest Leaderboard (MySQL)
select s.hacker_id, h.name, sum(s.max_score) ssum
from
    (select hacker_id, challenge_id, max(score) max_score
    from submissions
    group by hacker_id, challenge_id) as s
left outer join hackers h on s.hacker_id = h.hacker_id
group by s.hacker_id, h.name
having ssum > 0
order by ssum desc, s.hacker_id asc;

-- Second solution with partitioning (MSSQL).  Needed distinct row in the partition table
--  since we don't collapse the rows as we would if we had done a 'max' and group by
--  which would have collapsed the duplicate row!!
with ms as (select distinct hacker_id
                , challenge_id
                , score
                , max(score) over (partition by hacker_id, challenge_id
                                  order by hacker_id, challenge_id) as maxscore
            from submissions)
select ha.hacker_id
    , ha.name
    , sum(ms.maxscore) as summaxscore
from ms
inner join hackers ha on ms.hacker_id = ha.hacker_id
where ms.score = ms.maxscore
group by ha.hacker_id, ha.name
having sum(ms.maxscore) > 0
order by sum(ms.maxscore) desc, ha.hacker_id asc;