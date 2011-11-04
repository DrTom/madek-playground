class ViewableMediaresourcesUsersJoinview < ActiveRecord::Migration
  def up
    execute <<-SQL

CREATE VIEW viewable_mediaresources_by_userpermission AS
  SELECT mr.id as mr_id, users.id as u_id
    FROM mediaresources mr 
    INNER JOIN mediaresourceuserpermissions mrup ON mr.id = mrup.mediaresource_id
    INNER JOIN users ON mrup.user_id = users.id
    WHERE mrup.may_view = true;

CREATE VIEW viewable_mediaresources_by_grouppermissions AS
  SELECT mr.id as mr_id, users.id as u_id
    FROM mediaresources mr
    INNER JOIN mediaresourcegrouppermissions mrgp ON mr.id = mrgp.mediaresource_id
    INNER JOIN usergroups ug ON ug.id = mrgp.usergroup_id
    INNER JOIN usergroups_users ON usergroups_users.usergroup_id = mrgp.usergroup_id
    INNER JOIN users ON usergroups_users.user_id = users.id
    WHERE mrgp.may_view = true;

CREATE VIEW nonviewable_mediaresources_by_userpermission AS
  SELECT mr.id as mr_id, users.id as u_id
    FROM mediaresources mr 
    INNER JOIN mediaresourceuserpermissions mrup ON mr.id = mrup.mediaresource_id
    INNER JOIN users ON mrup.user_id = users.id
    WHERE mrup.maynot_view = true;

CREATE VIEW viewable_mediaresources_by_gp_without_denied_by_up AS
  SELECT * from viewable_mediaresources_by_grouppermissions
  EXCEPT SELECT * from nonviewable_mediaresources_by_userpermission ;

CREATE VIEW viewable_mediaresources_by_publicpermission AS
  SELECT mr.id as md_id, users.id as user_id  FROM mediaresources mr
    CROSS JOIN users 
    WHERE mr.perm_public_may_view = true;

CREATE VIEW viewable_mediaresources_by_ownwership AS
  SELECT id as mr_id, owner_id as u_id from  mediaresources;

CREATE VIEW viewable_mediaresources_users AS
  SELECT * FROM  viewable_mediaresources_by_userpermission
   UNION SELECT * from viewable_mediaresources_by_gp_without_denied_by_up
   UNION SELECT * from viewable_mediaresources_by_publicpermission
   UNION SELECT * from viewable_mediaresources_by_ownwership;

    SQL
  end

  def down
    execute <<-SQL

DROP VIEW viewable_mediaresources_by_userpermission;
DROP VIEW viewable_mediaresources_by_grouppermissions;
DROP VIEW nonviewable_mediaresources_by_userpermission;
DROP VIEW viewable_mediaresources_by_gp_without_denied_by_up;
DROP VIEW viewable_mediaresources_by_publicpermission;
DROP VIEW viewable_mediaresources_users;
  
    SQL
  end
end
