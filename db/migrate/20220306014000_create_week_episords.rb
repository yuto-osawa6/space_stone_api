class CreateWeekEpisords < ActiveRecord::Migration[6.1]
  def change
    create_table :week_episords do |t|
      t.references :episord,null: false
      t.references :week,null: false
      t.timestamps
    end
  end
end
