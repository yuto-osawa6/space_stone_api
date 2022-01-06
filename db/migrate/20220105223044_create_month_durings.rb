class CreateMonthDurings < ActiveRecord::Migration[6.1]
  def change
    create_table :month_durings do |t|
      t.datetime :month
      t.timestamps
    end
  end
end
