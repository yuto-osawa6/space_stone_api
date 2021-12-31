class Thered < ApplicationRecord
  belongs_to :product
  belongs_to :user

  has_many :thered_quesitons, dependent: :destroy
  has_many :questions, through: :thered_quesitons, source: :question
  # accepts_nested_attributes_for :thered_quesions, allow_destroy: true
end
