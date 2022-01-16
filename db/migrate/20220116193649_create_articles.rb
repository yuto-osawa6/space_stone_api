class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.references :product, foreign_key: true
      t.text  :content,size: :long
      t.string :title 
      t.boolean :week
      t.boolean :month
      t.datetime :time
      t.timestamps
    end
  end
end
