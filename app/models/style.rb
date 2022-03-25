class Style < ApplicationRecord
  has_many :style_products, dependent: :destroy
  has_many :products, through: :style_products #2
end
