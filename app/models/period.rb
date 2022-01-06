class Period < ApplicationRecord
  has_many :toptens, dependent: :destroy
  has_many :toptens_products, through: :thereds, source: :product
end
