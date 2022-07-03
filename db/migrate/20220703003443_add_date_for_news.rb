class AddDateForNews < ActiveRecord::Migration[6.1]
  def change
    add_column :newmessages, :date, :datetime
  end
end
