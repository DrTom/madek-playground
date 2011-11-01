class CollectionsSelfreferenceNo2nodeloopConstraint < ActiveRecord::Migration

  def up
    execute <<-SQL

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

    SQL
  end

  def down

    execute <<-SQL
      DROP FUNCTION ensure_no_2nodeloop_on_insert();
      DROP TRIGGER ensure_no_2nodeloop_on_insert;
    SQL

  end

end
