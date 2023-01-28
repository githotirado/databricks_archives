
-- Contest Leaderboard (MySQL) [can use select alias in 'having']
select s.hacker_id, h.name, sum(s.max_score) ssum
from
    (select hacker_id, challenge_id, max(score) max_score
    from submissions
    group by hacker_id, challenge_id) as s
left outer join hackers h on s.hacker_id = h.hacker_id
group by s.hacker_id, h.name
having ssum > 0
order by ssum desc, s.hacker_id asc;

-- MSSQL [cannot use 'select' alias in the 'having' clause]
select ha.hacker_id, ha.name, sum(mxs.maxscore) as sumscore
from
    (
        select hacker_id, challenge_id, max(score) as maxscore
        from submissions
        group by hacker_id, challenge_id
    ) as mxs
    inner join hackers as ha
        on mxs.hacker_id = ha.hacker_id
group by ha.hacker_id, ha.name
having sum(mxs.maxscore) > 0
order by sumscore desc, ha.hacker_id asc;

-- Contest Leaderboard (MSSQL) [can't use select aliases in 'having']
select md.hacker_id, h.name, sum(md.max_score) as sum_max_score
from hackers h
inner join
    (select hacker_id, challenge_id, max(s.score) as max_score
    from submissions s
    group by hacker_id, challenge_id
    ) as md
    on h.hacker_id = md.hacker_id
group by md.hacker_id, h.name
having sum(md.max_score) > 0
order by sum_max_score desc, md.hacker_id asc;

-- Second solution with partitioning (MSSQL) and CTE.  Needed distinct row in the partition table
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