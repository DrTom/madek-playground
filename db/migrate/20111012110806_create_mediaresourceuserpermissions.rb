class CreateMediaresourceuserpermissions < ActiveRecord::Migration
  def up 

    create_table :mediaresourceuserpermissions do |t|

      t.references :mediaresource, :null => false
      t.references :user, :null => false

      t.boolean :may_view, :default => false
      t.boolean :maynot_view, :default => false

      t.boolean :may_download, :default => false # same as high-res
      t.boolean :maynot_download, :default => false

      t.boolean :may_edit_metadata, :default => false 
      t.boolean :maynot_edit_metadata, :default => false

      t.timestamps
    end

    # TODO check how queries use the indexes, we might want something like (user_id,view)
    # i.e. give me all mediaresources that user X can view!

    # TODO we probably don't need IDX (user_id, mediaresource_id) since the UNIQUE const. should
    # create that anyways

    # TODO we probably don´t need both of IDX (user_id,mediaresource_id) and vice versa

    execute <<-SQL

      ALTER TABLE mediaresourceuserpermissions ADD CONSTRAINT mediaresourceuserpermissions_mediaresources_id_fkey 
        FOREIGN KEY (mediaresource_id) REFERENCES mediaresources (id) ON DELETE CASCADE; 

      ALTER TABLE mediaresourceuserpermissions ADD CONSTRAINT mediaresourceuserpermissions_user_id_fkey 
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

      ALTER TABLE mediaresourceuserpermissions ADD CONSTRAINT mediaresourceuserpermissions_user_id_mediaresource_id_unique 
        UNIQUE (user_id, mediaresource_id);

      CREATE INDEX mediaresourceuserpermissions_may_view_idx ON mediaresourceuserpermissions (may_view);
      CREATE INDEX mediaresourceuserpermissions_maynot_view_idx ON mediaresourceuserpermissions (maynot_view);

      -- TODO check if we really don't need any of:
      -- CREATE INDEX mediaresourceuserpermissions_mediaresources_id_user_id_view_idx on mediaresourceuserpermissions (view);
      -- CREATE INDEX mediaresourceuserpermissions_not_view_idx on mediaresourceuserpermissions (not_view);
      -- CREATE INDEX mediaresourceuserpermissions_download_idx on mediaresourceuserpermissions (download);
      -- CREATE INDEX mediaresourceuserpermissions_not_download_idx on mediaresourceuserpermissions (not_download);
      -- CREATE INDEX mediaresourceuserpermissions_edit_idx on mediaresourceuserpermissions (edit);
      -- CREATE INDEX mediaresourceuserpermissions_not_edit_idx on mediaresourceuserpermissions (not_edit);

      CREATE INDEX mediaresourceuserpermissions_mediaresource_id_user_id_idx on mediaresourceuserpermissions (mediaresource_id, user_id);
      CREATE INDEX mediaresourceuserpermissions_user_id_mediaresource_id_idx on mediaresourceuserpermissions (user_id, mediaresource_id);

    SQL

  end


  def down
    drop_table :mediaresourceuserpermissions
  end

end
