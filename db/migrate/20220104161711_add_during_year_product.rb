class AddDuringYearProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :year, :string
    add_column :products, :duration, :string
  end
end
