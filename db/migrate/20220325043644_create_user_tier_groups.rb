class CreateUserTierGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :user_tier_groups do |t|
      t.references :tier_group,null: false
      t.references :user,null: false
      t.timestamps
    end
  end
end
