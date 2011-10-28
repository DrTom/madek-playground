class User < ActiveRecord::Base
  has_and_belongs_to_many :usergroups
  has_many :collectionuserpermissions
  has_many :mediaresourceuserpermissions
  has_one :collection
  has_one :mediaresource
end
