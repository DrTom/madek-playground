

INSERT into mediaresourcegrouppermissions (mediaresource_id,usergroup_id) values (null,null);


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


explain analyze
  select * from mediaresources
   where id in
          (select floor(random() * (max_id - min_id + 1))::integer + min_id
             from generate_series(1,5),
                  (select max(id) as max_id,
                          min(id) as min_id
                     from mediaresources) s1
           limit 5)
   order by random() limit 1;

--

CREATE FUNCTION mrrow() RETURNS mediaresources
  AS $$
  DECLARE
    myrow mediaresources%rowtype;
  BEGIN
    SELECT INTO myrow * from mediaresources limit 1;
    return myrow;
  END $$
  LANGUAGE 'plpgsql';





CREATE OR REPLACE FUNCTION mr_rand_id() RETURNS int4
AS $$
DECLARE
  max_id integer;
  min_id integer;
  rand_id integer = -1;
BEGIN
  SELECT INTO max_id max(id) from mediaresources;
  SELECT INTO min_id min(id) from mediaresources;
  FOUND := false;
  WHILE NOT FOUND LOOP
    rand_id := floor(random() * (max_id - min_id + 1))::integer + min_id;
    PERFORM * from mediaresources WHERE id = rand_id;
  END LOOP;
  return rand_id;
END $$
LANGUAGE 'plpgsql';



