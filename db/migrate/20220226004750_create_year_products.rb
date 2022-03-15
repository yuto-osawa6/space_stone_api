class CreateYearProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :year_products do |t|
      t.references :product,null: :false
      t.references :year,null: :false
      t.timestamps
    end
  end
end
