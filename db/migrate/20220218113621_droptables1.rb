class Droptables1 < ActiveRecord::Migration[6.1]
  def change
    drop_table :cast_products do |t|
      t.references :casts
      t.resources :products
      t.timestamps null: false
    end

    drop_table :character_products do |t|
      t.references :charanters
      t.resources :products
      t.timestamps null: false
    end

    drop_table :staff_products do |t|
      t.references :occupations
      t.resources :products
      t.resources :staffs
      t.timestamps null: false
    end

  end


end
