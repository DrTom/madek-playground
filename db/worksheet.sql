
SELECT * from usergrouppermisionsets, users, usergroups_users 
  WHERE users.id = usergroups_users.user_id 
    AND usergrouppermisionsets.usergroup_id = usergroups_users.usergroup_id
    AND usergrouppermisionsets.mediaresource_id = 99
    AND users.id = 5
    AND may_view = true;




