class CreateTheredQuesitons < ActiveRecord::Migration[6.1]
  def change
    create_table :thered_quesitons do |t|
      t.references :thered, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.timestamps
    end
  end
end
