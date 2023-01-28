-- sqrt((q1 - p1)^2 + (q2 - p2)^2)
select truncate(sqrt(power((ev.b - ev.a), 2) + power((ev.d - ev.c), 2)), 4)
from
    (select min(LAT_N) a, min(LONG_W) c,
        max(LAT_N) b, max(LONG_W) d
    from station) as ev