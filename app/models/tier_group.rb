class TierGroup < ApplicationRecord
  has_many :tiers,dependent: :destroy
  has_many :users,through: :tiers,source: :user
  has_many :products,through: :tiers,source: :product
  has_many :user_tier_groups2,through: :tiers,source: :user_tier_group

  has_many :user_tier_groups,dependent: :destroy
  has_many :users,through: :user_tier_groups,source: :user

  belongs_to :year
  belongs_to :kisetsu
end
