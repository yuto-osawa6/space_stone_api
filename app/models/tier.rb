class Tier < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :tier_group
  belongs_to :user_tier_group
end
