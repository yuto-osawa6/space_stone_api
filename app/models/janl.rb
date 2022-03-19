class Janl < ApplicationRecord
  has_many :janl_products, dependent: :destroy
  has_many :products, through: :janl_products #2
end
