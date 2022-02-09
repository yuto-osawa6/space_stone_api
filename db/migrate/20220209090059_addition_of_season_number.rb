class AdditionOfSeasonNumber < ActiveRecord::Migration[6.1]
  def change
    add_column :seasons, :season_number, :integer
  end
end
