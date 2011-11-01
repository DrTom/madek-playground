class CollectionParentsChildrenJointable < ActiveRecord::Migration
  def up

    execute <<-SQL
      CREATE TABLE collections_parent_child_joins
      ( parent_id integer NOT NULL REFERENCES collections (id) ON DELETE CASCADE
      , child_id integer NOT NULL REFERENCES collections (id) ON DELETE CASCADE
      , PRIMARY KEY (parent_id,child_id)
      , CONSTRAINT no_self_reference CHECK (parent_id <> child_id)
      );
      
      CREATE UNIQUE INDEX collections_parent_child_joins_invidx ON collections_parent_child_joins (child_id,parent_id);
    SQL

  end


  def down
    drop_table :collections_parent_child_joins
  end
end
