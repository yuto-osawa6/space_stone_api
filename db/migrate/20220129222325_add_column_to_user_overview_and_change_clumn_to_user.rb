class AddColumnToUserOverviewAndChangeClumnToUser < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :image, :text,size: :long
    add_column :users, :overview, :text,size: :long
  end
end
