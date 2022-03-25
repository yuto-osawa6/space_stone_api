class UserTierGroup < ApplicationRecord
  belongs_to :user
  belongs_to :tier_group

  has_many :tiers,dependent: :destroy
  has_many :users,through: :tiers,source: :user
  has_many :products,through: :tiers,source: :product
  has_many :tier_groups,through: :tiers,source: :tier_group
end
