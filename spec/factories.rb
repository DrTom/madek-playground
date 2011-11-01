
module FactoryHelper

  def self.count_by_sql query
    res = ActiveRecord::Base.connection.execute query 
    res.values.flatten.first.to_i 
  end

  def self.rand_bool *opts
    bias = ((opts and opts[0]) or 0.5)
    raise "bias must be a real number within [0,1)" if bias < 0.0 or bias >= 1.0
    (rand < bias) ? true : false
  end

  def self.execute_sql query
    ActiveRecord::Base.connection.execute query 
  end

end

FactoryGirl.define do

  factory :collection do
    name {Faker::Name.last_name}
    owner {User.find_random || (FactoryGirl.create :user)}
    perm_public_may_view_metadata {FactoryHelper.rand_bool 0.1}
  end

  factory :collectionuserpermission do
    may_view_metadata {FactoryHelper.rand_bool 1/4.0}
    maynot_view_metadata {(not may_view_metadata) and FactoryHelper.rand_bool}
    may_edit_metadata {FactoryHelper.rand_bool 1/4.0}
    maynot_edit_metadata {(not may_edit_metadata) and FactoryHelper.rand_bool}

    user {User.find_random || (FactoryGirl.create :user)}
    collection {Collection.find_random || (FactoryGirl.create :collection)}
  end


  factory :collectiongrouppermission do
    may_view_metadata {FactoryHelper.rand_bool 1/4.0}
    may_edit_metadata {FactoryHelper.rand_bool 1/4.0}

    usergroup {Usergroup.find_random || (FactoryGirl.create :usergroup)}
    collection {Collection.find_random || (FactoryGirl.create :collection)}
  end


  factory :mediaresource do
    name {Faker::Name.last_name}
    owner {User.find_random || (FactoryGirl.create :user)}
    perm_public_may_view {FactoryHelper.rand_bool 0.1}
    perm_public_may_download {FactoryHelper.rand_bool 0.1}
  end

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

  factory :mediaresourcegrouppermission do
    may_view {FactoryHelper.rand_bool}
    may_download {FactoryHelper.rand_bool}
    may_edit_metadata {FactoryHelper.rand_bool}

    usergroup {Usergroup.find_random || (FactoryGirl.create :usergroup)}
    mediaresource {Mediaresource.find_random || (FactoryGirl.create :mediaresource)}
  end
   
  factory :user do
    firstname {Faker::Name.first_name}
    lastname {Faker::Name.last_name}
    email {"#{firstname}.#{lastname}@example.com".downcase} 
    login {"#{firstname}_#{lastname}".downcase} 
  end

  factory :usergroup do
    name {"group-" + Faker::Internet.domain_word}
  end

end



