class AddProductInfomations < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :titleKa, :string
    add_column :products, :titleEn, :string
    add_column :products, :titleRo, :string
    add_column :products, :annitict, :integer
    add_column :products, :shoboiTid, :integer
    add_column :products, :wiki, :string
    add_column :products, :wikiEn, :string
    add_column :products, :copyright, :string
  end
end
