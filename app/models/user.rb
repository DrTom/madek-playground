class User < ActiveRecord::Base

  has_and_belongs_to_many :usergroups
  has_and_belongs_to_many :viewable_mediaresources, 
    :class_name => "Mediaresource", :join_table => 'viewable_mediaresources_users', :foreign_key => 'u_id', :association_foreign_key => 'mr_id',
    :delete_sql => "" # otherwise rails will try to delete rows in the view

  has_many :collectionuserpermissions
  has_many :mediaresourceuserpermissions

  has_one :collection
  has_one :mediaresource

end
