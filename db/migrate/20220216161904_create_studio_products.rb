class CreateStudioProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :studio_products do |t|
      t.references :products,null: :false
      t.references :studios,null: :false
      t.timestamps
    end
  end
end
