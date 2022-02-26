class CreateYearSeasonProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :year_season_products do |t|
      t.references :product,null: :false
      t.references :year,null: :false
      t.references :kisetsu,null: :false
      t.timestamps
    end
  end
end
