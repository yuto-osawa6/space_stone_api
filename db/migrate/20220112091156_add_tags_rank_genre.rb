class AddTagsRankGenre < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :rank, :integer
    add_column :tags, :genre, :integer
    add_column :tags, :month_title, :string
  end
end
