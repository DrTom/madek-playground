
require 'pry' 

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
   
end

class DatasetFactory

  DEF_NUM_PEOPLE = 100
  MIN_NUM_PEOPLE = 10
  MIN_NUM_GOUPS = 3


  def self.clear
    exec_sql "DELETE FROM users;"
    exec_sql "DELETE FROM usergroups;"
  end


  def self.create *args

    hash_args = ((args and args[0]) or {})

    num_people = [ (hash_args[:num_people] or DEF_NUM_PEOPLE), MIN_NUM_PEOPLE].max
    num_groups = [ (hash_args[:num_groups] or num_people/100), MIN_NUM_GOUPS].max


    (1..num_people).each{FactoryGirl.create :user}  
    (1..num_groups).each{FactoryGirl.create :usergroup}

    (1..num_groups).each do |i|


      group = Usergroup.find_nth i-1
      target_group_size =  [ [num_people/(2**i), 3].max, num_people/2 ].min

      #binding.pry

      while group.users.count < target_group_size
        u = User.find_random
        group.users << u unless group.contains_user? u
      end

    end
  end


  def self.exec_sql sql_statement
     ActiveRecord::Base.connection.execute sql_statement
  end

end
