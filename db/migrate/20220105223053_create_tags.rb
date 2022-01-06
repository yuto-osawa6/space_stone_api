class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.references :month_during, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :tag
      t.timestamps
    end
  end
end
