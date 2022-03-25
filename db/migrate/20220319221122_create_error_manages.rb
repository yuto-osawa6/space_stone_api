class CreateErrorManages < ActiveRecord::Migration[6.1]
  def change
    create_table :error_manages do |t|
      t.string :controller
      t.text :error
      t.timestamps
    end
  end
end
