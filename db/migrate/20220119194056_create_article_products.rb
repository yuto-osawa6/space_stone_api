class CreateArticleProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :article_products do |t|
      t.references :article
      t.references :product
      t.timestamps
    end
  end
end
