class Addsliptcolumntoproduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :pickup, :boolean, default: false, null: false
    add_column :products, :decision_news, :boolean, default: false, null: false
    add_column :products, :delivery_end, :string
    add_column :products, :delivery_start, :string
    add_column :products, :episord_start, :string
  end
end
