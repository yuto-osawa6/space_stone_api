class Question < ApplicationRecord
  has_many :thered_quesitons, dependent: :destroy
  has_many :thereds, through: :thered_quesitons, source: :thered
end
