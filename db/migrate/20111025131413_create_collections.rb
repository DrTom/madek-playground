class CreateCollections < ActiveRecord::Migration
  def up
    create_table :collections do |t|
      t.string :name
      t.integer :owner_id, :null => false

      t.boolean :perm_public_may_view_metadata, :default => false

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE collections ADD CONSTRAINT collection_owner_id_fkey 
        FOREIGN KEY (owner_id) REFERENCES users (id); 
    SQL

  end

  def down
    drop_table :collections
  end

end
