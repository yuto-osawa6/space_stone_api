class Tier < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :tier_group
end
