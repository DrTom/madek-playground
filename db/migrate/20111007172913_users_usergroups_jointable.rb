class UsersUsergroupsJointable < ActiveRecord::Migration

  def up
    execute <<-SQL
      CREATE TABLE usergroups_users
      ( usergroup_id integer REFERENCES usergroups (id) ON DELETE CASCADE
      , user_id integer REFERENCES users (id) ON DELETE CASCADE
      , PRIMARY KEY (usergroup_id, user_id)
      ); 
      CREATE INDEX user_usergroup_idx on usergroups_users (user_id, usergroup_id);
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE usergroups_users;
    SQL
  end

end
