class CreateHashtagArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :hashtag_articles do |t|
      t.references :hashtag,null: false,foreign_key: true
      t.references :article,null: false,foreign_key: true
      t.timestamps
    end
  end
end
