class Staff < ApplicationRecord
  has_many :staff_products, dependent: :destroy
  has_many :products, through: :staff_products
end
