class Cast < ApplicationRecord
  has_many :cast_products
  has_many :products, through: :cast_products #2
end
