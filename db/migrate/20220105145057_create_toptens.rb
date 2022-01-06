class CreateToptens < ActiveRecord::Migration[6.1]
  def change
    create_table :toptens do |t|
      t.references :period, null: false, foreign_key: true
      t.references :product, foreign_key: true
      t.string :title
      t.string :list
      t.string :category
      t.integer :rank
      t.timestamps
    end
  end
end
