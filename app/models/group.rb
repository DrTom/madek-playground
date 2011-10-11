class Group < ActiveRecord::Base
  has_and_belongs_to_many :people

  def contains_person? person
    res = ActiveRecord::Base.connection.execute "SELECT count(*) from groups_people WHERE group_id = #{id} AND person_id = #{person.id}"
    res.values.flatten.first.to_i == 0 ? false : true
  end

end
