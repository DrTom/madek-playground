class User < ActiveRecord::Base
  has_and_belongs_to_many :usergroups
  has_many :userpermissionsets
end
