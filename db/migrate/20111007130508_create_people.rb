class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|

      t.string :firstname
      t.string :lastname

      # user related stuff
      t.boolean :is_user, :default => false
      t.string :login, :limit => 40
      t.string :email, :limit => 100
      t.datetime :usage_terms_accepted_at

      # author related stuff
      t.boolean :is_author, :default => false
      t.string  :pseudonym
      t.date    :birthdate
      t.date    :deathdate
      t.string  :nationality
      t.text    :wiki_links

      t.timestamps
    end
  end
end
