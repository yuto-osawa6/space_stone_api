class CreateNewmessages < ActiveRecord::Migration[6.1]
  def change
    create_table :newmessages do |t|
      t.string :title
      t.text :description
      t.integer :judge
      t.timestamps
    end
  end
end
