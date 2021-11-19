class Style < ApplicationRecord
  has_many :style_products
  has_many :products, through: :style_products #2
end
