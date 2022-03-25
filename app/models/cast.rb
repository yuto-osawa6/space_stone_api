class Cast < ApplicationRecord
  has_many :cast_products, dependent: :destroy
  has_many :products, through: :cast_products #2

  has_many :characters, dependent: :destroy
  has_many :products, through: :characters #2
end
