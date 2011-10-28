class CreateCollectionuserpermissions < ActiveRecord::Migration
  def up 
    create_table :collectionuserpermissions do |t|

      t.references :collection, :null => false
      t.references :user, :null => false

      t.boolean :may_view_metadata, :default => false
      t.boolean :maynot_view_metadata, :default => false

      t.boolean :may_edit_metadata, :default => false 
      t.boolean :maynot_edit_metadata, :default => false

      t.timestamps
    end


    execute <<-SQL


      ALTER TABLE collectionuserpermissions ADD CONSTRAINT collectionuserpermissions_collections_id_fkey 
        FOREIGN KEY (collection_id) REFERENCES collections (id) ON DELETE CASCADE; 

      ALTER TABLE collectionuserpermissions ADD CONSTRAINT collectionuserpermissions_user_id_fkey 
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

      ALTER TABLE collectionuserpermissions ADD CONSTRAINT collectionuserpermissions_user_id_collection_id_unique 
        UNIQUE (user_id, collection_id);

      CREATE INDEX collectionuserpermissions_collection_id_user_id_idx on collectionuserpermissions (collection_id, user_id);
      CREATE INDEX collectionuserpermissions_user_id_collection_id_idx on collectionuserpermissions (user_id, collection_id);

    SQL

  end

  def down
    drop_table :collectionuserpermissions
  end

end
