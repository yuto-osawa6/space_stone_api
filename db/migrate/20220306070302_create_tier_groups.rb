class CreateTierGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :tier_groups do |t|
      t.references :year
      t.references :kisetsu
      t.timestamps
    end
  end
end
