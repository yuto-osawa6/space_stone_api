class Addchangedataproducttoseason < ActiveRecord::Migration[6.1]
  def change
    change_column :products, :season, :integer
  end
end
