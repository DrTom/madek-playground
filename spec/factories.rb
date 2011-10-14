
def rbool  
  0 == (rand 2)
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

    perm_public_may_view {rbool}
    perm_public_may_download {rbool}
  end

  # ensure constraints by providing user and mediaresource explicitly
  factory :userpermissionset do
    may_view {rbool}
    maynot_view {(not may_view) and rbool}
    may_download {rbool}
    maynot_download {(not may_download) and rbool}
    may_edit_metadata {rbool}
    maynot_edit_metadata {(not may_edit_metadata) and rbool}

    user {User.find_random}
    mediaresource {Mediaresource.find_random}
  end

  # ensure constraints by providing usergroups and mediaresource explicitly
  factory :usergrouppermisionset do
    may_view {rbool}
    may_download {rbool}
    may_edit_metadata {rbool}

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
    exec_sql "DELETE FROM users;"
    exec_sql "DELETE FROM usergroups;"
    exec_sql "DELETE FROM mediaresources;"
    
    # we don't need these anymore, at least with Postgres
    # exec_sql "DELETE FROM userpermissionsets;"
    # exec_sql "DELETE FROM usergrouppermisionsets;"
  end


  def self.create *args

    hash_args = ((args and args[0]) or {})

    num_users = [(hash_args[:num_users] or DEF_NUM_USERS), MIN_NUM_USERS].max
    num_groups =[(hash_args[:num_groups] or num_users/100), MIN_NUM_GOUPS].max
    num_mediaresources =  (hash_args[:num_mediaresources] or num_users*10)
    num_userpermissionsets = (hash_args[:num_userpermissionsets] or num_mediaresources * 5)
    num_usergrouppermissionsets = (hash_args[:num_usergrouppermissionsets] or num_mediaresources * 3)

    # binding.pry

    if num_userpermissionsets > num_users * num_mediaresources
      raise "You are trying to create more userpermissionsets #{num_userpermissionsets} than possible (#{num_users} * #{num_mediaresources})." 
    end

    if num_usergrouppermissionsets > num_groups * num_mediaresources
      raise "You are trying to create more usergrouppermisionsets #{num_usergrouppermissionsets} than possible (#{num_groups} * #{num_mediaresources})." 
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

    (1..num_userpermissionsets).each{create_userpermisionset}

    (1..num_usergrouppermissionsets).each{create_usergrouppermisionset}

  end


  # calls itself recursively when fails; 
  #   stack-overflow ist not a bug but a feature! 
  #   see the factory definition
  def self.create_userpermisionset
    begin
      FactoryGirl.create :userpermissionset
    rescue
      create_userpermisionset
    end
  end

  # calls itself recursively when fails; 
  #   stack-overflow ist not a bug but a feature! 
  #   see the factory definition
  def self.create_usergrouppermisionset
    begin
      FactoryGirl.create :usergrouppermisionset
    rescue
      create_usergrouppermisionset
    end
  end


  def self.exec_sql sql_statement
     ActiveRecord::Base.connection.execute sql_statement
  end

end
