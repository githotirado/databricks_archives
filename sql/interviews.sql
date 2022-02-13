select con.contest_id,
       con.hacker_id,
       con.name,
       sum(sst.total_submissions),
       sum(sst.total_accepted_submissions),
       sum(vst.total_views),
       sum(vst.total_unique_views)

from  contests con 
inner join colleges col on con.contest_id=col.contest_id
inner join challenges cha on col.college_id=cha.college_id
inner join view_stats vst on cha.challenge_id=vst.challenge_id
inner join submission_stats sst on cha.challenge_id=sst.challenge_id

group by con.contest_id, con.hacker_id, con.name
having sum(sst.total_submissions) is not null
   or sum(sst.total_accepted_submissions) is not null
   or sum(vst.total_views) is not null
   or sum(vst.total_unique_views) is not null
order by con.contest_id asc