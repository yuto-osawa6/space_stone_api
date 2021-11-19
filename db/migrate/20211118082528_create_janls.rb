class CreateJanls < ActiveRecord::Migration[6.1]
  def change
    create_table :janls do |t|
      t.string :name
      t.text :link
      t.timestamps
    end
  end
end
