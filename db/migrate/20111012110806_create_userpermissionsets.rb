class CreateUserpermissionsets < ActiveRecord::Migration
  def up 

    create_table :userpermissionsets do |t|

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

      ALTER TABLE userpermissionsets ADD CONSTRAINT userpermissionsets_mediaresources_id_fkey 
        FOREIGN KEY (mediaresource_id) REFERENCES mediaresources (id) ON DELETE CASCADE; 

      ALTER TABLE userpermissionsets ADD CONSTRAINT userpermissionsets_user_id_fkey 
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

      ALTER TABLE userpermissionsets ADD CONSTRAINT userpermissionsets_user_id_mediaresource_id_unique 
        UNIQUE (user_id, mediaresource_id);

      -- TODO check if we really don't need any of:
      -- CREATE INDEX userpermissionsets_mediaresources_id_user_id_view_idx on userpermissionsets (view);
      -- CREATE INDEX userpermissionsets_not_view_idx on userpermissionsets (not_view);
      -- CREATE INDEX userpermissionsets_download_idx on userpermissionsets (download);
      -- CREATE INDEX userpermissionsets_not_download_idx on userpermissionsets (not_download);
      -- CREATE INDEX userpermissionsets_edit_idx on userpermissionsets (edit);
      -- CREATE INDEX userpermissionsets_not_edit_idx on userpermissionsets (not_edit);

      CREATE INDEX userpermissionsets_mediaresource_id_user_id_idx on userpermissionsets (mediaresource_id, user_id);
      CREATE INDEX userpermissionsets_user_id_mediaresource_id_idx on userpermissionsets (user_id, mediaresource_id);

    SQL

  end


  def down
    drop_table :userpermissionsets
  end

end
