class CreateMediaresources < ActiveRecord::Migration
  def change
    create_table :mediaresources do |t|

      t.string :name

      t.boolean :perm_public_view, :default => false
      t.boolean :perm_public_download, :default => false

      t.timestamps
    end
  end
end
