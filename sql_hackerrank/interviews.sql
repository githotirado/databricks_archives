select con.contest_id,
       con.hacker_id,
       con.name,
    --    sum(sst.total_submissions),
    --    sum(sst.total_accepted_submissions),
    --    sum(vst.total_views),
    --    sum(vst.total_unique_views)
       sum(sum_total_submissions),
       sum(sum_total_accepted_submissions),
       sum(sum_total_views),
       sum(sum_total_unique_views)

from  contests con 
inner join colleges col on con.contest_id=col.contest_id
inner join challenges cha on col.college_id=cha.college_id
-- inner join view_stats vst on cha.challenge_id=vst.challenge_id
-- inner join submission_stats sst on cha.challenge_id=sst.challenge_id
left join (select challenge_id
                ,sum(total_views) sum_total_views
                ,sum(total_unique_views) sum_total_unique_views
            from view_stats
            group by challenge_id) as vst on cha.challenge_id=vst.challenge_id
left join (select challenge_id
                ,sum(total_submissions) sum_total_submissions
                ,sum(total_accepted_submissions) sum_total_accepted_submissions
            from submission_stats
            group by challenge_id) as sst on cha.challenge_id=sst.challenge_id

group by con.contest_id, con.hacker_id, con.name
-- having sum(sst.total_submissions) !=0
--    or sum(sst.total_accepted_submissions) !=0
--    or sum(vst.total_views) !=0
--    or sum(vst.total_unique_views) !=0
having sum(sum_total_submissions) !=0
   or  sum(sum_total_accepted_submissions) !=0
   or  sum(sum_total_views) !=0
   or  sum(sum_total_unique_views) !=0
order by con.contest_id asc