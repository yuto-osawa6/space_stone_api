class Kisetsu < ApplicationRecord
  has_many :kisetsu_products
  has_many :products, through: :kisetsu_products
end
