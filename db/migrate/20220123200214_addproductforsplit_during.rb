class AddproductforsplitDuring < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :season, :string
    add_column :products, :time, :time
  end
end
