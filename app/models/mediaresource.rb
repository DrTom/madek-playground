class Mediaresource < ActiveRecord::Base
  has_many :mediaresourcegrouppermissions
  has_many :mediaresourceuserpermissions
#  belongs_to :user
  belongs_to :owner, :class_name => 'User'

  def can_view? user
    Permissions.can_view? self, user
  end

  def can_download? user
    :not_a_boolean
  end

  def can_edit? user
    :not_a_boolean
  end

end