module DatasetFactory

  DEF_NUM_USERS = 10
  MIN_NUM_USERS = 4
  MIN_NUM_GOUPS = 3

  def self.recreate *args
    clear
    create *args
  end

  def self.clear
    exec_sql "DELETE FROM mediaresources;"
    exec_sql "DELETE FROM collections;"
    exec_sql "DELETE FROM users;"
    exec_sql "DELETE FROM usergroups;"
    
    # we don't need these anymore, at least with Postgres
    # exec_sql "DELETE FROM mediaresourceuserpermissions;"
    # exec_sql "DELETE FROM mediaresourcegrouppermissions;"
  end


 
  module Collection_DAG

    def self.create_square depth
      prevrow = []
      thisrow = []
      (1..depth).each do |i|
        (1..depth).each do |j|
          node = FactoryGirl.create :collection, :name => "#{i}_#{j}"
          prevrow.each do |dec| 
            dec.children << node
          end
          thisrow.each do |dec|
            dec.children << node
          end
          thisrow << node
        end
        prevrow = thisrow
        thisrow = []
      end
      
    end
  end




  def self.create *args

    hash_args = ((args and args[0]) or {})

    puts num_users = [(hash_args[:num_users] or DEF_NUM_USERS), MIN_NUM_USERS].max
    puts num_groups =[(hash_args[:num_groups] or num_users/100), MIN_NUM_GOUPS].max

    puts num_mediaresources =  (hash_args[:num_mediaresources] or num_users*10)
    #puts max_mediaresourceuserpermissions = num_users * num_mediaresources
    puts num_mediaresourceuserpermissions = (hash_args[:num_mediaresourceuserpermissions] or num_mediaresources * 5)
    #puts max_usergrouppermissionsets = num_groups * num_mediaresources
    puts num_usergrouppermissionsets = (hash_args[:num_usergrouppermissionsets] or num_mediaresources * 3)

    puts num_collections = [(hash_args[:num_collections] or num_mediaresources/1000).floor,10].max
    puts num_collectionuserpermissions = (hash_args[:num_collectionuserpermissions] or num_collections * 5)
    puts num_collectiongroupppermissionsets = (hash_args[:num_collectiongroupppermissionsets] or num_collections * 3)


    # binding.pry

    if num_mediaresourceuserpermissions > num_users * num_mediaresources
      raise "You are trying to create more mediaresourceuserpermissions #{num_mediaresourceuserpermissions} than possible (#{num_users} * #{num_mediaresources})." 
    end

    if num_usergrouppermissionsets > num_groups * num_mediaresources
      raise "You are trying to create more mediaresourcegrouppermissions #{num_usergrouppermissionsets} than possible (#{num_groups} * #{num_mediaresources})." 
    end



    start_time = Time.now
    (1..num_users).each{FactoryGirl.create :user}  
    puts "done creating #{User.count} users in #{(Time.now - start_time)} seconds"

    start_time = Time.now
    (1..num_groups).each{FactoryGirl.create :usergroup}
    puts "done creating #{Usergroup.count} groups in #{(Time.now - start_time)} seconds"


    start_time = Time.now
    (1..num_groups).each do |i|

      group = Usergroup.find_nth i-1
      target_group_size =  [ [num_users/(2**i), 3].max, num_users/2 ].min

      while group.users.count < target_group_size
        u = User.find_random
        group.users << u unless group.contains_user? u
      end
    end
    puts "done adding #{FactoryHelper.count_by_sql %Q@ SELECT count(*) from usergroups_users@} usergroups_users relations in #{(Time.now - start_time)} seconds"


    ### Mediaresouce
     
    start_time = Time.now
    (1..num_mediaresources).each{FactoryGirl.create :mediaresource}
    puts "done creating #{Mediaresource.count} Mediaresources in #{(Time.now - start_time)} seconds"

    start_time = Time.now
    (1..num_mediaresourceuserpermissions).each{create_mediaresourceuserpermission}
    puts "done creating #{Mediaresourceuserpermission.count} mediaresourceuserpermissions in #{(Time.now - start_time)} seconds"

    start_time = Time.now
    (1..num_usergrouppermissionsets).each{create_mediaresourcegrouppermission}
    puts "done creating #{Mediaresourcegrouppermission.count} mediaresourcegrouppermissions in #{(Time.now - start_time)} seconds"

    ### Collection
     
    start_time = Time.now
    (1..num_collections).each{FactoryGirl.create :collection}
    puts "done creating #{Collection.count} Collections in #{(Time.now - start_time)} seconds"

    start_time = Time.now
    (1..num_collectionuserpermissions).each{create_collectionuserpermission}
    puts "done creating #{Collectionuserpermission.count} Collectionuserpermissions in #{(Time.now - start_time)} seconds"

    start_time = Time.now
    (1..num_usergrouppermissionsets).each{create_collectiongrouppermission}
    puts "done creating #{Mediaresourcegrouppermission.count} Collectionuserpermissions in #{(Time.now - start_time)} seconds"


    ### Collections-Mediaresources

    start_time = Time.now
    (1..Collection.count).each do |i|

      collection = Collection.find_nth i-1
      target_collection_size =  [Mediaresource.count/(2**i), 3].max

      (1..target_collection_size).each do
        mr = Mediaresource.find_random
        collection.mediaresources << mr unless collection.contains_mediaresource? mr
      end

    end
    puts "done adding #{FactoryHelper.count_by_sql %Q@ SELECT count(*) from collections_mediaresources@} collections_mediaresources in #{(Time.now - start_time)} seconds"

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


  def self.create_collectionuserpermission
    begin
      FactoryGirl.create :collectionuserpermission
    rescue
      create_collectionuserpermission
    end
  end

  def self.create_collectiongrouppermission
    begin
      FactoryGirl.create :collectiongrouppermission
    rescue
      create_collectiongrouppermission
    end
  end



  def self.exec_sql sql_statement
     ActiveRecord::Base.connection.execute sql_statement
  end



end
