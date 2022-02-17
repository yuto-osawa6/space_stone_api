class CreateStudios < ActiveRecord::Migration[6.1]
  def change
    create_table :studios do |t|
      t.string :company, null: false
      t.string :overview
      t.text :image
      t.timestamps
    end
  end
end
