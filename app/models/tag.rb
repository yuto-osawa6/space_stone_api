class Tag < ApplicationRecord
  belongs_to :month_during
  belongs_to :product
end
