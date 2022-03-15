class AddmigrationToProductOverView < ActiveRecord::Migration[6.1]
  def change
    add_column :products,:overview,:text
  end
end
