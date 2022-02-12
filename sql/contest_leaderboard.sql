select hacker_id, sum(max_score)
from
(select hacker_id, challenge_id, max(score) max_score
from submissions
group by hacker_id, challenge_id)
