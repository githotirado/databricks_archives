
-- Contest Leaderboard
select s.hacker_id, h.name, sum(s.max_score) ssum
from
    (select hacker_id, challenge_id, max(score) max_score
    from submissions
    group by hacker_id, challenge_id) as s
left outer join hackers h on s.hacker_id = h.hacker_id
group by s.hacker_id, h.name
having ssum > 0
order by ssum desc, s.hacker_id asc
