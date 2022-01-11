class Addimageandnetflixjapantotoptens < ActiveRecord::Migration[6.1]
  def change

    add_column :toptens, :image_url,:text
    add_column :toptens, :netflix_japan, :boolean, default: false, null: false
  end
end
