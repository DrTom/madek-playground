class Collection < ActiveRecord::Base

  belongs_to :owner, :class_name => 'User'

  has_and_belongs_to_many :mediaresources

  has_and_belongs_to_many :children, :class_name => "Collection", :join_table => 'collections_parent_child_joins', :foreign_key => 'parent_id', :association_foreign_key => 'child_id'
  has_and_belongs_to_many :parents, :class_name => "Collection", :join_table => 'collections_parent_child_joins', :foreign_key => 'child_id', :association_foreign_key => 'parent_id'

  has_many :collectionuserpermissions
  has_many :usergroups

  def contains_mediaresource? mediaresource
    res = ActiveRecord::Base.connection.execute "SELECT * from collections_mediaresources WHERE collection_id = #{id} AND mediaresource_id = #{mediaresource.id} LIMIT 1"
    res.values.empty? ? false : true
  end


end
