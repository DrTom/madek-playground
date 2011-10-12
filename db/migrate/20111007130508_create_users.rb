class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :firstname
      t.string :lastname

      t.string :login, :limit => 40
      t.string :email, :limit => 100
      t.datetime :usage_terms_accepted_at

#      # user related stuff
#      # t.boolean :is_user, :default => false
#
#      # author related stuff
#      t.boolean :is_author, :default => false
#      t.string  :pseudonym
#      t.date    :day_of_birth
#      t.date    :day_of_death
#      t.string  :nationality
#      t.text    :wiki_links
#
      t.timestamps
    end
  end
end
