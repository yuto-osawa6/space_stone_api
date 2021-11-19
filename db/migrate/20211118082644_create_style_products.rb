class CreateStyleProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :style_products do |t|
      t.references :style ,index: true, foreign_key: true
      t.references :product ,index: true , foreign_key: true
      t.timestamps
    end
  end
end
