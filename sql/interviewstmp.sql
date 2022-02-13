select  con.contest_id
       ,con.hacker_id
       ,con.name
       ,query2.total_submissions
       ,query2.total_accepted_submissions
       ,sum(vst.total_views)
       ,sum(vst.total_unique_views)

from   contests con
      ,colleges col
      ,challenges cha
      ,view_stats vst
      ,(select   con2.contest_id contest_id
                -- ,con2.hacker_id
                -- ,con2.name
                ,sum(sst2.total_submissions) total_submissions
                ,sum(sst2.total_accepted_submissions) total_accepted_submissions
        from     contests con2
                ,colleges col2
                ,challenges cha2
                ,submission_stats sst2
        where    con2.contest_id=col2.contest_id
            and  col2.college_id=cha2.college_id
            and  cha2.challenge_id=sst2.challenge_id
        group by con2.contest_id, con2.hacker_id, con2.name) as query2

where    con.contest_id=col.contest_id
    and  col.college_id=cha.college_id
    and  cha.challenge_id=vst.challenge_id
    and  con.contest_id=query2.contest_id
group by con.contest_id, con.hacker_id, con.name, query2.total_submissions, query2.total_accepted_submissions
having   sum(sst.total_submissions) is not null
   or    sum(sst.total_accepted_submissions) is not null
   or    sum(vst.total_views) is not null
   or    sum(vst.total_unique_views) is not null
order by con.contest_id;





select con.contest_id
       ,con.hacker_id
       ,con.name
       ,sum(sst.total_submissions)
       ,sum(sst.total_accepted_submissions)
from  contests con
      ,colleges col
      ,challenges cha
      ,submission_stats sst
where con.contest_id=col.contest_id
    and col.college_id=cha.college_id
    and cha.challenge_id=sst.challenge_id
group by con.contest_id, con.hacker_id, con.name
order by con.contest_id;