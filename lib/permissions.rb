
module Permissions

  def self.can_view?(mediaresource, user)

    return true if mediaresource.perm_public_may_view 

    return false if userpermissionset_disallows :view, mediaresource, user

    return true if userpermissionset_allows :view, mediaresource, user
   
    return true if usergrouppermisionset_allows :view, mediaresource, user

    false
  
  end

  def self.userpermissionset_disallows what, mediaresource, user 
      (Userpermissionset.count_by_sql %Q@ 
        SELECT count(*) from userpermissionsets 
          WHERE mediaresource_id=#{mediaresource.id} 
            AND user_id=#{user.id} 
            AND maynot_#{what.to_s} = true; 
       @) > 0
  end

  def self.userpermissionset_allows what, mediaresource, user 
      (Userpermissionset.count_by_sql %Q@ 
        SELECT count(*) from userpermissionsets 
          WHERE mediaresource_id=#{mediaresource.id} 
            AND user_id=#{user.id} 
            AND may_#{what.to_s} = true; 
       @) > 0
  end

  def self.usergrouppermisionset_allows what, mediaresource, user
    (Usergrouppermisionset.count_by_sql %Q@ 
      SELECT count(*) from usergrouppermisionsets, users, usergroups_users 
        WHERE users.id = usergroups_users.user_id 
          AND usergrouppermisionsets.usergroup_id = usergroups_users.usergroup_id
          AND usergrouppermisionsets.mediaresource_id = #{mediaresource.id}
          AND users.id = #{user.id}
          AND may_#{what.to_s} = true
          LIMIT 1; 
      @) > 0
  end


end
