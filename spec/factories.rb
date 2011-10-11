
require 'pry' 

FactoryGirl.define do

  factory :user, :class => Person do
    firstname {Faker::Name.first_name}
    lastname {Faker::Name.last_name}
    is_user true
    email {"#{firstname}.#{lastname}@example.com".downcase} 
    login {"#{firstname}_#{lastname}".downcase} 
  end

  factory :group do
    name {"group-" + Faker::Internet.domain_word}
  end
   
end

class DatasetFactory

  DEF_NUM_PEOPLE = 100
  MIN_NUM_PEOPLE = 10
  MIN_NUM_GOUPS = 3


  def self.clear
    exec_sql "DELETE FROM people;"
    exec_sql "DELETE FROM groups;"
  end


  def self.create *args

    hash_args = ((args and args[0]) or {})

    num_people = [ (hash_args[:num_people] or DEF_NUM_PEOPLE), MIN_NUM_PEOPLE].max
    num_groups = [ (hash_args[:num_groups] or num_people/100), MIN_NUM_GOUPS].max

    #binding.pry

    (1..num_people).each{FactoryGirl.create :user}  
    (1..num_groups).each{FactoryGirl.create :group}

    (1..num_groups).each do |i|

      group = Group.find_nth i-1
      target_group_size =  [ [num_people/(2**i), 3].max, num_people/2 ].min
      added = 0 

      while group.people.count < target_group_size
        p = Person.find_random
        group.people << p unless group.contains_person? p
      end

    end
  end


  def self.exec_sql sql_statement
     ActiveRecord::Base.connection.execute sql_statement
  end

end
