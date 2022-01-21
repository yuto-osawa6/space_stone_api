class Adduseradmins < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :administrator_gold, :boolean, default: false, null: false
  end
end
