class CreateCharacterProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :character_products do |t|
      t.references :products,null: :false
      t.references :characters,null: :false
      t.timestamps
    end
  end
end
