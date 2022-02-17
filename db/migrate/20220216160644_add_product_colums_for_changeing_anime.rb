class AddProductColumsForChangeingAnime < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :kisetsu, :string
  end
end
