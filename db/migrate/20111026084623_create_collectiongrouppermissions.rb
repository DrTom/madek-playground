class CreateCollectiongrouppermissions < ActiveRecord::Migration
  def up
    create_table :collectiongrouppermissions do |t|

      t.references :collection, :null => false
      t.references :usergroup, :null => false

      t.boolean :may_view_metadata, :default => false
      t.boolean :may_edit_metadata, :default => false 

      t.timestamps
    end


    execute <<-SQL

      ALTER TABLE collectiongrouppermissions ADD CONSTRAINT collectiongrouppermissions_collections_id_fkey 
        FOREIGN KEY (collection_id) REFERENCES collections (id) ON DELETE CASCADE; 

      ALTER TABLE collectiongrouppermissions ADD CONSTRAINT collectiongrouppermissions_usergroup_id_fkey 
        FOREIGN KEY (usergroup_id) REFERENCES usergroups (id) ON DELETE CASCADE; 

      CREATE INDEX collectiongrouppermissions_collection_id_idx on collectiongrouppermissions (collection_id);
      CREATE INDEX collectiongrouppermissions_usergroup_id_idx on collectiongrouppermissions (usergroup_id);

    SQL

  end

  def down
    drop_table :collectiongrouppermissions
  end
end
