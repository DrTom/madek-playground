class Userpermissionset < ActiveRecord::Base
  belongs_to :user
  belongs_to :mediaresource
end
