class CreateEpisords < ActiveRecord::Migration[6.1]
  def change
    create_table :episords do |t|
      t.references :product, null: false, foreign_key: true
      t.string :title
      t.text :arasuzi
      t.integer :episord
      t.integer :season
      t.string :season_title
      t.string :time
      t.text :image
      t.timestamps
    end
  end
end
