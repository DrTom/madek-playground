class Usergrouppermisionset < ActiveRecord::Base
  belongs_to :usergroup
  belongs_to :mediaresource
end
