select myname
from
    (select st.name myname, sal.salary mysal, fr.friend_id frid, fsal.salary frsal
    from students st
    join packages sal on st.id=sal.id
    join friends fr on st.id=fr.id
    join packages fsal on fr.friend_id = fsal.id) as sf
where sf.frsal > sf.mysal
order by sf.frsal;