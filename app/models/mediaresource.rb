class Mediaresource < ActiveRecord::Base
  has_many :usergrouppermisionsets
  has_many :userpermissionsets

  def can_view? user
    :not_a_boolean
  end

  def can_download? user
    :not_a_boolean
  end

  def can_edit? user
    :not_a_boolean
  end

end
