class AddProductColumsImages < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :image_url2,:text
    add_column :products, :image_url3,:text
    add_column :products, :horizontal_image_url,:text
    add_column :products, :horizontal_image_url2,:text
    add_column :products, :horizontal_image_url3,:text
  end
end
