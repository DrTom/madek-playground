class Usergroup < ActiveRecord::Base
  has_and_belongs_to_many :users

  def contains_user? user 
    res = ActiveRecord::Base.connection.execute "SELECT count(*) from usergroups_users WHERE usergroup_id = #{id} AND user_id = #{user.id}"
    res.values.flatten.first.to_i == 0 ? false : true
  end

end
