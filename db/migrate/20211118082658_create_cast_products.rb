class CreateCastProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :cast_products do |t|
      t.references :cast ,index: true, foreign_key: true
      t.references :product ,index: true , foreign_key: true
      t.timestamps
    end
  end
end
