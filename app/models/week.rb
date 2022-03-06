class Week < ApplicationRecord
  has_many :weeklyrankings,dependent: :destroy
  has_many :products,through: :weeklyrankings,source: :product

  has_many :week_episords,dependent: :destroy
  has_many :episords,through: :week_episords,source: :episord
end
