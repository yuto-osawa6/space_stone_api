class CreateThereds < ActiveRecord::Migration[6.1]
  def change
    create_table :thereds do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :title
      t.string :discribe
      t.text :content,size: :long
      t.timestamps
    end
  end
end
