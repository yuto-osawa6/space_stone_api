class TierGroup < ApplicationRecord
  has_many :tiers,dependent: :destroy
  has_many :users,through: :tiers,source: :user
  has_many :products,through: :tiers,source: :product

  belongs_to :year
  belongs_to :kisetsu
end
