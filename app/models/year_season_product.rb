class YearSeasonProduct < ApplicationRecord
  belongs_to :year
  belongs_to :product
  belongs_to :season
end
