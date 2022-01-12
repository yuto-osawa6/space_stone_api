class Topten < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :period
end
