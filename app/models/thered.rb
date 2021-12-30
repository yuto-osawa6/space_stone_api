class Thered < ApplicationRecord
  belongs_to :product
  belongs_to :user

  has_many :thered_quesions, dependent: :destroy
  has_many :thered_question_questions, through: :thered_quesions, source: :quesion
end
