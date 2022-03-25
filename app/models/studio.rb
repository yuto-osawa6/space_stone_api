class Studio < ApplicationRecord
  has_many :studio_products, dependent: :destroy
  has_many :products, through: :studio_products
end
