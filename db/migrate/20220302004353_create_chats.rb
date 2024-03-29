class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.references :product,null: false,foreign_key: true
      t.references :user,null: false,foreign_key: true
      t.text :message,null: false
      t.timestamps
    end
  end
end
