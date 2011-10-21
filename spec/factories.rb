
module FactoryHelper

  def self.rand_bool *opts
    bias = ((opts and opts[0]) or 0.5)
    raise "bias must be a real number within [0,1)" if bias < 0.0 or bias >= 1.0
    (rand < bias) ? true : false
  end

end

FactoryGirl.define do

  factory :user do
    firstname {Faker::Name.first_name}
    lastname {Faker::Name.last_name}
    email {"#{firstname}.#{lastname}@example.com".downcase} 
    login {"#{firstname}_#{lastname}".downcase} 
  end

  factory :usergroup do
    name {"group-" + Faker::Internet.domain_word}
  end

  factory :mediaresource do
    name {Faker::Name.last_name}
    owner {User.find_random || (FactoryGirl.create :user)}
    perm_public_may_view {FactoryHelper.rand_bool 0.1}
    perm_public_may_download {FactoryHelper.rand_bool 0.1}
  end

  # ensure constraints by providing user and mediaresource explicitly
  factory :mediaresourceuserpermission do
    may_view {FactoryHelper.rand_bool 1/4.0}
    maynot_view {(not may_view) and FactoryHelper.rand_bool}
    may_download {FactoryHelper.rand_bool 1/4.0}
    maynot_download {(not may_download) and FactoryHelper.rand_bool}
    may_edit_metadata {FactoryHelper.rand_bool 1/4.0}
    maynot_edit_metadata {(not may_edit_metadata) and FactoryHelper.rand_bool}

    user {User.find_random || (FactoryGirl.create :user)}
    mediaresource {Mediaresource.find_random || (FactoryGirl.create :mediaresource)}
  end

  # ensure constraints by providing usergroups and mediaresource explicitly
  factory :mediaresourcegrouppermission do
    may_view {FactoryHelper.rand_bool}
    may_download {FactoryHelper.rand_bool}
    may_edit_metadata {FactoryHelper.rand_bool}

    usergroup {Usergroup.find_random}
    mediaresource {Mediaresource.find_random}
  end
   
end



class DatasetFactory

  DEF_NUM_USERS = 10
  MIN_NUM_USERS = 4
  MIN_NUM_GOUPS = 3

  def self.recreate *args
    clear
    create *args
  end

  def self.clear
    exec_sql "DELETE FROM mediaresources;"
    exec_sql "DELETE FROM users;"
    exec_sql "DELETE FROM usergroups;"
    
    # we don't need these anymore, at least with Postgres
    # exec_sql "DELETE FROM mediaresourceuserpermissions;"
    # exec_sql "DELETE FROM mediaresourcegrouppermissions;"
  end


  def self.create *args

    hash_args = ((args and args[0]) or {})

    num_users = [(hash_args[:num_users] or DEF_NUM_USERS), MIN_NUM_USERS].max
    num_groups =[(hash_args[:num_groups] or num_users/100), MIN_NUM_GOUPS].max
    num_mediaresources =  (hash_args[:num_mediaresources] or num_users*10)
    num_mediaresourceuserpermissions = (hash_args[:num_mediaresourceuserpermissions] or num_mediaresources * 5)
    num_usergrouppermissionsets = (hash_args[:num_usergrouppermissionsets] or num_mediaresources * 3)

    # binding.pry

    if num_mediaresourceuserpermissions > num_users * num_mediaresources
      raise "You are trying to create more mediaresourceuserpermissions #{num_mediaresourceuserpermissions} than possible (#{num_users} * #{num_mediaresources})." 
    end

    if num_usergrouppermissionsets > num_groups * num_mediaresources
      raise "You are trying to create more mediaresourcegrouppermissions #{num_usergrouppermissionsets} than possible (#{num_groups} * #{num_mediaresources})." 
    end



    (1..num_users).each{FactoryGirl.create :user}  
    (1..num_groups).each{FactoryGirl.create :usergroup}

    (1..num_groups).each do |i|

      group = Usergroup.find_nth i-1
      target_group_size =  [ [num_users/(2**i), 3].max, num_users/2 ].min

      while group.users.count < target_group_size
        u = User.find_random
        group.users << u unless group.contains_user? u
      end

    end

    (1..num_mediaresources).each{FactoryGirl.create :mediaresource}

    (1..num_mediaresourceuserpermissions).each{create_mediaresourceuserpermission}

    (1..num_usergrouppermissionsets).each{create_mediaresourcegrouppermission}

  end


  # calls itself recursively when fails; 
  #   stack-overflow ist not a bug but a feature! 
  #   see the factory definition
  def self.create_mediaresourceuserpermission
    begin
      FactoryGirl.create :mediaresourceuserpermission
    rescue
      create_mediaresourceuserpermission
    end
  end

  # calls itself recursively when fails; 
  #   stack-overflow ist not a bug but a feature! 
  #   see the factory definition
  def self.create_mediaresourcegrouppermission
    begin
      FactoryGirl.create :mediaresourcegrouppermission
    rescue
      create_mediaresourcegrouppermission
    end
  end


  def self.exec_sql sql_statement
     ActiveRecord::Base.connection.execute sql_statement
  end

end
