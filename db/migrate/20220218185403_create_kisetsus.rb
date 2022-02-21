class CreateKisetsus < ActiveRecord::Migration[6.1]
  def change
    create_table :kisetsus do |t|
      t.string :name
      t.timestamps
    end
  end
end
