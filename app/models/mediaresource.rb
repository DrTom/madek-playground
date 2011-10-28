class Mediaresource < ActiveRecord::Base
  has_and_belongs_to_many :collections
  has_many :mediaresourcegrouppermissions
  has_many :mediaresourceuserpermissions

  belongs_to :owner, :class_name => 'User'

  def self.find_some
    find_by_sql "select mrrow();" 
  end

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
