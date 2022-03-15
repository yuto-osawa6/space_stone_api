class CreateWeeklyrankings < ActiveRecord::Migration[6.1]
  def change
    create_table :weeklyrankings do |t|
      t.references :product,null: :false
      # t.references :product,null: :false
      t.datetime :weekly,null: :false
      t.integer :count
      t.timestamps
    end
  end
end
