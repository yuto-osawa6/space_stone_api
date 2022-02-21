class Staff < ApplicationRecord
  has_many :staff_products
  has_many :products, through: :staff_products
end
