

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




-- it is possible to return a row by queriing
-- select * from myfun(); 
-- see section 35.4.2 

CREATE OR REPLACE FUNCTION mr_rand_id() RETURNS int4
AS $
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



CREATE OR REPLACE FUNCTION test() RETURNS int4[]
AS $$
DECLARE
  myarr int[];
BEGIN
  myarr := '{1,2,3,7,0,2,1}'::int[];
  return sort(myarr);
END $$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION array_intersect(ANYARRAY, ANYARRAY)
RETURNS ANYARRAY
LANGUAGE SQL
AS $$
SELECT ARRAY(
  SELECT $1[i] AS "the_intersection"
  FROM generate_series(
    array_lower($1,1),
    array_upper($1,1)
  ) AS i
  INTERSECT
  SELECT $2[j] AS "the_intersection"
  FROM generate_series(
    array_lower($2,1),
    array_upper($2,1)
  ) AS j
);
$$;

CREATE OR REPLACE FUNCTION collection_children(integer, integer[])
RETURNS SETOF integer
AS $$
SELECT child_id from collections_parent_child_joins WHERE parent_id = $1 ORDER BY child_id ASC;
$$
LANGUAGE SQL;


CREATE OR REPLACE FUNCTION collection_descendants(integer)
RETURNS SETOF integer
AS $$
DECLARE
BEGIN
  DROP TABLE processed_nodes;
  CREATE TEMP TABLE processed_nodes (id integer NOT NULL UNIQUE);
  DROP TABLE new_nodes;
  CREATE TEMP TABLE new_nodes (id integer NOT NULL UNIQUE);
  SELECT id from processed_nodes;
END $$
LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION collection_descendants(integer)
RETURNS SETOF integer
AS $$
DECLARE
current integer = NULL;
BEGIN
  DROP TABLE descendants ;
  CREATE TEMP TABLE descendants (id integer NOT NULL UNIQUE);
  INSERT into descendants (id) values ($1);
  SELECT find_descendants(id);
RETURN;
END $$
LANGUAGE PLPGSQL;


-- ############  



CREATE OR REPLACE FUNCTION collection_descendants(integer)
RETURNS SETOF integer
AS $$
DECLARE
current integer = NULL;
BEGIN
  if exists (select 1 from pg_tables where tablename = 'descendants') THEN drop table descendants; END IF;
  CREATE TEMP TABLE descendants (id integer NOT NULL UNIQUE);
  PERFORM find_descendants($1);
RETURN;
END $$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION collection_ancestors(integer)
RETURNS void
AS $$
DECLARE
current integer = NULL;
BEGIN
  if exists (select 1 from pg_tables where tablename = 'ancestors') THEN drop table ancestors; END IF;
  CREATE TEMP TABLE ancestors (id integer NOT NULL UNIQUE);
  PERFORM find_ancestors($1);
RETURN;
END $$
LANGUAGE PLPGSQL;




CREATE OR REPLACE FUNCTION find_descendants(integer)
RETURNS void
AS $$
DECLARE
  crow record;
BEGIN
  FOR crow IN SELECT child_id FROM collections_parent_child_joins WHERE parent_id = $1 LOOP
    IF (SELECT count(*) from descendants WHERE id = crow.child_id) = 0 THEN
      INSERT into descendants (id) values (crow.child_id);
      PERFORM find_descendants(crow.child_id);
    END IF;
  END LOOP;
RETURN;
END $$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION find_ancestors(integer)
RETURNS void
AS $$
DECLARE
  crow record;
BEGIN
  FOR crow IN SELECT parent_id FROM collections_parent_child_joins WHERE child_id = $1 LOOP
    IF (SELECT count(*) from ancestors WHERE id = crow.parent_id) = 0 THEN
      INSERT into ancestors (id) values (crow.parent_id);
      PERFORM find_ancestors(crow.parent_id);
    END IF;
  END LOOP;
RETURN;
END $$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION ensure_dag_property_on_insert() 
RETURNS trigger
AS $$
DECLARE
  cycle boolean = false;
BEGIN

  if exists (select 1 from pg_tables where tablename = 'ancestors') THEN 
    RAISE 'temporary table ancestors exists already'; 
  END IF;
  if exists (select 1 from pg_tables where tablename = 'descendants') THEN 
    RAISE 'temporary table descendants exists already'; 
  END IF;
  CREATE TEMP TABLE ancestors (id integer NOT NULL UNIQUE);
  CREATE TEMP TABLE descendants (id integer NOT NULL UNIQUE);

  PERFORM find_ancestors(NEW.parent_id);
  PERFORM find_descendants(NEW.child_id);

  cycle :=  Exists (SELECT * from descendants INTERSECT SELECT * from ancestors);

  DROP TABLE ancestors;
  DROP TABLE descendants;

  IF cycle THEN
    RAISE 'inserting this edge would introduce a circular structure';
    RETURN NULL;
  ELSE
    RETURN NEW;
  END IF;

END $$
LANGUAGE PLPGSQL;

CREATE TRIGGER ensure_dag_property_trigger
  BEFORE INSERT OR UPDATE
  ON collections_parent_child_joins
  FOR EACH ROW execute procedure ensure_dag_property_on_insert();

-- #################


CREATE OR REPLACE FUNCTION ensure_no_2nodeloop_on_insert() 
RETURNS trigger
AS $$
DECLARE
BEGIN
  if EXISTS (SELECT * from collections_parent_child_joins WHERE parent_id = NEW.child_id and child_id = NEW.parent_id ) THEN
    RAISE 'the inverse edge exists already'; 
    RETURN NULL;
  ELSE
    RETURN NEW;
  END IF;
END $$
LANGUAGE PLPGSQL;


CREATE TRIGGER ensure_no_2nodeloop_on_insert
  BEFORE INSERT OR UPDATE
  ON collections_parent_child_joins
  FOR EACH ROW execute procedure ensure_no_2nodeloop_on_insert();


