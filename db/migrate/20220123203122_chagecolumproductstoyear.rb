class Chagecolumproductstoyear < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :year2,:date
  end
end
