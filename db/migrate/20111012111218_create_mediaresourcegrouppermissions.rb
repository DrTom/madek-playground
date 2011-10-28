class CreateMediaresourcegrouppermissions < ActiveRecord::Migration
  def up

    create_table :mediaresourcegrouppermissions do |t|

      t.references :mediaresource, :null => false
      t.references :usergroup, :null => false

      t.boolean :may_view, :default => false
      t.boolean :may_download, :default => false # high-res
      t.boolean :may_edit_metadata, :default => false 

      t.timestamps
    end

    execute <<-SQL

      ALTER TABLE mediaresourcegrouppermissions ADD CONSTRAINT mediaresourcegrouppermissions_mediaresources_id_fkey 
        FOREIGN KEY (mediaresource_id) REFERENCES mediaresources (id) ON DELETE CASCADE; 

      ALTER TABLE mediaresourcegrouppermissions ADD CONSTRAINT mediaresourcegrouppermissions_usergroup_id_fkey 
        FOREIGN KEY (usergroup_id) REFERENCES usergroups (id) ON DELETE CASCADE; 

      CREATE INDEX mediaresourcegrouppermissions_mediaresource_id_idx on mediaresourcegrouppermissions (mediaresource_id);
      CREATE INDEX mediaresourcegrouppermissions_usergroup_id_idx on mediaresourcegrouppermissions (usergroup_id);

    SQL
  end

  def down
    drop_table :mediaresourcegrouppermissions
  end

end
