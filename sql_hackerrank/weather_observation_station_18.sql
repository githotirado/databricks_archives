select round(abs(a - c) +  abs(b - d), 4)
from
    (select min(lat_n) a,
        min(long_w) b,
        max(lat_n) c,
        max(long_w) d
    from station) as dv
    