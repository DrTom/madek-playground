class GroupsPeopleJointable < ActiveRecord::Migration

  def up
    execute <<-SQL
      CREATE TABLE groups_people 
      ( group_id integer REFERENCES groups (id) ON DELETE CASCADE
      , person_id integer REFERENCES people (id) ON DELETE CASCADE
      , PRIMARY KEY (group_id, person_id)
      ); 
      -- CREATE INDEX groups_people__idx on groups_people (group_id, person_id);
      CREATE INDEX people_groups_idx on groups_people (person_id, group_id);
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE groups_people;
    SQL
  end

end
