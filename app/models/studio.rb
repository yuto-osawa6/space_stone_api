class Studio < ApplicationRecord
  has_many :studio_products
  has_many :products, through: :studio_products
end
