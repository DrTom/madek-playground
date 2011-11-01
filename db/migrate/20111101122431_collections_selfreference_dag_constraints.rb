class CollectionsSelfreferenceDagConstraints < ActiveRecord::Migration
  def up
    execute <<-SQL

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

    SQL
  end

  def down
    execute <<-SQL

    DROP FUNCTION find_descendants(integer);
    DROP FUNCTION find_ancestors(integer)
    DROP FUNCTION ensure_dag_property_on_insert();
    DROP TRIGGER ensure_dag_property_trigger;

    SQL
  end

end
