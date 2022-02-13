
select distinct nt.node,
       CASE
       when nt.parent is null then 'Root'
       when nt.child is null then 'Leaf'
       when nt.parent is not null and nt.child is not null then 'Inner'
       end as outvalue
from
    (select b1.n node, b1.p parent, b2.n child
    from bst b1
    left outer join bst b2 on b1.n=b2.p) as nt
order by nt.node