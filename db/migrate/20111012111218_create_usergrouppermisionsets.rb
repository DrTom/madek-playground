class CreateUsergrouppermisionsets < ActiveRecord::Migration
  def up

    create_table :usergrouppermisionsets do |t|

      t.references :mediaresource
      t.references :usergroup

      t.boolean :may_view, :default => false
      t.boolean :may_download, :default => false # high-res
      t.boolean :may_edit_metadata, :default => false 

      t.timestamps
    end

    execute <<-SQL
   
      ALTER TABLE usergrouppermisionsets ADD CONSTRAINT usergrouppermisionsets_mediaresources_id_fkey 
        FOREIGN KEY (mediaresource_id) REFERENCES mediaresources (id) ON DELETE CASCADE; 

      ALTER TABLE usergrouppermisionsets ADD CONSTRAINT usergrouppermisionsets_usergroup_id_fkey 
        FOREIGN KEY (usergroup_id) REFERENCES usergroups (id) ON DELETE CASCADE; 

      CREATE INDEX usergrouppermisionsets_mediaresource_id_idx on usergrouppermisionsets (mediaresource_id);
      CREATE INDEX usergrouppermisionsets_usergroup_id_idx on usergrouppermisionsets (usergroup_id);

    SQL
  end

  def down
    drop_table :usergrouppermisionsets
  end

end
