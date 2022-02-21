class CreateKisetsuProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :kisetsu_products do |t|
      t.references :product,null: :false
      t.references :kisetsu,null: :false
      t.timestamps
    end
  end
end
