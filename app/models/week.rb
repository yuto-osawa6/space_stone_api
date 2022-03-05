class Week < ApplicationRecord
  has_many :weeklyrankings,dependent: :destroy
  has_many :products,through: :weeklyrankings,souse: :product
end
