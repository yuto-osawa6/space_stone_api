class MonthDuring < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :tags_products, through: :thereds, source: :product
end
