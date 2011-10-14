class CreateUsergrouppermisionsets < ActiveRecord::Migration
  def up

    create_table :usergrouppermisionsets do |t|

      # t.references :mediaresource
      # t.references :usergroup

      t.boolean :view, :default => false
      t.boolean :download, :default => false
      t.boolean :edit, :default => false

      t.timestamps
    end

    execute <<-SQL
   
      ALTER TABLE usergrouppermisionsets
        ADD mediaresource_id integer REFERENCES mediaresources (id) ON DELETE CASCADE;

      CREATE INDEX usergrouppermisionsets_mediaresource_id_idx on usergrouppermisionsets (mediaresource_id);

      ALTER TABLE usergrouppermisionsets
        ADD usergroup_id integer REFERENCES usergroups (id) ON DELETE CASCADE;

      CREATE INDEX usergrouppermisionsets_usergroup_id_idx on usergrouppermisionsets (usergroup_id);

    SQL
  end

end
