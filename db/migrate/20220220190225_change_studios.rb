class ChangeStudios < ActiveRecord::Migration[6.1]
  def change
    remove_reference :studio_products, :products
    remove_reference :studio_products, :studios
    add_reference :studio_products,:product,null: false
    add_reference :studio_products,:studio,null: false

    remove_reference :occupations,:products
    remove_reference :occupations,:staffs
    add_reference :occupations,:product
    add_reference :occupations,:staff

    remove_reference :characters,:products
    remove_reference :characters,:casts
    add_reference :characters,:product
    add_reference :characters,:cast


  end
end
