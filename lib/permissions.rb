
module Permissions

  def self.can_view?(mediaresource, user)

    return true if mediaresource.owner == user

    return true if mediaresource.perm_public_may_view 

    return false if mediaresourceuserpermission_disallows :view, mediaresource, user

    return true if mediaresourceuserpermission_allows :view, mediaresource, user
   
    return true if mediaresourcegrouppermission_allows :view, mediaresource, user

    false
  
  end

  
  def self.mediaresourceuserpermission_disallows what, mediaresource, user 
      (Mediaresourceuserpermission.count_by_sql %Q@ 
        SELECT count(*) from mediaresourceuserpermissions 
          WHERE mediaresource_id=#{mediaresource.id} 
            AND user_id=#{user.id} 
            AND maynot_#{what.to_s} = true; 
       @) > 0
  end

  def self.mediaresourceuserpermission_allows what, mediaresource, user 
      (Mediaresourceuserpermission.count_by_sql %Q@ 
        SELECT count(*) from mediaresourceuserpermissions 
          WHERE mediaresource_id=#{mediaresource.id} 
            AND user_id=#{user.id} 
            AND may_#{what.to_s} = true; 
       @) > 0
  end

  def self.mediaresourcegrouppermission_allows what, mediaresource, user
    (Mediaresourcegrouppermission.count_by_sql %Q@ 
      SELECT count(*) from mediaresourcegrouppermissions, users, usergroups_users 
        WHERE users.id = usergroups_users.user_id 
          AND mediaresourcegrouppermissions.usergroup_id = usergroups_users.usergroup_id
          AND mediaresourcegrouppermissions.mediaresource_id = #{mediaresource.id}
          AND users.id = #{user.id}
          AND may_#{what.to_s} = true
          LIMIT 1; 
      @) > 0
  end


end
