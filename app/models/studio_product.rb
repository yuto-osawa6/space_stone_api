class StudioProduct < ApplicationRecord
  belongs_to :product
  belongs_to :studio
end
