class AddnewsInformation < ActiveRecord::Migration[6.1]
  def change
    add_column :newmessages, :information, :text
  end
end
