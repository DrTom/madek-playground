class CollectionMediresourceJointable < ActiveRecord::Migration
  def up
    execute <<-SQL

      CREATE TABLE collections_mediaresources
      ( collection_id integer NOT NULL REFERENCES collections (id) ON DELETE CASCADE
      , mediaresource_id integer NOT NULL REFERENCES mediaresources (id) ON DELETE CASCADE
      );

      CREATE INDEX mediaresources_collections_idx on collections_mediaresources (mediaresource_id, collection_id);

    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE collections_mediaresources;
    SQL
  end
end
