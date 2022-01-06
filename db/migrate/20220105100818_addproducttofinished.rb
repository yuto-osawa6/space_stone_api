class Addproducttofinished < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :end, :boolean, default: false, null: false
  end
end
