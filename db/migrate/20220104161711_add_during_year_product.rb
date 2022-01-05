class AddDuringYearProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :year, :string
    add_column :products, :duration, :string
    add_column :products, :new_content, :boolean, default: false, null: false

  end
end
