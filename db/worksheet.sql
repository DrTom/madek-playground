
SELECT * from usergrouppermisionsets, users, usergroups_users 
  WHERE users.id = usergroups_users.user_id 
    AND usergrouppermisionsets.usergroup_id = usergroups_users.usergroup_id
    AND usergrouppermisionsets.mediaresource_id = 99
    AND users.id = 5
    AND may_view = true;



--  efficient random row

explain analyze
  SELECT * FROM mediaresources ORDER BY random() LIMIT 1 ;

explain analyze
  SELECT * from  mediaresources 
    LIMIT 1 
    OFFSET (Floor(Random() * (SELECT count(*) from mediaresources)));


select * from mediaresources
 where id in
        (select floor(random() * (max_id - min_id + 1))::integer + min_id
           from generate_series(1,15),
                (select max(id) as max_id,
                        min(id) as min_id
                   from mediaresources) s1
         limit 15)
 order by random() limit 5;

--




