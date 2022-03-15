class Year < ApplicationRecord
  has_many :year_products, dependent: :destroy
  has_many :products, through: :year_products

  # 3tables
  has_many :year_season_products, dependent: :destroy
  has_many :year_season_product, through: :year_season_products, source: :product
  has_many :year_season_seasons,through: :year_season_products, source: :kisetsu
end
