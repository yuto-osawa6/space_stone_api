class CreateTrends < ActiveRecord::Migration[6.1]
  def change
    create_table :trends do |t|
      t.references :product,null: false,foreign_key: true
      t.integer :count,default: 0
      t.timestamps
    end
  end
end
