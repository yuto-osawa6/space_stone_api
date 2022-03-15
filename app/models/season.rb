class Season < ApplicationRecord
  # # 3tables
  # has_many :year_season_products, dependent: :destroy
  # has_many :year_season_product, through: :year_season_products, source: :product
  # has_many :year_season_years,through: :year_season_products, source: :year
end
