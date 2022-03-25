class AddTierColumn < ActiveRecord::Migration[6.1]
  def change
    add_reference :tiers,:user_tier_group,null: false
  end
end
