class ChangeYearTypes < ActiveRecord::Migration[6.1]
  def change
    change_column :years, :year, :date
  end
end
