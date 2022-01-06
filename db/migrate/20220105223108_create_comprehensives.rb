class CreateComprehensives < ActiveRecord::Migration[6.1]
  def change
    create_table :comprehensives do |t|
      t.references :product, null: false, foreign_key: true
      t.string :like
      t.string :score
      t.string :acsess
      t.integer :rank_count
      t.timestamps
    end
  end
end
