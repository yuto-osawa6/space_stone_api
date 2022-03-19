class Kisetsu < ApplicationRecord
  has_many :kisetsu_products, dependent: :destroy
  has_many :products, through: :kisetsu_products

    # 3tables
    has_many :year_season_products, dependent: :destroy
    has_many :year_season_product, through: :year_season_products, source: :product
    has_many :year_season_years,through: :year_season_products, source: :year
end
