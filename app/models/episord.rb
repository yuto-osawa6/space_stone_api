class Episord < ApplicationRecord
  belongs_to :product

  has_many :reviews
end
