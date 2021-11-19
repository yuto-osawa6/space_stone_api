class CreateJanlProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :janl_products do |t|
      t.references :janl,index: true, foreign_key: true
      t.references :product ,index: true , foreign_key: true
      t.timestamps
    end
  end
end
