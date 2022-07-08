class ChangeDataProductWiki < ActiveRecord::Migration[6.1]
  def change
    change_column :products, :wiki, :text
    change_column :products, :wikiEn, :text
    change_column :products, :copyright, :text


  end
end
