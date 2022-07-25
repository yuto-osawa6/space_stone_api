class ForTierAddSort < ActiveRecord::Migration[6.1]
  def change
    add_column :tiers, :sort, :integer
  end
end
