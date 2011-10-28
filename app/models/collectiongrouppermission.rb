class Collectiongrouppermission < ActiveRecord::Base
  belongs_to :usergroup
  belongs_to :collection
end
