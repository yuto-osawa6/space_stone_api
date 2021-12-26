class AddAcsess < ActiveRecord::Migration[6.1]
  def change
    add_column :acsesses, :date, :datetime
  end
end
