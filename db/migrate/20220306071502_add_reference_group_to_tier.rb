class AddReferenceGroupToTier < ActiveRecord::Migration[6.1]
  def change
    add_reference :tiers,:tier_group,null: false
  end
end
