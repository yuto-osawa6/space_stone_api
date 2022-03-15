class CreateWeeks < ActiveRecord::Migration[6.1]
  def change
    create_table :weeks do |t|
      # t.references :weekly
      t.datetime :week
      t.timestamps
    end
  end
end
