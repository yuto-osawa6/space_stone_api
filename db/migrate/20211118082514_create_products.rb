class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :image_url
      t.text :description
      t.text :list
      t.string :end_day
      t.boolean :finished,default: false, null: false
      t.timestamps
    end
  end
end
