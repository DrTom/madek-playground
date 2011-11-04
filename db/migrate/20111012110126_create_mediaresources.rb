class CreateMediaresources < ActiveRecord::Migration
  def up
    create_table :mediaresources do |t|

      t.string :name

      t.integer :owner_id, :null => false

      t.boolean :perm_public_may_view, :default => false
      t.boolean :perm_public_may_download, :default => false

      t.timestamps
    end

    execute <<-SQL

      ALTER TABLE mediaresources ADD CONSTRAINT mediaresource_owner_id_fkey 
        FOREIGN KEY (owner_id) REFERENCES users (id); 

      CREATE INDEX mediaresources_perm_public_may_view_idx ON mediaresources (perm_public_may_view);
      CREATE INDEX mediaresources_owner_id_idx ON mediaresources (owner_id);

    SQL

  end

  def down
    drop_table :mediaresources
  end

end
