class ForProductArasuziCopyright < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :arasuzi_copyright, :text
  end
end
