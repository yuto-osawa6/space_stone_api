class CreateImpressionProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :impression_products do |t|
      t.references :products,null: false
      t.references :impressions,null: false
      t.timestamps
    end
  end
end
